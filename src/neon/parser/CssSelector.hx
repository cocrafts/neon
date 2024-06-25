package neon.parser;

class CssSelector {
	static var reID = "[a-z](?:-?[_a-z0-9])*";
	static var reNamespacedID = reID + "(?::" + reID + ")?";

	//                          1        2          3               4                      5
	static var reSelector = "(\\s*)((?:[>]\\s*)?)([.#]?)(" + reNamespacedID + "|[*])((?:\\[\\d+\\])?)";

	public var type(default, null):String;
	public var tagNameLC(default, null):String;
	public var id(default, null):String;
	public var classes(default, null) = new Array<String>();
	public var index(default, null):Null<Int>;

	function new(type:String) {
		this.type = type;
	}

	public static function parse(selector:String):Array<Array<CssSelector>> {
		var r = [];

		var selectors = ~/\s*,\s*/g.split(selector);
		for (s in selectors) {
			if (s != "")
				r.push(parseInner(s));
		}

		return r;
	}

	static function parseInner(selector:String):Array<CssSelector> {
		var rr = [];

		selector = " " + selector;

		var r:CssSelector = null;
		var re = new EReg(reSelector, "gi");
		var pos = 0;

		while (re.matchSub(selector, pos)) {
			var type1 = getMatched(re, 1);
			if (type1 == null)
				type1 = "";
			var type2 = getMatched(re, 2);
			if (type2 == null)
				type2 = "";

			if (type1.length > 0 || type2.length > 0) {
				if (r != null)
					rr.push(r);
				r = new CssSelector(type2.length > 0 ? ">" : " ");
			}

			var name = re.matched(4);
			if (name != "*") {
				var s = re.matched(3);
				if (s == "#")
					r.id = name;
				else if (s == ".")
					r.classes.push(name);
				else
					r.tagNameLC = name.toLowerCase();

				var sIndex = getMatched(re, 5);
				if (sIndex != null && sIndex != "") {
					r.index = Std.parseInt(sIndex.substring(1, sIndex.length - 1));
					if (Math.isNaN(r.index))
						r.index = null;
				}
			}

			var p = re.matchedPos();
			pos = p.pos + p.len;
		}

		if (r != null)
			rr.push(r);

		return rr;
	}

	static inline function getMatched(re:EReg, n:Int):String
		return try re.matched(n) catch (_:Dynamic) null;
}
