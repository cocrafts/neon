package neon;

@:headerCode('
#include <NeonKore.h>
')
class Neon {
	@:functionCode('return NeonKore::greet(name);')
	public static function greet(name:String):String {
		return "";
	};

	@:functionCode('NeonKore::createNSView(x, y, width, height);')
	public static function createNSView(x:Float, y:Float, width:Float, height:Float):Void {};

	@:functionCode('NeonKore::setNSViewBackgroundColor(red, green, blue, alpha);')
	public static function setNSViewBackgroundColor(red:Float, green:Float, blue:Float, alpha:Float):Void {};

	@:functionCode('NeonKore::initialize();')
	public static function initialize():Void {};

	@:functionCode('NeonKore::run();')
	public static function run():Void {};
}
