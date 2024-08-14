package neon.core;

import neon.core.Element;

typedef RenderBundle = {
	var makeElement:(tag:String) -> Element;
	var insert:(node:Element, container:Element, ?position:Int) -> Int;
	var style:(attribute:String, value:String, el:Element) -> Void;
	var prop:(prop:String, value:String, el:Element) -> Void;
	var runtimeProps:(props:Map<String, String>, el:Element) -> Void;
};

var renderBundles:Array<RenderBundle> = [];

function getCurrentBundle():RenderBundle {
	return renderBundles[renderBundles.length - 1];
}

function makeElement(tag:String):Element {
	return getCurrentBundle().makeElement(tag);
}

function insert(node:Element, container:Element, ?position:Int):Int {
	return getCurrentBundle().insert(node, container, position);
}

function style(attribute:String, value:String, el:Element):Void {
	return getCurrentBundle()?.style(attribute, value, el);
}

function prop(prop:String, value:String, el:Element):Void {
	return getCurrentBundle().prop(prop, value, el);
}

function runtimeProps(props:Map<String, String>, el:Element):Void {
	return getCurrentBundle().runtimeProps(props, el);
}
