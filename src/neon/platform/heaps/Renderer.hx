package neon.platform.heaps;

import neon.core.State;
import neon.core.Renderer.renderBundles;

function makeElement(tag:String):Dynamic {
	return new h2d.Text(hxd.res.DefaultFont.get());
}

function render(container:Dynamic, element:Dynamic, ?props:Dynamic):Void {
	renderBundles.push({
		makeElement: makeElement,
		insert: insert,
		prop: prop,
		runtimeProps: runtimeProps,
	});
	trace(element);
	insert(element(props), container);
	renderBundles.pop();
}

function callMethod(method:String, node:Dynamic, el:Dynamic):Void {
	var func = Reflect.field(node, method);
	if (func != null) {
		Reflect.callMethod(node, func, [el]);
	}
}

function insert(node:Dynamic, container:Dynamic, ?position:Int):Int {
	var currentPosition = null;

	if (Std.isOfType(node, Array)) {
		var elements:Array<Dynamic> = cast node;
		for (item in elements) {
			insert(item, container, position);
		}
	} else if (Std.isOfType(node, String)) {
		if (Std.isOfType(container, h2d.Text)) {
			var el:h2d.Text = container;
			el.text = node;
		}
	} else if ((Std.isOfType(node, Int)) || Std.isOfType(node, Float)) {
		if (Std.isOfType(container, h2d.Text)) {
			var el:h2d.Text = container;
			el.text = Std.string(node);
		}
	} else if (Reflect.isFunction(node)) {
		createEffect(function() {
			if (currentPosition == null) {
				currentPosition = insert(node(), container, position);
			} else {
				insert(node(), container, currentPosition);
			}
		});
	} else {
		callMethod("addChild", container, node);
	}

	return position;
}

function prop(prop:String, attributes:Dynamic, el:Dynamic):Void {
	if (Std.isOfType(el, h2d.Text)) {
		trace("this is text!");
	}
	trace("set props", prop);
}

function runtimeProps(props:Dynamic, el:Dynamic):Void {
	trace("runtime props", props);
}
