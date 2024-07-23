package neon.platform.browser;

import neon.core.Style;

function camelToKebabCase(str:String):String {
	var reg = new EReg("[A-Z]", "g");
	return reg.map(str, (match) -> "-" + match.matched(0).toLowerCase());
}

function parseCssValue(style:Dynamic, key:String):String {
	var field:Dynamic = Reflect.field(style, key);

	switch (key) {
		case "fontSize", "width", "height", "top", "left", "right", "bottom", "margin", "maxWidth", "maxHeight", "marginTop", "marginRight", "marginBottom",
			"marginLeft", "padding", "paddingTop", "paddingRight", "paddingBottom", "paddingLeft", "borderWidth", "borderTopWidth", "borderRightWidth",
			"borderBottomWidth", "borderLeftWidth":
			if (Std.isOfType(field, String)) {
				return field;
			} else {
				return '${Math.floor(field)}px';
			}
		default:
			return field;
	}
}

function generateMediaFragment(field:String, media:String, style:Dynamic):String {
	var fragment:String = '${media} { .neon-${field} {';

	for (field in Reflect.fields(style)) {
		fragment += '${camelToKebabCase(field)}: ${parseCssValue(style, field)};';
	}

	fragment += "} }\n";

	return fragment;
}

function generateCSS():String {
	var css:String = "";
	var mediaCss:String = "";

	for (key in styleCache.keys()) {
		var style:Dynamic = styleCache.get(key);
		css += ".neon-" + key + " {";

		for (field in Reflect.fields(style)) {
			if (StringTools.startsWith(field, "@media")) {
				mediaCss += generateMediaFragment(key, field, Reflect.field(style, field));
			} else {
				css += '${camelToKebabCase(field)}: ${parseCssValue(style, field)};';
			}
		}

		css += "}\n";
	}

	return '${css}${mediaCss}';
}

var nsUri = "http://www.w3.org/2000/svg";
