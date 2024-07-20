package neon.platform.web;

import neon.core.Event.CallbackManager;
import haxe.Json;
import js.html.Element;
import js.Browser.document;
import neon.core.State;
import neon.platform.web.Helper;

function render(element:Dynamic, container:Dynamic):Void {
	injectStyleElement();
	insert(element, container, null);
}

function makeElement(tag:String):Element {
	return js.Browser.document.createElement(tag);
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

function style(value:Dynamic, el:Element):Void {
	if (Std.isOfType(value, String)) {
		el.classList.add('neon-${value}');
	}
}

function runtimeProps(props:Dynamic, el:Element):Void {
	for (field in Reflect.fields(props)) {
		if (field == "style") {
			style(Reflect.field(props, "style"), el);
		}
	}
}

function setAttribute(el:js.html.Element, name:String, value:Dynamic) {
	if (StringTools.endsWith(el.namespaceURI, "svg")) {
		el.setAttributeNS(null, name, value);
	} else {
		el.setAttribute(name, value);
	}
}

function prop(prop:String, value:Dynamic, el:Element):Void {
	if (Reflect.isFunction(value)) {
		var callbackId = CallbackManager.registerCallback(cast value);
		el.addEventListener(prop, (event) -> CallbackManager.invokeCallback(callbackId, event));
	} else if (prop == "class") {
		el.classList.add(value);
	} else {
		setAttribute(el, prop, value);
	}
}

function injectStyleElement():Void {
	var cssString = generateCSS();
	var styleElement = document.createElement("style");

	styleElement.setAttribute("type", "text/css");
	styleElement.innerHTML = cssString;
	document.head.appendChild(styleElement);
}
