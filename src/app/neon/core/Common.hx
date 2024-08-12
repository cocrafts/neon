package neon.core;

// import haxe.Timer;
import haxe.macro.Expr;
import haxe.macro.Context;

macro function createElement(tag:Expr, props:Expr, ?children:Expr):Expr {
	var localTVars = Context.getLocalTVars();
	trace(localTVars);
	return tag;
}
// function setInterval(callback:Void->Void, interval:Int):Timer {
// 	var timer = new Timer(interval);
// 	timer.run = callback;
// 	return timer;
// }
