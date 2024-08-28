package neon.core;

@:headerInclude("neon-Swift.h")
@:valueType
@:native("neon::Element") extern class Element {
	public function new();
	public function setProp(key:String, value:String):Void;
	public function addChild(el:Element):Void;
}
