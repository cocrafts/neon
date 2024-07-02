package neon.macro;

import haxe.macro.Expr;

macro function duplicate(e:Expr):Expr {
	return {expr: EBlock([e, e]), pos: e.pos};
}
