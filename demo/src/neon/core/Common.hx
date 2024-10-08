package neon.core;

import haxe.macro.Expr;
import haxe.macro.Context;
import neon.core.Helper;

macro function createElement(tag:Expr, props:Expr, ?children:Expr):Expr {
	var localTVars = Context.getLocalTVars();

	function processCreateElement(tag:Expr, props:Expr, ?children:Expr):Expr {
		var blocks:Array<Expr> = [];
		var localTVars = Context.getLocalTVars();

		/* transform props, translate props, including style 
		 * into closured function blocks */

		switch (props.expr) {
			case EObjectDecl(fields):
				for (prop in fields) {
					if (prop.field == "style") {
						switch (prop.expr.expr) {
							case EField(e, _, _):
								switch (e.expr) {
									case EConst(CIdent(_)):
										blocks.push(macro neon.core.Renderer.prop("style", $e{prop.expr}, el));
									default:
								}
							case EObjectDecl(items):
								for (item in items) {
									switch (item.expr.expr) {
										case EConst(CInt(_)), EConst(CFloat(_)), EConst(CString(_)):
											trace(item.expr);
											blocks.push(macro neon.core.Renderer.style($v{item.field}, $e{item.expr}, el));
										case ECall(_):
											blocks.push(macro neon.core.Renderer.style($v{item.field}, function() {
												return $e{item.expr};
											}, el));
										default:
											Context.error("style attribute not supported", props.pos);
									}
								}
							case EBlock([]):
								Context.warning("empty style will be cleanup for performance", prop.expr.pos);
							default:
								trace(prop);
								Context.error("this type of style is not supported", props.pos);
						}
					} else {
						switch (prop.expr.expr) {
							case EConst(CString(_, _)):
								if (prop.field == "className") {
									blocks.push(macro neon.core.Renderer.prop("class", ${prop.expr}, el));
								} else {
									blocks.push(macro neon.core.Renderer.prop($v{prop.field}, ${prop.expr}, el));
								}
							case EConst(CInt(_, _)):
								blocks.push(macro neon.core.Renderer.prop($v{prop.field}, ${prop.expr}, el));
							case EConst(CIdent(_)): /* Boolean */
								blocks.push(macro neon.core.Renderer.prop($v{prop.field}, ${prop.expr}, el));
							case EField(_):
								blocks.push(macro neon.core.Renderer.prop($v{prop.field}, ${prop.expr}, el));
							case EFunction(FAnonymous, f):
								blocks.push(macro neon.core.Renderer.prop($v{prop.field}, ${prop.expr}, el));
							case ECall(_): /* prop as function call, e.g: Math.round(a * b) */
								blocks.push(macro neon.core.Renderer.prop($v{prop.field}, function() {
									return ${prop.expr};
								}, el));
							default:
								// blocks.push(macro neon.platform.Renderer.prop($v{prop.field}, ${prop.expr}, el));
								Context.error("this type of prop is not supported", props.pos);
						}
					}
				}
			case EConst(CIdent(ident)): /* received prop from external declaration source */
				blocks.push(macro neon.core.Renderer.runtimeProps($i{ident}, el));
			case EBlock(_): // ignore empty object {}
			default:
				Context.error("props must be object", props.pos);
		}

		/* transform children make closured function blocks,
		 * those closures also setup component hierarchy on it's execution (run only once on startup) */

		var children = ensureArray(children);

		switch (children.expr) {
			case EArrayDecl(items):
				for (item in items) {
					switch (item.expr) {
						case ECall(f, args):
							blocks.push(macro neon.core.Renderer.insert(function() {
								return ${f}($a{args});
							}, el));
						case EConst(CString(val)):
							if (val.indexOf("${") >= 0 && val.indexOf("()") > 0) {
								blocks.push(macro neon.core.Renderer.insert(function() {
									return $e{item};
								}, el));
							} else {
								blocks.push(macro neon.core.Renderer.insert($e{item}, el));
							}
						case EConst(CIdent("false")), EConst(CIdent("true")):
							blocks.push(macro neon.core.Renderer.insert(false, el));
						case EConst(CInt(_)), EConst(CFloat(_)):
							blocks.push(macro neon.core.Renderer.insert($e{item}, el));
						case EConst(CIdent(id)):
							{
								var idInfo = localTVars.get(id);

								switch (idInfo?.t) {
									case TFun([], TInst(_, [])): /* highly chance this is a function component */
										blocks.push(macro neon.core.Renderer.insert($i{id}(), el));
									case TAbstract(_, _): /* from createComponent's children arg */
										blocks.push(macro neon.core.Renderer.insert($i{id}, el));
									default:
										Context.warning("double check this children type", item.pos);
										blocks.push(macro neon.core.Renderer.insert($i{id}, el));
								}
							}
						case EFunction(_, _):
							blocks.push(macro neon.core.Renderer.insert(($e{item})(), el));
						case EObjectDecl(_), EField(_, _, _):
							blocks.push(macro neon.core.Renderer.insert($e{item}, el));
						case ETernary(_, _, _), EBinop(_, _, _):
							blocks.push(macro neon.core.Renderer.insert(function() {
								return $e{item};
							}, el));
						default:
							Context.error('un-handled children type ${item.expr.getName()}', item.pos);
					}
				}
			default:
		}

		blocks.push(macro return el);

		switch (tag.expr) {
			case EConst(CString(elementTag)):
				return macro function() {
					var el = neon.core.Renderer.makeElement($v{elementTag});
					$b{blocks};
				}
			default:
				return Context.error("invalid tag, must be a string", tag.pos);
		}
	}

	var processedChildren:Dynamic = switch (children.expr) {
		case EArrayDecl(elements):
			elements.map(function(child:Expr):Expr {
				switch (child.expr) {
					case ECall(expr, args):
						switch expr.expr {
							case EConst(CIdent(functionName)):
								if (functionName == "createElement") {
									return processCreateElement(args[0], args[1], args[2]);
								}
							default:
						}
					default:
				}

				return child;
			});
		case EConst(_), ECall(_): // Single constant children
			[macro $e{children}];
		default:
			Context.error("invalid children", children.pos);
	}

	var transformedElement = processCreateElement(tag, props, {
		pos: children.pos,
		expr: EArrayDecl(processedChildren),
	});

	// trace(haxe.macro.ExprTools.toString(transformedElement));
	return transformedElement;
}
