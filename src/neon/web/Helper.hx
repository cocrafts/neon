package neon.web;

function camelToKebabCase(str:String):String {
	var reg = new EReg("[A-Z]", "g");
	return reg.map(str, (match) -> "-" + match.matched(0).toLowerCase());
}

function parseCssValue(style:Dynamic, key:String):String {
	switch key {
	case "fontSize", "width", "height", "top", "left", "right", "bottom",
		 "margin", "marginTop", "marginRight", "marginBottom", "marginLeft",
		 "padding", "paddingTop", "paddingRight", "paddingBottom", "paddingLeft",
		 "borderWidth", "borderTopWidth", "borderRightWidth", "borderBottomWidth", "borderLeftWidth":
		return '${Reflect.field(style, key)}px';
	default:
		return Reflect.field(style, key);
	}
}
