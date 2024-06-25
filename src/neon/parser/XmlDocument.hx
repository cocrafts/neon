package neon.parser;

class XmlDocument extends XmlNodeElement {
	public function new(str = ""):Void {
		super("", []);
		var nodes = XmlParser.run(str);
		for (node in nodes) {
			addChild(node);
		}
	}
}
