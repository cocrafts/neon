package neon.web;

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
