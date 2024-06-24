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
		if (Reflect.isFunction(value)) {
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
