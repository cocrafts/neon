package neon.parser;

class HtmlNode {
	public var parent:HtmlNodeElement;

	public function remove():Void {
		if (parent != null)
			parent.removeChild(this);
	}

	public function getPrevSiblingNode():HtmlNode {
		if (parent == null)
			return null;
		var siblings = this.parent.nodes;
		var n = Lambda.indexOf(siblings, this);
		if (n <= 0)
			return null;
		if (n > 0)
			return siblings[n - 1];

		return null;
	}

	public function getNextSiblingNode():HtmlNode {
		if (parent == null)
			return null;
		var siblings = parent.nodes;
		var n = Lambda.indexOf(siblings, this);
		if (n < 0)
			return null;
		if (n + 1 < siblings.length)
			return siblings[n + 1];

		return null;
	}

	public function toString():String {
		return "";
	}

	public function toText():String {
		return "";
	}

	function hxSerialize(s:{function serialize(d:Dynamic):Void;}) {}

	function hxUnserialize(s:{function unserialize():Dynamic;}) {}
}
