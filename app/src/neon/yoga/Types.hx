package neon.yoga;

typedef Size = {
	var width:Float;
	var height:Float;
};

typedef Layout = {
	var left:Float;
	var right:Float;
	var top:Float;
	var bottom:Float;
	var width:Float;
	var height:Float;
};

enum abstract Dimension(Int) {
	var Width = 0;
	var Height = 1;
}

enum abstract Direction(Int) {
	var Inherit = 0;
	var LTR = 1;
	var RTL = 2;
}

enum abstract Display(Int) {
	var Flex = 0;
	var None = 1;
}

// // @:valueType
// // @:native("YGUnit")
// enum abstract YogaUnit(Int) {
// 	var Undefined = 0;
// 	var Point = 1;
// 	var Percent = 2;
// 	var Auto = 3;
// }

enum abstract Edge(Int) {
	var Left = 0;
	var Top = 1;
	var Right = 2;
	var Bottom = 3;
	var Start = 4;
	var End = 5;
	var Horizontal = 6;
	var Vertical = 7;
	var All = 8;
}

enum abstract Errata(Int) {
	var None = 0;
	var StretchFlexBasis = 1;
	var AbsolutePositioningIncorrect = 2;
	var AbsolutePercentAgainstInnerSize = 4;
	var All = 2147483647;
	var Classic = 2147483646;
}

enum abstract ExperimentalFeature(Int) {
	var WebFlexBasis = 0;
}

enum abstract FlexDirection(Int) {
	var Column = 0;
	var ColumnReverse = 1;
	var Row = 2;
	var RowReverse = 3;
}

enum abstract Gutter(Int) {
	var Column = 0;
	var Row = 1;
	var All = 2;
}

enum abstract Justify(Int) {
	var FlexStart = 0;
	var Center = 1;
	var FlexEnd = 2;
	var SpaceBetween = 3;
	var SpaceAround = 4;
	var SpaceEvenly = 5;
}

enum abstract LogLevel(Int) {
	var Error = 0;
	var Warn = 1;
	var Info = 2;
	var Debug = 3;
	var Verbose = 4;
	var Fatal = 5;
}

enum abstract MeasureMode(Int) {
	var Undefined = 0;
	var Exactly = 1;
	var AtMost = 2;
}

enum abstract NodeType(Int) {
	var Default = 0;
	var Text = 1;
}

enum abstract Overflow(Int) {
	var Visible = 0;
	var Hidden = 1;
	var Scroll = 2;
}

enum abstract PositionType(Int) {
	var Static = 0;
	var Relative = 1;
	var Absolute = 2;
}

enum abstract Unit(Int) {
	var Undefined = 0;
	var Point = 1;
	var Percent = 2;
	var Auto = 3;
}

enum abstract Wrap(Int) {
	var NoWrap = 0;
	var Wrap = 1;
	var WrapReverse = 2;
}

enum abstract Align(Int) {
	var Auto = 0;
	var FlexStart = 1;
	var Center = 2;
	var FlexEnd = 3;
	var Stretch = 4;
	var Baseline = 5;
	var SpaceBetween = 6;
	var SpaceAround = 7;
	var SpaceEvenly = 8;
}

var constants = {
	ALIGN_AUTO: Align.Auto,
	ALIGN_FLEX_START: Align.FlexStart,
	ALIGN_CENTER: Align.Center,
	ALIGN_FLEX_END: Align.FlexEnd,
	ALIGN_STRETCH: Align.Stretch,
	ALIGN_BASELINE: Align.Baseline,
	ALIGN_SPACE_BETWEEN: Align.SpaceBetween,
	ALIGN_SPACE_AROUND: Align.SpaceAround,
	ALIGN_SPACE_EVENLY: Align.SpaceEvenly,
	DIMENSION_WIDTH: Dimension.Width,
	DIMENSION_HEIGHT: Dimension.Height,
	DIRECTION_INHERIT: Direction.Inherit,
	DIRECTION_LTR: Direction.LTR,
	DIRECTION_RTL: Direction.RTL,
	DISPLAY_FLEX: Display.Flex,
	DISPLAY_NONE: Display.None,
	EDGE_LEFT: Edge.Left,
	EDGE_TOP: Edge.Top,
	EDGE_RIGHT: Edge.Right,
	EDGE_BOTTOM: Edge.Bottom,
	EDGE_START: Edge.Start,
	EDGE_END: Edge.End,
	EDGE_HORIZONTAL: Edge.Horizontal,
	EDGE_VERTICAL: Edge.Vertical,
	EDGE_ALL: Edge.All,
	ERRATA_NONE: Errata.None,
	ERRATA_STRETCH_FLEX_BASIS: Errata.StretchFlexBasis,
	ERRATA_ABSOLUTE_POSITIONING_INCORRECT: Errata.AbsolutePositioningIncorrect,
	ERRATA_ABSOLUTE_PERCENT_AGAINST_INNER_SIZE: Errata.AbsolutePercentAgainstInnerSize,
	ERRATA_ALL: Errata.All,
	ERRATA_CLASSIC: Errata.Classic,
	EXPERIMENTAL_FEATURE_WEB_FLEX_BASIS: ExperimentalFeature.WebFlexBasis,
	FLEX_DIRECTION_COLUMN: FlexDirection.Column,
	FLEX_DIRECTION_COLUMN_REVERSE: FlexDirection.ColumnReverse,
	FLEX_DIRECTION_ROW: FlexDirection.Row,
	FLEX_DIRECTION_ROW_REVERSE: FlexDirection.RowReverse,
	GUTTER_COLUMN: Gutter.Column,
	GUTTER_ROW: Gutter.Row,
	GUTTER_ALL: Gutter.All,
	JUSTIFY_FLEX_START: Justify.FlexStart,
	JUSTIFY_CENTER: Justify.Center,
	JUSTIFY_FLEX_END: Justify.FlexEnd,
	JUSTIFY_SPACE_BETWEEN: Justify.SpaceBetween,
	JUSTIFY_SPACE_AROUND: Justify.SpaceAround,
	JUSTIFY_SPACE_EVENLY: Justify.SpaceEvenly,
	LOG_LEVEL_ERROR: LogLevel.Error,
	LOG_LEVEL_WARN: LogLevel.Warn,
	LOG_LEVEL_INFO: LogLevel.Info,
	LOG_LEVEL_DEBUG: LogLevel.Debug,
	LOG_LEVEL_VERBOSE: LogLevel.Verbose,
	LOG_LEVEL_FATAL: LogLevel.Fatal,
	MEASURE_MODE_UNDEFINED: MeasureMode.Undefined,
	MEASURE_MODE_EXACTLY: MeasureMode.Exactly,
	MEASURE_MODE_AT_MOST: MeasureMode.AtMost,
	NODE_TYPE_DEFAULT: NodeType.Default,
	NODE_TYPE_TEXT: NodeType.Text,
	OVERFLOW_VISIBLE: Overflow.Visible,
	OVERFLOW_HIDDEN: Overflow.Hidden,
	OVERFLOW_SCROLL: Overflow.Scroll,
	POSITION_TYPE_STATIC: PositionType.Static,
	POSITION_TYPE_RELATIVE: PositionType.Relative,
	POSITION_TYPE_ABSOLUTE: PositionType.Absolute,
	UNIT_UNDEFINED: Unit.Undefined,
	UNIT_POINT: Unit.Point,
	UNIT_PERCENT: Unit.Percent,
	UNIT_AUTO: Unit.Auto,
	WRAP_NO_WRAP: Wrap.NoWrap,
	WRAP_WRAP: Wrap.Wrap,
	WRAP_WRAP_REVERSE: Wrap.WrapReverse,
}
