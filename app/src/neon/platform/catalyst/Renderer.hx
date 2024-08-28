package neon.platform.catalyst;

import neon.core.Renderer as CoreRenderer;
import neon.core.Element;

@native("Atomic") extern enum Atomic {
	string(s:String);
	float(f:Float);
	int(i:Int);
}

@:headerInclude("NeonCore.h")
@:headerInclude("NeonBridge.h")
@:headerInclude("NeonRenderer.h")
class Renderer {
	public static function render(container:Element, elementFunc:() -> Element, ?props:Map<String, Any>) {
		CoreRenderer.registerBundle({
			makeElement: makeElement,
			insert: insert,
			style: setStyle,
			prop: setProp,
			props: setProps,
		});

		trace("before insert");
		insert(elementFunc(), container);
		CoreRenderer.freeBundle();
	}

	public static function getRootElement():Element {
		return untyped __cpp__("neon::platform::catalyst::getRootElement()");
	}

	public static function makeElement(tag:String):Element {
		return untyped __cpp__("neon::platform::catalyst::makeElement({0})", tag);
	}

	public static function insert(node:Element, container:Element, ?position:Int):Int {
		trace("inserting..");
		return untyped __cpp__("neon::platform::catalyst::insert({0}, {1}, {2})", node, container, position);
	}

	public static function setStyle(attribute:String, value:Any, el:Element):Void {
		return untyped __cpp__("neon::platform::catalyst::setStyle({0}, {1}, {2})", attribute, value, el);
	}

	public static function setProp(name:String, value:Any, el:Element):Void {
		return untyped __cpp__("neon::platform::catalyst::setProp({0}, {1}, {2})", name, value, el);
	}

	public static function setProps(props:Map<String, String>, el:Element):Void {
		trace("props element");
	}
}
