package neon.core;

import haxe.ds.StringMap;
import haxe.macro.Expr;
import haxe.macro.Context;
import neon.core.Helper;

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
	public static var styles:StringMap<Dynamic> = new StringMap();
	static var uniqueIdCounter:Int = 0;

	public static function registerStyle(map:Dynamic):Void {
		for (id in Reflect.fields(map)) {
			styles.set(id, Reflect.field(map, id));
		}
	}

	public static macro function create(e:Expr):Expr {
		var fields:Array<ObjectField> = [];
		var fieldIds:Array<ObjectField> = [];

		function injectStyle(name:String, styleFields:Array<ObjectField>, pos:Position) {
			var styleId = generateUniqueId();

			fieldIds.push({
				field: name,
				expr: macro $v{styleId},
			});

			fields.push({
				field: styleId,
				expr: {expr: EObjectDecl(styleFields), pos: pos},
			});
		}

		switch (e.expr) {
			case EObjectDecl(styles):
				for (style in styles) {
					switch (style.expr.expr) {
						case EObjectDecl(attributes):
							var styleFields:Array<ObjectField> = [];
							for (attribute in attributes) {
								styleFields.push(attribute);
							}

							injectStyle(style.field, styleFields, style.expr.pos);
						case EBlock([]):
							injectStyle(style.field, [], style.expr.pos);
						default:
							trace(style);
							Context.error("invalid style definition", style.expr.pos);
					}
				}
			default:
				Context.error("Object type expected", e.pos);
		}

		var styleIdExpr = {expr: EObjectDecl(fieldIds), pos: e.pos};
		var styleObjectExpr = {expr: EObjectDecl(fields), pos: e.pos};

		return macro {
			neon.core.Style.StyleSheet.registerStyle(${styleObjectExpr});
			$e{styleIdExpr};
		};
	}

	static function stringMapToArray(map:StringMap<Dynamic>):Array<Dynamic> {
		var result = [];
		for (value in map) {
			result.push(value);
		}
		return result;
	}
}
