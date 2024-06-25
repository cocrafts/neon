package neon.parser;

class HtmlParserTools {
	public static function getAttr(node:HtmlNodeElement, attrName:String, ?defaultValue:Dynamic):Dynamic {
		if (node == null || !node.hasAttribute(attrName)) {
			return Std.isOfType(defaultValue, Array) ? null : defaultValue;
		}
		return parseValue(node.getAttribute(attrName), defaultValue);
	}

	public static function getAttrString(node:HtmlNodeElement, attrName:String, ?defaultValue:String):String {
		var r = node.getAttribute(attrName);
		return r == null ? defaultValue : r;
	}

	public static function getAttrInt(node:HtmlNodeElement, attrName:String, ?defaultValue:Int):Int {
		var r = Std.parseInt(node.getAttribute(attrName));
		return r == null || Math.isNaN(r) ? defaultValue : r;
	}

	public static function getAttrFloat(node:HtmlNodeElement, attrName:String, ?defaultValue:Float):Float {
		var r = Std.parseFloat(node.getAttribute(attrName));
		return r == null || Math.isNaN(r) ? defaultValue : r;
	}

	public static function getAttrBool(node:HtmlNodeElement, attrName:String, ?defaultValue:Bool):Bool {
		var r = node.getAttribute(attrName);
		return r == null || r == "" ? defaultValue : r != "0" && r.toLowerCase() != "false" && r.toLowerCase() != "no";
	}

	public static function findOne(node:HtmlNodeElement, selector:String):HtmlNodeElement {
		var nodes = node.find(selector);
		return nodes.length > 0 ? nodes[0] : null;
	}

	static function parseValue(value:String, ?defaultValue:Dynamic):Dynamic {
		if (Std.isOfType(defaultValue, Float))
			return Std.parseFloat(value);
		if (Std.isOfType(defaultValue, Bool))
			return value != null && value != "" && value != "0" && ["false", "no"].indexOf(value.toLowerCase()) < 0;
		if (Std.isOfType(defaultValue, Array)) {
			var elems = [];
			var parCounter = 0;
			var lastCommaIndex = -1;
			for (i in 0...value.length) {
				var c = value.charAt(i);
				if (c == "(" || c == "[" || c == "{")
					parCounter++;
				else if (c == ")" || c == "]" || c == "}")
					parCounter--;
				else if (c == "," && parCounter == 0) {
					elems.push(value.substring(lastCommaIndex + 1, i));
					lastCommaIndex = i;
				}
			}
			elems.push(value.substring(lastCommaIndex + 1, value.length));

			return defaultValue.length > 0 ? elems.map(function(item) return parseValue(item, defaultValue[0])) : elems;
		}
		return value;
	}
}
