package neon.core;

import haxe.ds.StringMap;
import haxe.macro.Expr;
import haxe.macro.Context;
import neon.core.Helper;

var styleCache:StringMap<Dynamic> = new StringMap();

function registerStyle(map:Dynamic):Void {
	for (id in Reflect.fields(map)) {
		styleCache.set(id, Reflect.field(map, id));
	}
}

macro function createStyle(e:Expr):Expr {
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

	var styleExpr = macro {
		neon.core.Style.registerStyle(${styleObjectExpr});
		$e{styleIdExpr};
	};

	// trace(haxe.macro.ExprTools.toString(styleExpr));
	return styleExpr;
}
