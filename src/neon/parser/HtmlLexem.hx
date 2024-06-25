package neon.parser;

typedef HtmlLexem = {
	var all:String;
	var allPos:Int;

	var script:String;
	var scriptAttrs:String;
	var scriptText:String;
	var style:String;
	var styleAttrs:String;
	var styleText:String;
	var elem:String;
	var tagOpen:String;
	var attrs:String;
	var tagEnd:String;
	var close:String;
	var tagClose:String;
	var comment:String;

	var tagOpenLC:String;
	var tagCloseLC:String;
}
