package neon.core;

import neon.core.Element;

typedef RenderBundle = {
	var makeElement:(tag:String) -> Element;
	var insert:(node:Element, container:Element, ?position:Int) -> Int;
	var style:(attribute:String, value:Any, el:Element) -> Void;
	var prop:(propName:String, value:Any, el:Element) -> Void;
	var props:(props:Map<String, String>, el:Element) -> Void;
};

@:headerInclude("NeonCore.h")
@:headerInclude("neon-Swift.h")
@:headerInclude("haxe_ds_StringMap.h")
class Renderer {
	public static var renderBundles = new Array<RenderBundle>();

	public static function registerBundle(bundle:RenderBundle):Array<RenderBundle> {
		renderBundles.push(bundle);
		return renderBundles;
	}

	public static function freeBundle():Array<RenderBundle> {
		renderBundles.pop();
		return renderBundles;
	}

	public static function getCurrentBundle():RenderBundle {
		return renderBundles[renderBundles.length - 1];
	}

	public static function makeElement(tag:String):Element {
		return getCurrentBundle().makeElement(tag);
	}

	public static function insert(node:Element, container:Element, ?position:Int):Int {
		return 0;
	}

	public static function style(attribute:String, value:Any, el:Element):Void {
		getCurrentBundle().style(attribute, value, el);
	}

	public static function prop(prop:String, value:Any, el:Element):Void {
		getCurrentBundle().prop(prop, value, el);
	}

	public static function props(props:Map<String, String>, el:Element):Void {}
}
