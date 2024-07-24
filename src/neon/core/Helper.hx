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
