package neon.rml;

import kha.math.Vector2i;

@:native("Rml::Context") extern class Context {
	public function new(name:String, renderManager:RenderManager, textInputHandler:TextInputHandler):Void;
	public function setDimensions(dimensions:Vector2i):Void;
	public function Update():Bool;
	public function Render():Bool;
}
