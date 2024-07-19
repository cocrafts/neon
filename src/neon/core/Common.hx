package neon.core;

import haxe.macro.Type.TVar;
import haxe.macro.ExprTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import neon.core.State;
import haxe.extern.EitherType;

typedef FC<T> = (props:T) -> VirtualNode;
typedef FunctionComponent = (props:Dynamic) -> VirtualNode;
typedef NodeCreator = EitherType<String, FunctionComponent>;

typedef MacroError = {
	var message:String;
	var pos:Position;
};

typedef VirtualNode = {
	var tag:NodeCreator;
	var props:Dynamic;
	var ?key:String;
	var ?ref:Dynamic;
	var ?effect:Effect;
}

function transformProps(props:Expr, blocks:Array<Expr>, localTVars:Map<String, TVar>):MacroError {
	switch (props.expr) {
		case EObjectDecl(fields):
			for (prop in fields) {
				if (prop.field == "style") {
					switch (prop.expr.expr) {
						case EField(e, _, _):
							switch (e.expr) {
								case EConst(CIdent(_)):
									blocks.push(macro neon.platform.Renderer.universalStyle(${prop.expr}, el));
								default:
							}
						default:
							return {message: "this type of style is not supported", pos: props.pos};
					}
				}
			}
		case EConst(CIdent(ident)): /* received prop from external declaration source */
			blocks.push(macro neon.platform.Renderer.universalRuntimeProps($i{ident}, el));
		case EBlock(_): // ignore empty object {}
		default:
			trace(props);
			return {message: "props must be object", pos: props.pos};
	}

	return null;
}

function transformChildren(children:Expr, blocks:Array<Expr>, localTVars:Map<String, TVar>):MacroError {
	switch (children.expr) {
		case EArrayDecl(items):
			for (item in items) {
				switch (item.expr) {
					case ECall(f, args):
						blocks.push(macro neon.platform.Renderer.universalInsert(function() {
							return ${f}($a{args});
						}, el, null));
					case EConst(CString(_)):
						blocks.push(macro neon.platform.Renderer.universalInsert($e{item}, el, null));
					case EConst(CIdent("false")), EConst(CIdent("true")):
						blocks.push(macro neon.platform.Renderer.universalInsert(false, el, null));
					case EConst(CIdent(id)):
						{
							var idInfo = localTVars.get(id);
							switch (idInfo?.t) {
								case TFun([], TInst(_, [])): /* highly chance this is a function component */
									blocks.push(macro neon.platform.Renderer.universalInsert($i{id}(), el, null));
								default:
									blocks.push(macro neon.platform.Renderer.universalInsert($i{id}, el, null));
							}
						}
					case EFunction(_, _):
						blocks.push(macro neon.platform.Renderer.universalInsert(($e{item})(), el, null));
					case EObjectDecl(_), EField(_, _, _):
						blocks.push(macro neon.platform.Renderer.universalInsert($e{item}, el, null));
					case ETernary(_, _, _), EBinop(_, _, _):
						blocks.push(macro neon.platform.Renderer.universalInsert(function() {
							return $e{item};
						}, el, null));
					default:
						trace(item);
						return {message: 'un-handled children type ${item.expr.getName()}', pos: item.pos};
				}
			}
		default:
	}

	return null;
}

function transformElement(tag:Expr, props:Expr, children:Expr, localTVars:Map<String, TVar>):EitherType<Expr, MacroError> {
	var blocks:Array<Expr> = [];

	var propError = transformProps(props, blocks, localTVars);
	if (propError != null) {
		return propError;
	}

	var childrenError = transformChildren(children, blocks, localTVars);
	if (childrenError != null) {
		return childrenError;
	}

	blocks.push(macro return el);

	switch (tag.expr) {
		case EConst(CString(elementTag)):
			return macro function() {
				var el = neon.platform.Renderer.universalMakeElement($i{elementTag});
				$b{blocks};
			}
		default:
			return {message: "invalid tag, should be string or function", pos: tag.pos};
	}
}

macro function createElement(tag:Expr, props:Expr, children:Expr):Expr {
	var localTVars = Context.getLocalTVars();

	function processCreateElement(tag:Expr, props:Expr, children:Expr):Expr {
		var blocks:Array<Expr> = [];
		var localTVars = Context.getLocalTVars();

		var propError = transformProps(props, blocks, localTVars);
		if (propError != null) {
			Context.error(propError.message, propError.pos);
		}

		var childrenError = transformChildren(children, blocks, localTVars);
		if (childrenError != null) {
			Context.error(childrenError.message, childrenError.pos);
		}

		blocks.push(macro return el);

		switch (tag.expr) {
			case EConst(CString(elementTag)):
				return macro function() {
					var el = neon.platform.Renderer.universalMakeElement($v{elementTag});
					$b{blocks};
				}
			case EFunction(FAnonymous, f):
				{
					var innerBlocks:Array<Expr> = [];

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
															trace("valid!!!", args);
														} else {
															Context.error('invalid <FC> return: ${functionName}, must be createElement', ce.pos);
														}
													default:
														Context.error("invalid <FC> return: must be createElement(..) call", ce.pos);
												}
												trace(ce);
											default:
												Context.error("invalid <FC> return: must be a call", re.pos);
										}
									default:
										innerBlocks.push(item);
								}
								trace(item);
							}
						default:
							trace(f.expr.expr);
					}
					trace(f);
					return tag;
				}
			default:
				trace(tag.expr);
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
		case EConst(_):
			[macro $e{children}];
		default:
			Context.error("invalid children", children.pos);
	}

	// trace(ExprTools.toString(processCreateElement(tag, props, {
	// 	pos: children.pos,
	// 	expr: EArrayDecl(processedChildren),
	// })));

	return processCreateElement(tag, props, {
		pos: children.pos,
		expr: EArrayDecl(processedChildren),
	});
}

// macro function createComponent(func:Expr):Expr {
// 	trace(func);
// 	return func;
// }
// function createComponent<T>(func:T->Dynamic):Dynamic {
// 	trace("how about this");
// 	return function(props):Dynamic {
// 		trace("Hmm");
// 		return func(props);
// 	}
// }

var nsUri = "http://www.w3.org/2000/svg";
