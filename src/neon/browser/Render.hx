package neon.browser;

import js.Browser.document;
import neon.core.Event.CallbackManager;
import neon.core.Builder.VirtualNode;

function render(node:VirtualNode, container:Dynamic):Void {
	var el = makeElement(node);
	container.appendChild(el);
}

function makeElement(node:VirtualNode):Dynamic {
	var el = document.createElement(node.tag);

	for (prop in Reflect.fields(node.props)) {
		var value = Reflect.field(node.props, prop);
		if (prop == "style") {
			for (attribute in Reflect.fields(value)) {
				var styleKey = camelToKebabCase(attribute);
				var styleValue = parseCssValue(value, attribute);
				Reflect.setField(el.style, styleKey, styleValue);
			}
		} else if (Reflect.isFunction(value)) {
			var callbackId = CallbackManager.registerCallback(value);
			el.addEventListener(prop, (event) -> CallbackManager.invokeCallback(callbackId, event));
		} else {
			Reflect.setField(el, prop, Reflect.field(node.props, prop));
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

function camelToKebabCase(str:String):String {
	var reg = new EReg("[A-Z]", "g");
	return reg.map(str, (match) -> "-" + match.matched(0).toLowerCase());
}

function parseCssValue(style:Dynamic, key:String):String {
	switch key {
	case "fontSize", "width", "height", "top", "left", "right", "bottom",
		 "margin", "marginTop", "marginRight", "marginBottom", "marginLeft",
		 "padding", "paddingTop", "paddingRight", "paddingBottom", "paddingLeft",
		 "borderWidth", "borderTopWidth", "borderRightWidth", "borderBottomWidth", "borderLeftWidth":
		return '${Reflect.field(style, key)}px';
	default:
		return Reflect.field(style, key);
	}
}
