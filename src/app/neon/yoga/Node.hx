package neon.yoga;

@:native("YGNodeRef") extern class YogaNodeRef {}

@:native("YGUnit")
@:valueType
extern enum abstract YogaUnit(Int) {
	var Undefined = 0;
	var Point = 1;
	var Percent = 2;
	var Auto = 3;
}

@:valueType
@:native("YGValue") extern class YogaValue {
	var value:Float;
	var unit:YogaUnit;
}

@:headerInclude("yoga/Yoga.h", true)
class YogaNode {
	public var node:YogaNodeRef;

	public function new() {
		node = untyped __cpp__("YGNodeNew()");
	}

	public function addChild(child:YogaNodeRef, index:Int) {
		untyped __cpp__("YGNodeInsertChild({0}, {1}, {2})", node, child, index);
	}

	public function setWidth(val:Float) {
		untyped __cpp__("YGNodeStyleSetWidth({0}, {1})", node, val);
	}

	public function setHeight(val:Float) {
		untyped __cpp__("YGNodeStyleSetHeight({0}, {1})", node, val);
	}

	public function setSize(width:Float, height:Float) {
		setWidth(width);
		setHeight(height);
	}

	public function setFlexDirection() {
		untyped __cpp__("YGNodeStyleSetFlexDirection({0}, YGFlexDirectionRow)", node);
	}

	public function setFlexGrow(val:Float) {
		untyped __cpp__("YGNodeStyleSetFlexGrow({0}, {1})", node, val);
	}

	public function getWidth():YogaValue {
		return untyped __cpp__("YGNodeStyleGetWidth({0})", node);
	}

	public function getHeight():YogaValue {
		return untyped __cpp__("YGNodeStyleGetHeight({0})", node);
	}
}
