package neon.platform.heaps;

import neon.core.State;
import neon.core.Renderer.renderBundles;

function makeElement(tag:String):Dynamic {
	switch (tag) {
		case "Text":
			return new h2d.Text(hxd.res.DefaultFont.get());
		case "Object":
			return new h2d.Object();
		// case "Drawable":
		// 	return new h2d.Drawable(s3d);
		case "Sphere":
			return new h3d.prim.Sphere(0, 0, 0);
		default:
			throw 'Element not supported ${tag}';
	}
}

function render(container:Dynamic, element:Dynamic, ?props:Dynamic):Void {
	renderBundles.push({
		makeElement: makeElement,
		insert: insert,
		style: function(_, _, _) {},
		prop: prop,
		runtimeProps: runtimeProps,
	});
	insert(element(props), container);
	renderBundles.pop();
}

function callMethod(method:String, node:Dynamic, args:Array<Dynamic>):Void {
	var func = Reflect.field(node, method);
	if (func != null) {
		Reflect.callMethod(node, func, args);
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
		trace('invalid String children for ${Type.typeof(container)}: ${node}');
	} else if ((Std.isOfType(node, Int)) || Std.isOfType(node, Float)) {
		trace('invalid Int or Float children for ${Type.typeof(container)}: ${node}');
	} else if ((Std.isOfType(node, Bool))) {
		trace('invalid Bool children for ${Type.typeof(container)}: ${node}');
	} else if (Reflect.isFunction(node)) {
		createEffect(function() {
			if (currentPosition == null) {
				currentPosition = insert(node(), container, position);
			} else {
				insert(node(), container, currentPosition);
			}
		});
	} else if (node != null) {
		callMethod("addChild", container, [node]);
	}

	return position;
}

function setAttribute(propName:String, value:Dynamic, el:Dynamic):Void {
	var setter = Reflect.field(el, 'set_${propName}');
	if (setter != null) {
		Reflect.callMethod(el, setter, [value]);
	} else {
		Reflect.setField(el, propName, value);
	}
}

function prop(propName:String, value:Dynamic, el:Dynamic):Void {
	if (Reflect.isFunction(value)) {
		createEffect(function() {
			var reactive = value();
			prop(propName, reactive, el);
		});
	} else {
		switch (propName) {
			case "scale":
				var drawable:h2d.Drawable = el;
				drawable.scale(value);
			default:
				switch (propName) {
					case "text":
						if (!Std.isOfType(value, String)) {
							value = Std.string(value);
						}
					default:
				}

				setAttribute(propName, value, el);
		}
	}
}

function runtimeProps(props:Dynamic, el:Dynamic):Void {
	trace("runtime props", props);
}
