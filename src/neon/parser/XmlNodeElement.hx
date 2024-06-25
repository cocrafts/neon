package neon.parser;

class XmlNodeElement extends HtmlNodeElement {
	override function isSelfClosing()
		return true;

	override function set_innerHTML(value:String):String {
		var newNodes = XmlParser.run(value);
		nodes = [];
		children = [];
		for (node in newNodes)
			addChild(node);
		return value;
	}
}
