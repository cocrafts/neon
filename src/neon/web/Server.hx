package neon.web;

import neon.parser.HtmlNodeElement;
import neon.parser.HtmlNodeText;
import neon.parser.HtmlDocument;
import neon.core.Common.VirtualNode;
import neon.web.Helper;

@:build(HaxeCBridge.expose())
class NeonDom {
	public static function renderToString(node:VirtualNode, template:String):String {
		var document = new HtmlDocument(template);
		var body = document.find("body")[0];

		body.addChild(makeElement(node));
		return document.toString();
	}

	public static function makeElement(node:VirtualNode):HtmlNodeElement {
		var el = new HtmlNodeElement(node.tag, []);

		for (prop in Reflect.fields(node.props)) {
			var value = Reflect.field(node.props, prop);
			if (prop == "style") {
				var style = "";

				for (attribute in Reflect.fields(value)) {
					var styleKey = camelToKebabCase(attribute);
					var styleValue = parseCssValue(value, attribute);
					style += '${styleKey}: ${styleValue};';
				}

				el.setAttribute(prop, style);
			} else if (prop == "className") {
				el.setAttribute("class", Reflect.field(node.props, prop));
			} else if (Reflect.isFunction(value)) {
				trace("skip function binding on server-side");
			} else {
				el.setAttribute(prop, Reflect.field(node.props, prop));
			}

			for (child in node.children) {
				if (Std.isOfType(child, String)) {
					el.addChild(new HtmlNodeText(cast child));
				} else {
					el.addChild(makeElement(child));
				}
			}
		}

		return el;
	}
}
