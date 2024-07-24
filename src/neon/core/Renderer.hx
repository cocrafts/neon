package neon.core;

typedef RenderBundle = {
	var makeElement:(tag:String) -> Dynamic;
	var insert:(node:Dynamic, container:Dynamic, ?position:Int) -> Int;
	var style:(attribute:String, value:Dynamic, el:Dynamic) -> Void;
	var prop:(prop:String, value:Dynamic, el:Dynamic) -> Void;
	var runtimeProps:(props:Dynamic, el:Dynamic) -> Void;
};

var renderBundles:Array<RenderBundle> = [];

function getCurrentBundle():RenderBundle {
	return renderBundles[renderBundles.length - 1];
}

function makeElement(tag:String):Dynamic {
	return getCurrentBundle().makeElement(tag);
}

function insert(node:Dynamic, container:Dynamic, ?position:Int):Int {
	return getCurrentBundle().insert(node, container, position);
}

function style(attribute:String, value:Dynamic, el:Dynamic):Void {
	return getCurrentBundle()?.style(attribute, value, el);
}

function prop(prop:String, value:Dynamic, el:Dynamic):Void {
	return getCurrentBundle().prop(prop, value, el);
}

function runtimeProps(props:Dynamic, el:Dynamic):Void {
	return getCurrentBundle().runtimeProps(props, el);
}
