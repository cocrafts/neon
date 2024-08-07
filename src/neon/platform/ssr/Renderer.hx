package neon.platform.ssr;

import haxe.Json;
import neon.parser.HtmlNodeElement;
import neon.parser.HtmlNodeText;
import neon.parser.HtmlDocument;
import neon.core.Renderer;
import neon.platform.browser.Helper;

function render(template:String, element:Dynamic, ?props:Dynamic):String {
	var document = new HtmlDocument(template);
	var body = document.find("body")[0];
	var head = document.find("head")[0];

	injectStyleElement(head);
	renderBundles.push({
		makeElement: makeElement,
		insert: insert,
		style: style,
		prop: prop,
		runtimeProps: runtimeProps,
	});
	insert(element(props), body);
	renderBundles.pop();

	return document.toString();
}

function makeElement(tag:String):HtmlNodeElement {
	return new HtmlNodeElement(tag, []);
}

function insert(node:Dynamic, container:HtmlNodeElement, ?position:Int):Int {
	var currentPosition = null;

	if (Std.isOfType(node, Array)) {
		var elements:Array<Dynamic> = cast node;
		for (item in elements) {
			insert(item, container, position);
		}
	} else if (Std.isOfType(node, HtmlNodeElement)) {
		container.addChild(node);
	} else if (Std.isOfType(node, String)) {
		var textNode = new HtmlNodeText(node);
		container.addChild(textNode);
	} else if (Std.isOfType(node, Int) || Std.isOfType(node, Float)) {
		var textNode = new HtmlNodeText(Std.string(node));
		container.addChild(textNode);
	} else if (Std.isOfType(node, Bool)) {
		var textNode = new HtmlNodeText(node == true ? "true" : "false");
		container.addChild(textNode);
	} else if (Reflect.isObject(node)) {
		if (Reflect.fields(node).length == 0) {
			container.addChild(node); /* is SVG element */
		} else {
			var textNode = new HtmlNodeText(Json.stringify(node));
			container.addChild(textNode);
		}
	} else if (Reflect.isFunction(node)) {
		insert(node(), container, currentPosition);
	}

	return position;
}

function addClass(el:HtmlNodeElement, value:String):Void {
	var currentClass = el.getAttribute("class");
	if (currentClass == null) {
		el.setAttribute("class", 'neon-${value}');
	} else {
		el.setAttribute("class", '${currentClass} ${value}');
	}
}

function style(attribute:String, value:Dynamic, el:HtmlNodeElement):Void {
	var key = camelToKebabCase(attribute);
	var styleString = el.getAttribute("style");

	if (Reflect.isFunction(value)) {
		var value = parseCssValue(attribute, value());
		styleString += '${key}: ${value};';
	} else {
		var value = parseCssValue(attribute, value);
		styleString += '${key}: ${value};';
	}

	el.setAttribute("style", styleString);
}

function prop(prop:String, value:Dynamic, el:HtmlNodeElement):Void {
	if (prop == "style") {
		if (Std.isOfType(value, String)) {
			addClass(el, value);
		} else if (Reflect.isObject(value)) {
			for (attribute in Reflect.fields(value)) {
				style(attribute, Reflect.field(value, attribute), el);
			}
		}
	} else if (prop == "class") {
		addClass(el, value);
	} else {
		if (!Reflect.isFunction(value)) {
			if (Std.isOfType(value, Int) || Std.isOfType(value, Float)) {
				el.setAttribute(prop, Std.string(value));
			} else {
				el.setAttribute(prop, Std.string(value));
			}
		}
	}
}

function runtimeProps(props:Dynamic, el:HtmlNodeElement):Void {
	for (field in Reflect.fields(props)) {
		prop(field, Reflect.field(props, field), el);
	}
}

function injectStyleElement(headElement:HtmlNodeElement):Void {
	var cssString = generateCSS();
	var styleElement = new HtmlNodeElement("style", []);

	styleElement.setAttribute("type", "text/css");
	styleElement.innerHTML = cssString;

	headElement.addChild(styleElement);
}
