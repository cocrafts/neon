package neon.parser;

class HtmlDocument extends HtmlNodeElement {
	public function new(str = "", tolerant = false):Void {
		super("", []);
		var nodes = HtmlParser.run(str, tolerant);

		for (node in nodes) {
			addChild(node);
		}
	}
}
