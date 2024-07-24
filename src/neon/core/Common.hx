package neon.core;

import haxe.Timer;
import haxe.macro.Context;
import haxe.macro.Expr;
import neon.core.Helper;

macro function createElement(tag:Expr, props:Expr, ?children:Expr):Expr {
	var localTVars = Context.getLocalTVars();

	function processCreateElement(tag:Expr, props:Expr, ?children:Expr):Expr {
		var blocks:Array<Expr> = [];
		var localTVars = Context.getLocalTVars();

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

		var childrenError = transformChildren(children, blocks, localTVars);
		if (childrenError != null) {
			Context.error(childrenError.message, childrenError.pos);
		}

		blocks.push(macro return el);

		switch (tag.expr) {
			case EConst(CString(elementTag)):
				return macro function() {
					var el = neon.core.Renderer.makeElement($v{elementTag});
					$b{blocks};
				}
			default:
				return Context.error("invalid tag, should be string or function", tag.pos);
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

	trace(haxe.macro.ExprTools.toString(transformedElement));
	return transformedElement;
}

macro function createComponent(func:Expr):Expr {
	var blocks:Array<Expr> = [];
	var fArgs:Array<FunctionArg>;
	var returnBlock:Expr;

	switch (func.expr) {
		case EFunction(FAnonymous, f):
			fArgs = f.args;

			switch (f.expr.expr) {
				case EBlock(items):
					for (item in items) {
						switch (item.expr) {
							case EReturn(re):
								switch (re.expr) {
									case ECall(ce, args):
										switch (ce.expr) {
											case EConst(CIdent(functionName)):
												if (functionName == "createElement") {
													var resultExpr = {pos: re.pos, expr: re.expr};
													blocks.push(macro var el = $e{resultExpr}());
													blocks.push(macro return el);
												} else {
													Context.error('invalid <FC> return: ${functionName}, must be createElement', ce.pos);
												}
											default:
												Context.error("invalid <FC> return: must be createElement(..) call", ce.pos);
										}
									default:
										Context.error("invalid <FC> return: must be a call", re.pos);
								}
							default:
								blocks.push(item);
						}
					}
				default:
					Context.error("malformed function structure", f.expr.pos);
			}
		default:
			Context.error("expected a function", func.pos);
	}

	var functionComponentExpr = {
		pos: func.pos,
		expr: EFunction(FAnonymous, {
			ret: null,
			params: [],
			args: fArgs,
			expr: {
				pos: func.pos,
				expr: EBlock(blocks),
			},
		}),
	};

	// trace(haxe.macro.ExprTools.trace(functionComponentExpr));
	return functionComponentExpr;
}

function setInterval(callback:Void->Void, interval:Int):Timer {
	var timer = new Timer(interval);
	timer.run = callback;
	return timer;
}
