package neon.web;

import js.Browser.document;
import neon.core.Event.CallbackManager;
import neon.core.Common.VirtualNode;
import neon.web.Helper;

class NeonDom {
	public static function render(node:VirtualNode, container:Dynamic):Void {
		injectStyleElement();
		container.appendChild(makeElement(node));
	}

	public static function createElement(tag:String) {
		switch (tag) {
			case "svg", "path", "line", "circle", "rect", "polyline", "polygon", "ellipse", "g", "text", "tspan", "textPath", "defs", "image", "marker",
				"mask", "pattern", "switch", "symbol", "use":
				return document.createElementNS(nsUri, tag);
			default:
				return document.createElement(tag);
		}
	}

	public static function setAttribute(el:js.html.Element, name:String, value:Dynamic) {
		if (StringTools.endsWith(el.namespaceURI, "svg")) {
			el.setAttributeNS(null, name, value);
		} else {
			el.setAttribute(name, value);
		}
	}

	public static function makeElement(node:VirtualNode):Dynamic {
		var el = createElement(node.tag);

		for (prop in Reflect.fields(node.props)) {
			var value = Reflect.field(node.props, prop);

			if (prop == "style") {
				if (Std.isOfType(value, String)) {
					el.classList.add('neon-${value}');
				} else {
					for (attribute in Reflect.fields(value)) {
						var styleKey = camelToKebabCase(attribute);
						var styleValue = parseCssValue(value, attribute);
						el.style.setProperty(styleKey, styleValue);
					}
				}
			} else if (Reflect.isFunction(value)) {
				var callbackId = CallbackManager.registerCallback(cast value);
				el.addEventListener(prop, (event) -> CallbackManager.invokeCallback(callbackId, event));
			} else {
				setAttribute(el, prop, value);
			}
		}

		for (child in node.children) {
			if (Std.is(child, String)) {
				el.appendChild(document.createTextNode(cast child));
			} else {
				el.appendChild(makeElement(child));
			}
		}

		return el;
	}

	static function injectStyleElement():Void {
		var cssString = generateCSS();
		var styleElement = document.createElement("style");

		styleElement.setAttribute("type", "text/css");
		styleElement.innerHTML = cssString;
		document.head.appendChild(styleElement);
	}
}

var nsUri = "http://www.w3.org/2000/svg";
