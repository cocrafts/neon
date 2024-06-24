package neon.macro;

import haxe.macro.Expr;

macro function duplicate(e:Expr):Expr {
	trace(e);
	return { expr: EBlock([e, e]), pos: e.pos };
}
