package neon.yoga.browser;

import neon.yoga.Types;

typedef DirtiedFunction = (node:YogaNodeRef) -> Void;
typedef MeasureFunction = (width:Float, widthMode:MeasureMode, height:Float, heightMode:MeasureMode) -> Size;

typedef Value = {
	public var value:Float;
	public var unit:Unit;
}

extern class YogaNodeRef {
	public function calculateLayout(width:Float, height:Float, ?direction:Direction,):Void;
	public function copyStyle(?node:YogaNodeRef):Void;
	public function free():Void;
	public function freeRecursive():Void;
	public function getAlignContent():Align;
	public function getAlignItems():Align;
	public function getAlignSelf():Align;
	public function getAspectRatio():Float;
	public function getBorder(edge:Edge):Float;
	public function getChild(index:Int):YogaNodeRef;
	public function getChildCount():Float;
	public function getComputedBorder(edge:Edge):Float;
	public function getComputedBottom():Float;
	public function getComputedHeight():Float;
	public function getComputedLayout():Layout;
	public function getComputedLeft():Float;
	public function getComputedMargin(edge:Edge):Float;
	public function getComputedPadding(edge:Edge):Float;
	public function getComputedRight():Float;
	public function getComputedTop():Float;
	public function getComputedWidth():Float;
	public function getDirection():Direction;
	public function getDisplay():Display;
	public function getFlexBasis():Value;
	public function getFlexDirection():FlexDirection;
	public function getFlexGrow():Float;
	public function getFlexShrink():Float;
	public function getFlexWrap():Wrap;
	public function getHeight():Value;
	public function getJustifyContent():Justify;
	public function getGap(gutter:Gutter):Float;
	public function getMargin(edge:Edge):Value;
	public function getMaxHeight():Value;
	public function getMaxWidth():Value;
	public function getMinHeight():Value;
	public function getMinWidth():Value;
	public function getOverflow():Overflow;
	public function getPadding(edge:Edge):Value;
	public function getParent():YogaNodeRef;
	public function getPosition(edge:Edge):Value;
	public function getPositionType():PositionType;
	public function getWidth():Value;
	public function insertChild(child:YogaNodeRef, index:Int):Void;
	public function isDirty():Bool;
	public function isReferenceBaseline():Bool;
	public function markDirty():Void;
	public function hasNewLayout():Bool;
	public function markLayoutSeen():Void;
	public function removeChild(child:YogaNodeRef):Void;
	public function reset():Void;
	public function setAlignContent(alignContent:Align):Void;
	public function setAlignItems(alignItems:Align):Void;
	public function setAlignSelf(alignSelf:Align):Void;
	public function setAspectRatio(aspectRatio:Float):Void;
	public function setBorder(edge:Edge, borderWidth:Float):Void;
	public function setDirection(direction:Direction):Void;
	public function setDisplay(display:Display):Void;
	public function setFlex(flex:Int):Void;
	public function setFlexBasis(flexBasis:Float):Void;
	public function setFlexBasisPercent(flexBasis:Float):Void;
	public function setFlexBasisAuto():Void;
	public function setFlexDirection(flexDirection:FlexDirection):Void;
	public function setFlexGrow(flexGrow:Float):Void;
	public function setFlexShrink(flexShrink:Float):Void;
	public function setFlexWrap(flexWrap:Wrap):Void;
	public function setHeight(height:Float):Void;
	public function setIsReferenceBaseline(isReferenceBaseline:Bool):Void;
	public function setHeightAuto():Void;
	public function setHeightPercent(height:Float):Void;
	public function setJustifyContent(justifyContent:Justify):Void;
	public function setGap(gutter:Gutter, gapLength:Float):Value;
	public function setGapPercent(gutter:Gutter, gapLength:Float):Value;
	public function setMargin(edge:Edge, margin:Float):Void;
	public function setMarginAuto(edge:Edge):Void;
	public function setMarginPercent(edge:Edge, margin:Float):Void;
	public function setMaxHeight(maxHeight:Float):Void;
	public function setMaxHeightPercent(maxHeight:Float):Void;
	public function setMaxWidth(maxWidth:Float):Void;
	public function setMaxWidthPercent(maxWidth:Float):Void;
	public function setDirtiedFunc(dirtiedFunc:DirtiedFunction):Void;
	public function setMeasureFunc(measureFunc:MeasureFunction):Void;
	public function setMinHeight(minHeight:Float):Void;
	public function setMinHeightPercent(minHeight:Float):Void;
	public function setMinWidth(minWidth:Float):Void;
	public function setMinWidthPercent(minWidth:Float):Void;
	public function setOverflow(overflow:Overflow):Void;
	public function setPadding(edge:Edge, padding:Float):Void;
	public function setPaddingPercent(edge:Edge, padding:Float):Void;
	public function setPosition(edge:Edge, position:Float):Void;
	public function setPositionPercent(edge:Edge, position:Float):Void;
	public function setPositionType(positionType:PositionType):Void;
	public function setWidth(width:Float):Void;
	public function setWidthAuto():Void;
	public function setWidthPercent(width:Float):Void;
	public function unsetDirtiedFunc():Void;
	public function unsetMeasureFunc():Void;
	public function setAlwaysFormsContainingBlock(alwaysFormsContainingBlock:Bool):Void;
}

class YogaNode {
	public var node:YogaNodeRef;

	public function new(?ref:YogaNodeRef) {
		node = ref != null ? null : untyped js.Syntax.code("window.__yoga.Node.create()");
	}

	function addChild(child:YogaNodeRef, index:Int) {
		node.insertChild(child, index);
	}

	public function setSize(width:Float, height:Float) {
		node.setWidth(width);
		node.setHeight(height);
	}

	public function calculateLayout(width:Float, height:Float, ?direction:Direction):Void {
		node.calculateLayout(width, height, direction);
	}

	public function copyStyle(?node:YogaNodeRef):Void {
		node.copyStyle(node);
	}

	public function free():Void {
		node.free();
	}

	public function freeRecursive():Void {
		node.freeRecursive();
	}

	public function getAlignContent():Align {
		return node.getAlignContent();
	}

	public function getAlignItems():Align {
		return node.getAlignItems();
	}

	public function getAlignSelf():Align {
		return node.getAlignSelf();
	}

	public function getAspectRatio():Float {
		return node.getAspectRatio();
	}

	public function getBorder(edge:Edge):Float {
		return node.getBorder(edge);
	}

	public function getChild(index:Int):YogaNode {
		return new YogaNode(node.getChild(index));
	}

	public function getChildCount():Float {
		return node.getChildCount();
	}

	public function getComputedBorder(edge:Edge):Float {
		return node.getComputedBorder(edge);
	}

	public function getComputedBottom():Float {
		return node.getComputedBottom();
	}

	public function getComputedHeight():Float {
		return node.getComputedHeight();
	}

	public function getComputedLayout():Layout {
		return node.getComputedLayout();
	}

	public function getComputedLeft():Float {
		return node.getComputedLeft();
	}

	public function getComputedMargin(edge:Edge):Float {
		return node.getComputedMargin(edge);
	}

	public function getComputedPadding(edge:Edge):Float {
		return node.getComputedPadding(edge);
	}

	public function getComputedRight():Float {
		return node.getComputedRight();
	}

	public function getComputedTop():Float {
		return node.getComputedTop();
	}

	public function getComputedWidth():Float {
		return node.getComputedWidth();
	}

	public function getDirection():Direction {
		return node.getDirection();
	}

	public function getDisplay():Display {
		return node.getDisplay();
	}

	public function getFlexBasis():Value {
		return node.getFlexBasis();
	}

	public function getFlexDirection():FlexDirection {
		return node.getFlexDirection();
	}

	public function getFlexGrow():Float {
		return node.getFlexGrow();
	}

	public function getFlexShrink():Float {
		return node.getFlexShrink();
	}

	public function getFlexWrap():Wrap {
		return node.getFlexWrap();
	}

	public function getHeight():Value {
		return node.getHeight();
	}

	public function getJustifyContent():Justify {
		return node.getJustifyContent();
	}

	public function getGap(gutter:Gutter):Float {
		return node.getGap(gutter);
	}

	public function getMargin(edge:Edge):Value {
		return node.getMargin(edge);
	}

	public function getMaxHeight():Value {
		return node.getMaxHeight();
	}

	public function getMaxWidth():Value {
		return node.getMaxWidth();
	}

	public function getMinHeight():Value {
		return node.getMinHeight();
	}

	public function getMinWidth():Value {
		return node.getMinWidth();
	}

	public function getOverflow():Overflow {
		return node.getOverflow();
	}

	public function getPadding(edge:Edge):Value {
		return node.getPadding(edge);
	}

	public function getParent():YogaNode {
		return new YogaNode(node.getParent());
	}

	public function getPosition(edge:Edge):Value {
		return node.getPosition(edge);
	}

	public function getPositionType():PositionType {
		return node.getPositionType();
	}

	public function getWidth():Value {
		return node.getWidth();
	}

	public function isDirty():Bool {
		return node.isDirty();
	}

	public function isReferenceBaseline():Bool {
		return node.isReferenceBaseline();
	}

	public function markDirty():Void {
		node.markDirty();
	}

	public function hasNewLayout():Bool {
		return node.hasNewLayout();
	}

	public function markLayoutSeen():Void {
		node.markLayoutSeen();
	}

	public function removeChild(child:YogaNodeRef):Void {
		node.removeChild(child);
	}

	public function reset():Void {
		node.reset();
	}

	public function setAlignContent(alignContent:Align):Void {
		node.setAlignContent(alignContent);
	}

	public function setAlignItems(alignItems:Align):Void {
		node.setAlignItems(alignItems);
	}

	public function setAlignSelf(alignSelf:Align):Void {
		node.setAlignSelf(alignSelf);
	}

	public function setAspectRatio(aspectRatio:Float):Void {
		node.setAspectRatio(aspectRatio);
	}

	public function setBorder(edge:Edge, borderWidth:Float):Void {
		node.setBorder(edge, borderWidth);
	}

	public function setDirection(direction:Direction):Void {
		node.setDirection(direction);
	}

	public function setDisplay(display:Display):Void {
		node.setDisplay(display);
	}

	public function setFlex(flex:Int):Void {
		node.setFlex(flex);
	}

	public function setFlexBasis(flexBasis:Float):Void {
		node.setFlexBasis(flexBasis);
	}

	public function setFlexBasisPercent(flexBasis:Float):Void {
		node.setFlexBasisPercent(flexBasis);
	}

	public function setFlexBasisAuto():Void {
		node.setFlexBasisAuto();
	}

	public function setFlexDirection(flexDirection:FlexDirection):Void {
		node.setFlexDirection(flexDirection);
	}

	public function setFlexGrow(flexGrow:Float):Void {
		node.setFlexGrow(flexGrow);
	}

	public function setFlexShrink(flexShrink:Float):Void {
		node.setFlexShrink(flexShrink);
	}

	public function setFlexWrap(flexWrap:Wrap):Void {
		node.setFlexWrap(flexWrap);
	}

	public function setHeight(height:Float):Void {
		node.setHeight(height);
	}

	public function setIsReferenceBaseline(isReferenceBaseline:Bool):Void {
		node.setIsReferenceBaseline(isReferenceBaseline);
	}

	public function setHeightAuto():Void {
		node.setHeightAuto();
	}

	public function setHeightPercent(height:Float):Void {
		node.setHeightPercent(height);
	}

	public function setJustifyContent(justifyContent:Justify):Void {
		node.setJustifyContent(justifyContent);
	}

	public function setGap(gutter:Gutter, gapLength:Float):Void {
		node.setGap(gutter, gapLength);
	}

	public function setGapPercent(gutter:Gutter, gapLength:Float):Void {
		node.setGapPercent(gutter, gapLength);
	}

	public function setMargin(edge:Edge, margin:Float):Void {
		node.setMargin(edge, margin);
	}

	public function setMarginAuto(edge:Edge):Void {
		node.setMarginAuto(edge);
	}

	public function setMarginPercent(edge:Edge, margin:Float):Void {
		node.setMarginPercent(edge, margin);
	}

	public function setMaxHeight(maxHeight:Float):Void {
		node.setMaxHeight(maxHeight);
	}

	public function setMaxHeightPercent(maxHeight:Float):Void {
		node.setMaxHeightPercent(maxHeight);
	}

	public function setMaxWidth(maxWidth:Float):Void {
		node.setMaxWidth(maxWidth);
	}

	public function setMaxWidthPercent(maxWidth:Float):Void {
		node.setMaxWidthPercent(maxWidth);
	}

	public function setDirtiedFunc(dirtiedFunc:DirtiedFunction):Void {
		node.setDirtiedFunc(dirtiedFunc);
	}

	public function setMeasureFunc(measureFunc:MeasureFunction):Void {
		node.setMeasureFunc(measureFunc);
	}

	public function setMinHeight(minHeight:Float):Void {
		node.setMinHeight(minHeight);
	}

	public function setMinHeightPercent(minHeight:Float):Void {
		node.setMinHeightPercent(minHeight);
	}

	public function setMinWidth(minWidth:Float):Void {
		node.setMinWidth(minWidth);
	}

	public function setMinWidthPercent(minWidth:Float):Void {
		node.setMaxWidthPercent(minWidth);
	}

	public function setOverflow(overflow:Overflow):Void {
		node.setOverflow(overflow);
	}

	public function setPadding(edge:Edge, padding:Float):Void {
		node.setPadding(edge, padding);
	}

	public function setPaddingPercent(edge:Edge, padding:Float):Void {
		node.setPaddingPercent(edge, padding);
	}

	public function setPosition(edge:Edge, position:Float):Void {
		node.setPosition(edge, position);
	}

	public function setPositionPercent(edge:Edge, position:Float):Void {
		node.setPaddingPercent(edge, position);
	}

	public function setPositionType(positionType:PositionType):Void {
		node.setPositionType(positionType);
	}

	public function setWidth(width:Float):Void {
		node.setWidth(width);
	}

	public function setWidthAuto():Void {
		node.setWidthAuto();
	}

	public function setWidthPercent(width:Float):Void {
		node.setWidthPercent(width);
	}

	public function unsetDirtiedFunc():Void {
		node.unsetDirtiedFunc();
	}

	public function unsetMeasureFunc():Void {
		node.unsetMeasureFunc();
	}

	public function setAlwaysFormsContainingBlock(alwaysFormsContainingBlock:Bool):Void {
		node.setAlwaysFormsContainingBlock(alwaysFormsContainingBlock);
	}
}
