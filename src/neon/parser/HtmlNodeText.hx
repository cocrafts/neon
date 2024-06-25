package neon.parser;

class HtmlNodeText extends HtmlNode {
	public var text:String;

	public function new(text):Void {
		this.text = text;
	}

	public override function toString() {
		return text;
	}

	override public function toText():String {
		return HtmlTools.unescape(text);
	}

	override function hxSerialize(s:{function serialize(d:Dynamic):Void;}) {
		s.serialize(text);
	}

	override function hxUnserialize(s:{function unserialize():Dynamic;}) {
		text = s.unserialize();
	}
}
