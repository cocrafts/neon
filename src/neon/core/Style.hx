package neon.core;

import haxe.ds.StringMap;
import haxe.macro.Expr;
import haxe.macro.Context;

typedef Style = {
	var ?width:Float;
	var ?height:Float;
	var ?top:Float;
	var ?left:Float;
	var ?right:Float;
	var ?bottom:Float;
	var ?margin:Float;
	var ?marginVertical:Float;
	var ?marginHorizontal:Float;
	var ?marginTop:Float;
	var ?marginLeft:Float;
	var ?marginRight:Float;
	var ?marginBottom:Float;
	var ?padding:Float;
	var ?paddingVertical:Float;
	var ?paddingHorizontal:Float;
	var ?paddingTop:Float;
	var ?paddingLeft:Float;
	var ?paddingRight:Float;
	var ?paddingBottom:Float;
	var ?backgroundColor:String;
	var ?color:String;
	var ?fontSize:Float;
	var ?fontWeight:String;
	var ?borderWidth:Float;
	var ?borderColor:String;
	var ?borderRadius:Float;
	var ?display:String;
	var ?flexDirection:String;
	var ?justifyContent:String;
	var ?alignItems:String;
	var ?position:String;
	var ?opacity:Float;
	var ?zIndex:Int;
}

typedef StyleMap = Map<String, Style>;

class StyleSheet {
	public static macro function create(e:Expr):Expr {
		var structFields = [];
		var fields = Context.typeExpr(e);

		switch e.expr {
			case EObjectDecl(declarations):
				for (declaration in declarations) {
					var styleName = declaration.field;
					var styleExpr = declaration.expr;
					var styleMap = new StringMap<Dynamic>();

					function registerField(field:String, expr:Dynamic):Void {
						styleMap.set(field, {field: field, expr: expr, pos: Context.currentPos()});
					};

					switch (styleExpr.expr) {
						case EObjectDecl(styleDeclarations):
							for (styleDeclaration in styleDeclarations) {
								var fieldName = styleDeclaration.field;
								var fieldExpr = styleDeclaration.expr;

								if (fieldName == "paddingHorizontal") {
									registerField("paddingLeft", fieldExpr);
									registerField("paddingRight", fieldExpr);
								} else if (fieldName == "paddingVertical") {
									registerField("paddingTop", fieldExpr);
									registerField("paddingBottom", fieldExpr);
								} else if (fieldName == "marginHorizontal") {
									registerField("marginLeft", fieldExpr);
									registerField("marginRight", fieldExpr);
								} else if (fieldName == "marginVertical") {
									registerField("marginTop", fieldExpr);
									registerField("marginBottom", fieldExpr);
								} else {
									styleMap.set(fieldName, {field: fieldName, expr: fieldExpr, pos: Context.currentPos()});
								}
							}
						default:
							Context.error("Expected an object literal for style properties", styleExpr.pos);
					}

					declaration.expr = {
						pos: styleExpr.pos,
						expr: EObjectDecl(cast stringMapToArray(styleMap)),
					};
				}
			default:
				return Context.error("Object type expected", e.pos);
		}

		return e;
	}

	static function stringMapToArray(map:StringMap<Dynamic>):Array<Dynamic> {
		var result = [];
		for (value in map) {
			result.push(value);
		}
		return result;
	}
}
