package neon.core;

import haxe.macro.Type.TVar;
import haxe.macro.Expr;

private var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

typedef MacroError = {
	var message:String;
	var pos:Position;
};

function randomChar():String {
	return chars.charAt(Math.floor(Math.random() * chars.length));
}

function generateUniqueId():String {
	var id = "";

	for (i in 0...8) {
		id += randomChar();
	}

	return id;
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
									blocks.push(macro neon.platform.Renderer.style(${prop.expr}, el));
								default:
							}
						default:
							return {message: "this type of style is not supported", pos: props.pos};
					}
				} else {
					switch (prop.expr.expr) {
						case EField(e, _, _):
							switch (e.expr) {
								case EConst(CIdent(_)):
									trace(e, "props <<----");
								default:
							}
						case EFunction(FAnonymous, f):
							var propCallExpr = macro neon.platform.Renderer.prop($i{prop.field}, ${f.expr}, el);
							trace(propCallExpr, haxe.macro.ExprTools.toString(propCallExpr), "<--");
						// blocks.push(macro neon.platform.Renderer.prop(${prop.field}, ${f.expr}, el));
						default:
							trace(prop);
							return {message: "this type of prop is not supported", pos: props.pos};
					}
				}
			}
		case EConst(CIdent(ident)): /* received prop from external declaration source */
			blocks.push(macro neon.platform.Renderer.runtimeProps($i{ident}, el));
		case EBlock(_): // ignore empty object {}
		default:
			return {message: "props must be object", pos: props.pos};
	}

	return null;
}

function ensureArray(children:Expr):Expr {
	if (children == null) {
		return macro [];
	}

	switch (children.expr) {
		case EArrayDecl(_):
			return children;
		default:
			return macro [$e{children}];
	}
}

function transformChildren(maybeChildren:Expr, blocks:Array<Expr>, localTVars:Map<String, TVar>):MacroError {
	var children = ensureArray(maybeChildren);

	switch (children.expr) {
		case EArrayDecl(items):
			for (item in items) {
				switch (item.expr) {
					case ECall(f, args):
						blocks.push(macro neon.platform.Renderer.insert(function() {
							return ${f}($a{args});
						}, el));
					case EConst(CString(_)):
						blocks.push(macro neon.platform.Renderer.insert($e{item}, el));
					case EConst(CIdent("false")), EConst(CIdent("true")):
						blocks.push(macro neon.platform.Renderer.insert(false, el));
					case EConst(CIdent(id)):
						{
							var idInfo = localTVars.get(id);

							switch (idInfo?.t) {
								case TFun([], TInst(_, [])): /* highly chance this is a function component */
									blocks.push(macro neon.platform.Renderer.insert($i{id}(), el));
								case TAbstract(_, _): /* from createComponent's children arg */
									blocks.push(macro neon.platform.Renderer.insert($i{id}, el));
								default:
									blocks.push(macro neon.platform.Renderer.insert($i{id}, el));
							}
						}
					case EFunction(_, _):
						blocks.push(macro neon.platform.Renderer.insert(($e{item})(), el));
					case EObjectDecl(_), EField(_, _, _):
						blocks.push(macro neon.platform.Renderer.insert($e{item}, el));
					case ETernary(_, _, _), EBinop(_, _, _):
						blocks.push(macro neon.platform.Renderer.insert(function() {
							return $e{item};
						}, el));
					default:
						return {message: 'un-handled children type ${item.expr.getName()}', pos: item.pos};
				}
			}
		default:
	}

	return null;
}
