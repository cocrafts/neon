package neon.core;

import haxe.macro.ExprTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import neon.core.State;
import haxe.extern.EitherType;

typedef FC<T> = (props:T) -> VirtualNode;
typedef FunctionComponent = (props:Dynamic) -> VirtualNode;
typedef NodeCreator = EitherType<String, FunctionComponent>;

typedef VirtualNode = {
	var tag:NodeCreator;
	var props:Dynamic;
	var ?key:String;
	var ?ref:Dynamic;
	var ?effect:Effect;
}

macro function createElement(tag:Expr, props:Expr, children:Expr):Expr {
	function processCreateElement(tag:Expr, props:Expr, children:Expr):Expr {
		var blocks:Array<Expr> = [];
		var localTVars = Context.getLocalTVars();

		switch (props.expr) {
			case EObjectDecl(fields):
				for (prop in fields) {
					if (prop.field == "style") {
						switch (prop.expr.expr) {
							case EField(e, f, k):
								switch (e.expr) {
									case EConst(CIdent(field)):
										blocks.push(macro neon.platform.Renderer.universalStyle(${prop.expr}, el));
										trace(localTVars);
										trace(field);
									default:
								}
							default:
								Context.error("this type of style is not supported", props.pos);
						}
					}
				}
			case EBlock(blocks): // ignore empty object {}
			default:
				Context.error("props must be object", props.pos);
		}

		if (children?.expr != null) {
			switch (children.expr) {
				case EArrayDecl(items):
					for (item in items) {
						switch (item.expr) {
							case EConst(CString(value)):
								blocks.push(macro neon.platform.Renderer.universalInsert($v{value}, el, null));
							case ECall(f, args):
								blocks.push(macro neon.platform.Renderer.universalInsert(function() {
									${f}($a{args});
									return ${f}($a{args});
								}, el, null));
							case EConst(CIdent(id)):
								var idInfo = localTVars.get(id);

								switch (idInfo.t) {
									case TFun([], TInst(_, [])): /* highly chance this is a function component */
										blocks.push(macro neon.platform.Renderer.universalInsert($i{id}(), el, null));
									case TAbstract(_, []): /* primitive like Int, Bool... */
										blocks.push(macro neon.platform.Renderer.universalInsert($i{id}, el, null));
									case TInst(_, []): /* String */
										blocks.push(macro neon.platform.Renderer.universalInsert($i{id}, el, null));
									default:
										Context.error('un-handled variable type', item.pos);
								}

							case EFunction(kind, f):
								blocks.push(macro neon.platform.Renderer.universalInsert(($e{item})(), el, null));
							case EObjectDecl(_):
								blocks.push(macro neon.platform.Renderer.universalInsert($e{item}, el, null));
							case ETernary(_econd, _eif, _eelse):
								blocks.push(macro neon.platform.Renderer.universalInsert(function() {
									return $e{item};
								}, el, null));
							case EBinop(_op, _e1, _e2):
								blocks.push(macro neon.platform.Renderer.universalInsert(function() {
									return $e{item};
								}, el, null));
							default:
								Context.error('un-handled children type ${item.expr.getName()}', item.pos);
						}
					}
				default:
			}
		}

		blocks.push(macro return el);

		switch (tag.expr) {
			case EConst(CString(elementTag)):
				{
					return macro function() {
						var el = neon.platform.Renderer.universalMakeElement($v{elementTag});
						$b{blocks};
					}
				}
			default:
				return Context.error("invalid tag, should be string or function", tag.pos);
		}

		return tag;
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
		default:
			return children;
	}

	trace(ExprTools.toString(processCreateElement(tag, props, {
		pos: children.pos,
		expr: EArrayDecl(processedChildren),
	})));

	return processCreateElement(tag, props, {
		pos: children.pos,
		expr: EArrayDecl(processedChildren),
	});
}

var nsUri = "http://www.w3.org/2000/svg";
