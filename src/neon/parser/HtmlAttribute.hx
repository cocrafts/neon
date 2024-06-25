package neon.parser;

class HtmlAttribute {
	public var name:String;
	public var value:String;
	public var quote:String;

	public function new(name:String, value:String, quote:String):Void {
		this.name = name;
		this.value = value;
		this.quote = quote;
	}

	public function toString() {
		return value != null
			&& quote != null ? name
			+ "="
			+ quote
			+ HtmlTools.escape(value, "\r\n" + (quote == "'" ? '"' : "'"))
			+ quote : name;
	}
}
