package neon.platform.web;

import neon.core.Style;

function camelToKebabCase(str:String):String {
	var reg = new EReg("[A-Z]", "g");
	return reg.map(str, (match) -> "-" + match.matched(0).toLowerCase());
}

function parseCssValue(style:Dynamic, key:String):String {
	var field = Reflect.field(style, key);

	switch (key) {
		case "fontSize", "width", "height", "top", "left", "right", "bottom", "margin", "maxWidth", "maxHeight", "marginTop", "marginRight", "marginBottom",
			"marginLeft", "padding", "paddingTop", "paddingRight", "paddingBottom", "paddingLeft", "borderWidth", "borderTopWidth", "borderRightWidth",
			"borderBottomWidth", "borderLeftWidth":
			{
				if (Std.isOfType(field, String)) {
					return field;
				} else {
					return '${Std.parseInt(field)}px';
				}
			}
		default:
			return field;
	}
}

function generateCSS():String {
	var css:String = "";

	for (key in StyleSheet.styles.keys()) {
		var style:Dynamic = StyleSheet.styles.get(key);
		css += ".neon-" + key + " {";
		for (field in Reflect.fields(style)) {
			css += camelToKebabCase(field) + ": " + parseCssValue(style, field) + "; ";
		}
		css += "}\n";
	}

	return css;
}

var nsUri = "http://www.w3.org/2000/svg";
