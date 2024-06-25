package neon.parser;

using Lambda;

class XmlBuilder {
	var indent:String;
	var newLine:String;
	var cur:XmlNodeElement;
	var level = 0;

	public var xml:XmlDocument;

	public function new(indent = "\t", newLine = "\n") {
		this.indent = indent;
		this.newLine = newLine;
		cur = xml = new XmlDocument();
	}

	public function begin(tag:String, ?attrs:Array<{name:String, value:Dynamic}>):XmlBuilder {
		if (indent != null) {
			if (level > 0 || cur.nodes.length > 0) {
				cur.addChild(new XmlNodeText(newLine + StringTools.rpad("", indent, level * indent.length)));
			}
			level++;
		}

		var node = new XmlNodeElement(tag, attrs != null ? attrs.map(function(a) return new XmlAttribute(a.name, a.value, '"')) : []);
		cur.addChild(node);
		cur = node;
		return this;
	}

	public function end():XmlBuilder {
		if (indent != null) {
			level--;
			if (cur.nodes.exists(function(e) return !Std.isOfType(e, HtmlNodeText))) {
				cur.addChild(new XmlNodeText(newLine + StringTools.rpad("", indent, level * indent.length)));
			}
		}

		cur = (cast cur.parent : XmlNodeElement);
		return this;
	}

	public function attr(name:String, value:Dynamic, ?defValue:Dynamic):XmlBuilder {
		if (value != null && (!Std.isOfType(value, Float) || !Math.isNaN(value)) && value != defValue) {
			if (Std.isOfType(value, Array))
				value = value.join(",");
			cur.setAttribute(name, Std.string(value));
		}
		return this;
	}

	public function content(s:String):XmlBuilder {
		cur.addChild(new XmlNodeText(s));
		return this;
	}

	public function toString()
		return xml.toString();
}
