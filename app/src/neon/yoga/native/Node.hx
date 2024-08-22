package neon.yoga.native;

import neon.yoga.Types;

@:native("YGNodeRef") extern class YogaNodeRef {}

@:valueType
@:native("YGValue") extern class Value {
	var value:Float;
	var unit:Unit;
}

typedef DirtiedFunction = (node:YogaNodeRef) -> Void;
typedef MeasureFunction = (width:Float, widthMode:MeasureMode, height:Float, heightMode:MeasureMode) -> Size;

@:headerInclude("yoga/Yoga.h", true)
class YogaNode {
	public var node:YogaNodeRef;

	public function new(?ref:YogaNodeRef) {
		node = ref != null ? ref : untyped __cpp__("YGNodeNew()");
	}

	public function addChild(child:YogaNodeRef, index:Int) {
		untyped __cpp__("YGNodeInsertChild({0}, {1}, {2})", node, child, index);
	}

	public function setSize(width:Float, height:Float) {
		setWidth(width);
		setHeight(height);
	}

	public function calculateLayout(width:Float, height:Float, direction:Direction,):Void {
		untyped __cpp__("YGNodeCalculateLayout({0}, {1}, {2}, (YGDirection){3})", node, width, height, direction);
	}

	public function copyStyle(from:YogaNodeRef):Void {
		untyped __cpp__("YGNodeCopyStyle({0}, {1})", node, from);
	}

	public function free():Void {
		untyped __cpp__("YGNodeFree({0})", node);
	}

	public function freeRecursive():Void {
		untyped __cpp__("YGNodeFree({0})", node);
	}

	public function getAlignContent():Align {
		return untyped __cpp__("YGNodeStyleGetAlignContent({0})", node);
	}

	public function getAlignItems():Align {
		return untyped __cpp__("YGNodeStyleGetAlignItems({0})", node);
	}

	public function getAlignSelf():Align {
		return untyped __cpp__("YGNodeStyleGetAlignSelf({0})", node);
	}

	public function getAspectRatio():Float {
		return untyped __cpp__("YGNodeStyleGetAspectRatio({0})", node);
	}

	public function getBorder(edge:Edge):Float {
		return untyped __cpp__("YGNodeStyleGetBorder({0}, (YGEdge){1})", node, edge);
	}

	public function getChild(index:Int):YogaNodeRef {
		return untyped __cpp__("YGNodeGetChild({0}, {1})", node, index);
	}

	public function getChildCount():Float {
		return untyped __cpp__("YGNodeGetChildCount({0})", node);
	}

	public function getDirection():Direction {
		return untyped __cpp__("YGNodeStyleGetDirection({0})", node);
	}

	public function getDisplay():Display {
		return untyped __cpp__("YGNodeStyleGetDisplay({0})", node);
	}

	public function getFlexBasis():Value {
		return untyped __cpp__("YGNodeStyleGetFlexBasis({0})", node);
	}

	public function getFlexDirection():FlexDirection {
		return untyped __cpp__("YGNodeStyleGetFlexDirection({0})", node);
	}

	public function getFlexGrow():Float {
		return untyped __cpp__("YGNodeStyleGetFlexGrow({0})", node);
	}

	public function getFlexShrink():Float {
		return untyped __cpp__("YGNodeStyleGetFlexShrink({0})", node);
	}

	public function getFlexWrap():Wrap {
		return untyped __cpp__("YGNodeStyleGetFlexWrap({0})", node);
	}

	public function getHeight():Value {
		return untyped __cpp__("YGNodeStyleGetHeight({0})", node);
	}

	public function getJustifyContent():Justify {
		return untyped __cpp__("YGNodeStyleGetJustifyContent({0})", node);
	}

	public function getGap(gutter:Gutter):Float {
		return untyped __cpp__("YGNodeStyleGetGap({0}, (YGGutter){1})", node, gutter);
	}

	public function getMargin(edge:Edge):Value {
		return untyped __cpp__("YGNodeStyleGetMargin({0}, (YGEdge){1})", node, edge);
	}

	public function getMaxHeight():Value {
		return untyped __cpp__("YGNodeStyleGetMaxHeight({0})", node);
	}

	public function getMaxWidth():Value {
		return untyped __cpp__("YGNodeStyleGetMaxWidth({0})", node);
	}

	public function getMinHeight():Value {
		return untyped __cpp__("YGNodeStyleGetMinHeight({0})", node);
	}

	public function getMinWidth():Value {
		return untyped __cpp__("YGNodeStyleGetMinWidth({0})", node);
	}

	public function getOverflow():Overflow {
		return untyped __cpp__("YGNodeStyleGetOverflow({0})", node);
	}

	public function getPadding(edge:Edge):Value {
		return untyped __cpp__("YGNodeStyleGetPadding({0}, (YGEdge){1})", node, edge);
	}

	public function getParent():YogaNode {
		var parent = untyped __cpp__("YGNodeGetParent({0})", node);
		return new YogaNode(parent);
	}

	public function getPosition(edge:Edge):Value {
		return untyped __cpp__("YGNodeStyleGetPosition({0}, (YGEdge){1})", node, edge);
	}

	public function getPositionType():PositionType {
		return untyped __cpp__("YGNodeStyleGetPositionType({0})", node);
	}

	public function getWidth():Value {
		return untyped __cpp__("YGNodeStyleGetWidth({0})", node);
	}

	public function isDirty():Bool {
		return untyped __cpp__("YGNodeIsDirty({0})", node);
	}

	public function isReferenceBaseline():Bool {
		return untyped __cpp__("YGNodeIsReferenceBaseline({0})", node);
	}

	public function markDirty():Void {
		return untyped __cpp__("YGNodeMarkDirty({0})", node);
	}

	public function hasNewLayout():Bool {
		return untyped __cpp__("YGNodeGetHasNewLayout({0})", node);
	}

	public function markLayoutSeen():Void {
		untyped __cpp__("YGNodeSetHasNewLayout({0}, true)", node);
	}

	public function removeChild(child:YogaNode):Void {
		untyped __cpp__("YGNodeRemoveChild({0}, {1})", node, child.node);
	}

	public function reset():Void {
		unsetMeasureFunc();
		unsetDirtiedFunc();
		untyped __cpp__("YGNodeReset({0})", node);
	}

	public function setAlignContent(alignContent:Align):Void {
		untyped __cpp__("YGNodeStyleSetAlignContent({0}, (YGAlign){1})", node, alignContent);
	}

	public function setAlignItems(alignItems:Align):Void {
		untyped __cpp__("YGNodeStyleSetAlignItems({0}, (YGAlign){1})", node, alignItems);
	}

	public function setAlignSelf(alignSelf:Align):Void {
		untyped __cpp__("YGNodeStyleSetAlignSelf({0}, (YGAlign){1})", node, alignSelf);
	}

	public function setAspectRatio(aspectRatio:Float):Void {
		untyped __cpp__("YGNodeStyleSetAspectRatio({0}, {1})", node, aspectRatio);
	}

	public function setBorder(edge:Edge, borderWidth:Float):Void {
		untyped __cpp__("YGNodeStyleSetBorder({0}, (YGEdge){1}, {2})", node, edge, borderWidth);
	}

	public function setDirection(direction:Direction):Void {
		untyped __cpp__("YGNodeStyleSetDirection({0}, (YGDirection){1})", node, direction);
	}

	public function setDisplay(display:Display):Void {
		untyped __cpp__("YGNodeStyleSetDisplay({0}, (YGDisplay){1})", node, display);
	}

	public function setFlex(flex:Int):Void {
		untyped __cpp__("YGNodeStyleSetFlex({0}, {1})", node, flex);
	}

	public function setFlexBasis(flexBasis:Float):Void {
		untyped __cpp__("YGNodeStyleSetFlexBasis({0}, {1})", node, flexBasis);
	}

	public function setFlexBasisPercent(flexBasis:Float):Void {
		untyped __cpp__("YGNodeStyleSetFlexBasisPercent({0}, {1})", node, flexBasis);
	}

	public function setFlexBasisAuto():Void {
		untyped __cpp__("YGNodeStyleSetFlexBasisAuto({0})", node);
	}

	public function setFlexDirection(flexDirection:FlexDirection):Void {
		untyped __cpp__("YGNodeStyleSetFlexDirection({0}, (YGFlexDirection){1})", node, flexDirection);
	}

	public function setFlexGrow(flexGrow:Float):Void {
		untyped __cpp__("YGNodeStyleSetFlexGrow({0}, {1})", node, flexGrow);
	}

	public function setFlexShrink(flexShrink:Float):Void {
		untyped __cpp__("YGNodeStyleSetFlexShrink({0}, {1})", node, flexShrink);
	}

	public function setFlexWrap(flexWrap:Wrap):Void {
		untyped __cpp__("YGNodeStyleSetFlexWrap({0}, (YGWrap){1})", node, flexWrap);
	}

	public function setHeight(height:Float):Void {
		untyped __cpp__("YGNodeStyleSetHeight({0}, {1})", node, height);
	}

	public function setIsReferenceBaseline(isReferenceBaseline:Bool):Void {
		untyped __cpp__("YGNodeSetIsReferenceBaseline({0}, {1})", node, isReferenceBaseline);
	}

	public function setHeightAuto():Void {
		untyped __cpp__("YGNodeStyleSetHeightAuto({0})", node);
	}

	public function setHeightPercent(height:Float):Void {
		untyped __cpp__("YGNodeStyleSetHeightPercent({0}, {1})", node, height);
	}

	public function setJustifyContent(justifyContent:Justify):Void {
		untyped __cpp__("YGNodeStyleSetJustifyContent({0}, (YGJustify){1})", node, justifyContent);
	}

	public function setGap(gutter:Gutter, gapLength:Float):Void {
		return untyped __cpp__("YGNodeStyleSetGap({0}, (YGGutter){1}, {2})", node, gutter, gapLength);
	}

	public function setGapPercent(gutter:Gutter, gapLength:Float):Void {
		return untyped __cpp__("YGNodeStyleSetGapPercent({0}, (YGGutter){1}, {2})", node, gutter, gapLength);
	}

	public function setMargin(edge:Edge, margin:Float):Void {
		untyped __cpp__("YGNodeStyleSetMargin({0}, (YGEdge){1}, {2})", node, edge, margin);
	}

	public function setMarginAuto(edge:Edge):Void {
		untyped __cpp__("YGNodeStyleSetMarginAuto({0}, (YGEdge){1})", node, edge);
	}

	public function setMarginPercent(edge:Edge, margin:Float):Void {
		untyped __cpp__("YGNodeStyleSetMarginPercent({0}, (YGEdge){1}, {2})", node, edge, margin);
	}

	public function setMaxHeight(maxHeight:Float):Void {
		untyped __cpp__("YGNodeStyleSetMaxHeight({0}, {1})", node, maxHeight);
	}

	public function setMaxHeightPercent(maxHeight:Float):Void {
		untyped __cpp__("YGNodeStyleSetMaxHeightPercent({0}, {1})", node, maxHeight);
	}

	public function setMaxWidth(maxWidth:Float):Void {
		untyped __cpp__("YGNodeStyleSetMaxWidth({0}, {1})", node, maxWidth);
	}

	public function setMaxWidthPercent(maxWidth:Float):Void {
		untyped __cpp__("YGNodeStyleSetMaxWidthPercent({0}, {1})", node, maxWidth);
	}

	// public function setDirtiedFunc(dirtiedFunc:DirtiedFunction):Void {
	// 	untyped __cpp__("YGNodeSetDirtiedFunc({0}, {1})", node, dirtiedFunc);
	// }
	// public function setMeasureFunc(measureFunc:MeasureFunction):Void {
	// 	untyped __cpp__("YGNodeSetMeasureFunc({0}, {1})", node, measureFunc);
	// }

	public function setMinHeight(minHeight:Float):Void {
		untyped __cpp__("YGNodeStyleSetMinHeight({0}, {1})", node, minHeight);
	}

	public function setMinHeightPercent(minHeight:Float):Void {
		untyped __cpp__("YGNodeStyleSetMinHeightPercent({0}, {1})", node, minHeight);
	}

	public function setMinWidth(minWidth:Float):Void {
		untyped __cpp__("YGNodeStyleSetMinWidth({0}, {1})", node, minWidth);
	}

	public function setMinWidthPercent(minWidth:Float):Void {
		untyped __cpp__("YGNodeStyleSetMinWidthPercent({0}, {1})", node, minWidth);
	}

	public function setOverflow(overflow:Overflow):Void {
		untyped __cpp__("YGNodeStyleSetOverflow({0}, (YGOverflow){1})", node, overflow);
	}

	public function setPadding(edge:Edge, padding:Float):Void {
		untyped __cpp__("YGNodeStyleSetPadding({0}, (YGEdge){1}, {2})", node, edge, padding);
	}

	public function setPaddingPercent(edge:Edge, padding:Float):Void {
		untyped __cpp__("YGNodeStyleSetPaddingPercent({0}, (YGEdge){1}, {2})", node, edge, padding);
	}

	public function setPosition(edge:Edge, position:Float):Void {
		untyped __cpp__("YGNodeStyleSetPosition({0}, (YGEdge){1}, {2})", node, edge, position);
	}

	public function setPositionPercent(edge:Edge, position:Float):Void {
		untyped __cpp__("YGNodeStyleSetPositionPercent({0}, (YGEdge){1}, {2})", node, position);
	}

	public function setPositionType(positionType:PositionType):Void {
		untyped __cpp__("YGNodeStyleSetPositionType({0}, (YGPositionType){1})", node, positionType);
	}

	public function setWidth(width:Float):Void {
		untyped __cpp__("YGNodeStyleSetWidth({0}, {1})", node, width);
	}

	public function setWidthAuto():Void {
		untyped __cpp__("YGNodeStyleSetWidthAuto({0})", node);
	}

	public function setWidthPercent(width:Float):Void {
		untyped __cpp__("YGNodeStyleSetWidthPercent({0}, {1})", node, width);
	}

	public function unsetDirtiedFunc():Void {
		untyped __cpp__("YGNodeSetDirtiedFunc({0}, nullptr)", node);
	}

	public function unsetMeasureFunc():Void {
		untyped __cpp__("YGNodeSetMeasureFunc({0}, nullptr)", node);
	}

	public function setAlwaysFormsContainingBlock(alwaysFormsContainingBlock:Bool):Void {
		untyped __cpp__("YGNodeSetAlwaysFormsContainingBlock({0}, {1})", node, alwaysFormsContainingBlock);
	}
}
