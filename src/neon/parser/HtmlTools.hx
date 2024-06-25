package neon.parser;

class HtmlTools {
	#if (js || !stdlib || !unicode)
	static var htmlUnescapeMap(get, null):Map<String, String>;

	static function get_htmlUnescapeMap() {
		if (htmlUnescapeMap == null) {
			htmlUnescapeMap = [
				"nbsp" => " ", "amp" => "&", "lt" => "<", "gt" => ">", "quot" => "\"", "apos" => "'", "euro" => "€", "iexcl" => "¡", "cent" => "¢",
				"pound" => "£", "curren" => "¤", "yen" => "¥", "brvbar" => "¦", "sect" => "§", "uml" => "¨", "copy" => "©", "ordf" => "ª", "not" => "¬",
				"shy" => "­", "reg" => "®", "macr" => "¯", "deg" => "°", "plusmn" => "±", "sup2" => "²", "sup3" => "³", "acute" => "´", "micro" => "µ",
				"para" => "¶", "middot" => "·", "cedil" => "¸", "sup1" => "¹", "ordm" => "º", "raquo" => "»", "frac14" => "¼", "frac12" => "½",
				"frac34" => "¾", "iquest" => "¿", "Agrave" => "À", "Aacute" => "Á", "Acirc" => "Â", "Atilde" => "Ã", "Auml" => "Ä", "Aring" => "Å",
				"AElig" => "Æ", "Ccedil" => "Ç", "Egrave" => "È", "Eacute" => "É", "Ecirc" => "Ê", "Euml" => "Ë", "Igrave" => "Ì", "Iacute" => "Í",
				"Icirc" => "Î", "Iuml" => "Ï", "ETH" => "Ð", "Ntilde" => "Ñ", "Ograve" => "Ò", "Oacute" => "Ó", "Ocirc" => "Ô", "Otilde" => "Õ",
				"Ouml" => "Ö", "times" => "×", "Oslash" => "Ø", "Ugrave" => "Ù", "Uacute" => "Ú", "Ucirc" => "Û", "Uuml" => "Ü", "Yacute" => "Ý",
				"THORN" => "Þ", "szlig" => "ß", "agrave" => "à", "aacute" => "á", "acirc" => "â", "atilde" => "ã", "auml" => "ä", "aring" => "å",
				"aelig" => "æ", "ccedil" => "ç", "egrave" => "è", "eacute" => "é", "ecirc" => "ê", "euml" => "ë", "igrave" => "ì", "iacute" => "í",
				"icirc" => "î", "iuml" => "ï", "eth" => "ð", "ntilde" => "ñ", "ograve" => "ò", "oacute" => "ó", "ocirc" => "ô", "otilde" => "õ",
				"ouml" => "ö", "divide" => "÷", "oslash" => "ø", "ugrave" => "ù", "uacute" => "ú", "ucirc" => "û", "uuml" => "ü", "yacute" => "ý",
				"thorn" => "þ",
			];
		}
		return htmlUnescapeMap;
	}

	public static function escape(text:String, chars = ""):String {
		var r = text.split("&").join("&amp;");
		r = r.split("<").join("&lt;");
		r = r.split(">").join("&gt;");
		if (chars.indexOf('"') >= 0)
			r = r.split('"').join("&quot;");
		if (chars.indexOf("'") >= 0)
			r = r.split("'").join("&apos;");
		if (chars.indexOf(" ") >= 0)
			r = r.split(" ").join("&nbsp;");
		if (chars.indexOf("\n") >= 0)
			r = r.split("\n").join("&#xA;");
		if (chars.indexOf("\r") >= 0)
			r = r.split("\r").join("&#xD;");
		return r;
	}

	public static function unescape(text:String):String {
		return ~/[<]!\[CDATA\[((?:.|[\r\n])*?)\]\][>]|&[^;]+;/g.map(text, function(re) {
			var s = re.matched(0);
			if (s.charAt(0) == "&") {
				if (s.charAt(1) == "#") {
					var numbers = s.substring(2, s.length - 1);
					if (numbers.charAt(0) == "x")
						numbers = "0" + numbers;
					var code = Std.parseInt(numbers);
					return code != null && code != 0 ? String.fromCharCode(code) : s;
				} else {
					var r = htmlUnescapeMap.get(s.substring(1, s.length - 1));
					return r != null ? r : s;
				}
			}
			return re.matched(1);
		});
	}
	#else
	public static inline function escape(text:String, chars = ""):String {
		return stdlib.Utf8.htmlEscape(text, chars);
	}

	public static inline function unescape(text:String):String {
		return stdlib.Utf8.htmlUnescape(text);
	}
	#end
}
