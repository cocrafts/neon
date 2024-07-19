package neon.platform.web;

import haxe.Json;
import js.html.Element;
import js.Browser.document;
import neon.core.State;
import neon.platform.web.Helper;

function render(element:Dynamic, container:Dynamic):Void {
	injectStyleElement();
	insert(element, container, null);
}

function insert(node:Dynamic, container:Element, position:Int):Int {
	var currentPosition = null;

	if (Std.isOfType(node, Array)) {
		var elements:Array<Dynamic> = cast node;
		for (item in elements) {
			insert(item, container, position);
		}
	} else if (Std.isOfType(node, Element)) {
		upsert(node, container, position);
	} else if (Std.isOfType(node, String) || Std.isOfType(node, Int) || Std.isOfType(node, Float)) {
		var textNode = document.createTextNode(cast node);
		return upsert(textNode, container, position);
	} else if (Std.isOfType(node, Bool)) {
		var textNode = document.createTextNode(node == true ? "true" : "false");
		return upsert(textNode, container, position);
	} else if (Reflect.isObject(node)) {
		var textNode = document.createTextNode(Json.stringify(node));
		return upsert(textNode, container, position);
	} else if (Reflect.isFunction(node)) {
		new Effect(function() {
			if (currentPosition == null) {
				currentPosition = insert(node(), container, position);
			} else {
				insert(node(), container, currentPosition);
			}
		});
	}

	return position;
}

function upsert(element:Dynamic, container:Element, position:Int):Int {
	if (position == null) {
		container.appendChild(element);
	} else {
		var existingElement:Element = cast container.childNodes[position];
		if (Reflect.field(existingElement, "data") != Reflect.field(element, "data")) {
			existingElement.replaceWith(element);
		}
	}

	return container.childNodes.length - 1;
}

function injectStyleElement():Void {
	var cssString = generateCSS();
	var styleElement = document.createElement("style");

	styleElement.setAttribute("type", "text/css");
	styleElement.innerHTML = cssString;
	document.head.appendChild(styleElement);
}
