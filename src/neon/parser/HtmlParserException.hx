package neon.parser;

class HtmlParserException {
	public var message:String;

	public var line:Int;
	public var column:Int;
	public var length:Int;

	public function new(message:String, pos:{line:Int, column:Int, length:Int}) {
		this.message = message;

		this.line = pos.line;
		this.column = pos.column;
		this.length = pos.length;
	}

	public function toString() {
		return "Parse error at " + line + ":" + column + ". " + message;
	}
}
