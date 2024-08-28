import UIKit
import yoga

func setViewStyle(key: String, value: Atomic, element: Element) -> Bool {
	if let attribute = ViewStyleAttribute(rawValue: key) {
		switch (value) {
		case .Float(let floatValue):
			switch attribute {
			case .borderWidth, .borderTopWidth, .borderBottomWidth, .borderLeftWidth, .borderRightWidth:
				if attribute == .borderWidth {
					element.instance.layer.borderWidth = CGFloat(floatValue)
					YGNodeStyleSetBorder(element.yoga, .all, floatValue)
				} else {
					print("Detailed borderWidth at edges not supported yet, would need to use CALayer()")
				}
			case .borderRadius, .borderTopLeftRadius, .borderTopRightRadius, .borderBottomLeftRadius, .borderBottomRightRadius:
				if attribute == .borderRadius {
					element.instance.layer.cornerRadius = CGFloat(floatValue)
				} else {
					print("Detailed borderRadius at edges not supported yet, would need to use CAShapeLayer() and masking")
				}
			case .width, .height, .top, .bottom, .left, .right:
				if attribute == .width {
					YGNodeStyleSetWidth(element.yoga, floatValue)
					element.synchornizeSize()
				} else if attribute == .height {
					YGNodeStyleSetHeight(element.yoga, floatValue)
					element.synchornizeSize()
				} else if attribute == .top {
					YGNodeStyleSetPosition(element.yoga, .top, floatValue)
					element.synchornizePosition()
				} else if attribute == .bottom {
					YGNodeStyleSetPosition(element.yoga, .bottom, floatValue)
					element.synchornizePosition()
				} else if attribute == .left {
					YGNodeStyleSetPosition(element.yoga, .left, floatValue)
					element.synchornizePosition()
				} else if attribute == .right {
					YGNodeStyleSetPosition(element.yoga, .right, floatValue)
					element.synchornizePosition()
				}
			case .flex, .flexBasis, .flexGrow, .flexShrink, .gap:
				if attribute == .flex {
					YGNodeStyleSetFlex(element.yoga, floatValue)
				} else if attribute == .flexBasis {
					YGNodeStyleSetFlexBasis(element.yoga, floatValue)
				} else if attribute == .flexGrow {
					YGNodeStyleSetFlexGrow(element.yoga, floatValue)
				} else if attribute == .flexShrink {
					YGNodeStyleSetFlexShrink(element.yoga, floatValue)
				} else if attribute == .gap {
					YGNodeStyleSetGap(element.yoga, .all, floatValue)
				}
			case .margin, .marginTop, .marginBottom, .marginLeft, .marginRight:
				if attribute == .margin {
					YGNodeStyleSetMargin(element.yoga, .all, floatValue)
					element.synchornizePosition()
				} else if attribute == .marginTop {
					YGNodeStyleSetMargin(element.yoga, .top, floatValue)
					element.synchornizePosition()
				} else if attribute == .marginBottom {
					YGNodeStyleSetMargin(element.yoga, .bottom, floatValue)
					element.synchornizePosition()
				} else if attribute == .marginLeft {
					YGNodeStyleSetMargin(element.yoga, .left, floatValue)
					element.synchornizePosition()
				} else if attribute == .marginRight {
					YGNodeStyleSetMargin(element.yoga, .right, floatValue)
					element.synchornizePosition()
				}
			case .padding, .paddingTop, .paddingBottom, .paddingLeft, .paddingRight:
				if attribute == .padding {
					YGNodeStyleSetPadding(element.yoga, .all, floatValue)
				} else if attribute == .paddingTop {
					YGNodeStyleSetPadding(element.yoga, .top, floatValue)
				} else if attribute == .paddingBottom {
					YGNodeStyleSetPadding(element.yoga, .bottom, floatValue)
				} else if attribute == .paddingLeft {
					YGNodeStyleSetPadding(element.yoga, .left, floatValue)
				} else if attribute == .paddingRight {
					YGNodeStyleSetPadding(element.yoga, .right, floatValue)
				}
			case .maxWidth, .maxHeight, .minWidth, .minHeight, .opacity, .zIndex:
				if attribute == .maxWidth {
					YGNodeStyleSetMaxWidth(element.yoga, floatValue)
					element.synchornizeSize()
				} else if attribute == .maxHeight {
					YGNodeStyleSetMaxHeight(element.yoga, floatValue)
					element.synchornizeSize()
				} else if attribute == .minWidth {
					YGNodeStyleSetMinWidth(element.yoga, floatValue)
					element.synchornizeSize()
				} else if attribute == .minHeight {
					YGNodeStyleSetMinHeight(element.yoga, floatValue)
					element.synchornizeSize()
				} else if attribute == .opacity {
					element.instance.alpha = CGFloat(floatValue)
				} else if attribute == .zIndex {
					print("zIndex attribute not supported yet!")
				}
			default:
				print("Ignored \(key): \(value) View's style attribute")
			}
		case .String(let stringValue):
			switch attribute {
			case .alignItems, .alignContent, .alignSelf:
				if let align = FlexAlign(rawValue: stringValue) {
					if attribute == .alignItems {
						YGNodeStyleSetAlignItems(element.yoga, align.yoga)
					} else if attribute == .alignContent {
						YGNodeStyleSetAlignContent(element.yoga, align.yoga)
					} else if attribute == .alignSelf {
						YGNodeStyleSetAlignSelf(element.yoga, align.yoga)
					}
				}
			case .backgroundColor, .borderColor:
				if attribute == .backgroundColor {
					element.instance.backgroundColor = UIColor(hex: stringValue)
				} else if attribute == .borderColor {
					element.instance.layer.borderColor = CGColor.from(hex: stringValue)
				}
			case .flexDirection:
				if let direction = FlexDirection(rawValue: stringValue) {
					YGNodeStyleSetFlexDirection(element.yoga, direction.yoga)
				}
			case .justifyContent:
				if let justify = Justify(rawValue: stringValue) {
					if attribute == .alignItems {
						YGNodeStyleSetJustifyContent(element.yoga, justify.yoga)
					}
				}
			case .overflow:
				if stringValue == "hidden" {
					element.instance.clipsToBounds = true
				} else {
					element.instance.clipsToBounds = false
				}
			default:
				print("Ignored \(key): \(value) View's style attribute")
			}
		case .Int(_):
			return false
		}

		return true
	}

	return false
}

func setTextStyle(key: String, value: Atomic, element: Element) -> Bool {
	if let attribute = TextStyleAttribute(rawValue: key) {
		if let label = element.instance as? UILabel {
			switch (value) {
			case .Float(let floatValue):
				switch attribute {
				case .fontSize:
					label.font = UIFont.systemFont(ofSize: CGFloat(floatValue))
				default:
					print("Ignored \(key): \(value) Text's style attribute")
				}
			case .String(let stringValue):
				switch attribute {
				case .color:
					label.textColor = UIColor(hex: stringValue)
				case .textAlign:
					if let align = TextAlign(rawValue: stringValue) {
						label.textAlignment = align.nsTextAlignment
					}
				default:
					print("Ignored \(key): \(value) Text's style attribute")
				}
			case .Int(_):
				return false
			}
			
			return true
		}
	}

	return false
}

func setTextProp(key: String, value: Atomic, element: Element) -> Bool {
	print("SetText prop \(value)")
	if let prop = TextProp(rawValue: key) {
		if let label = element.instance as? UILabel {
			switch (value) {
			case .Float(_):
				print("Not yet!")
			case .String(let stringValue):
				if prop == .text {
					label.text = stringValue
				}
			case .Int(_):
				return false
			}

			return true
		}
	}

	return false
}

enum ViewStyleAttribute: String {
	case alignItems
	case alignContent
	case alignSelf
	case backgroundColor
	case borderColor
	case borderWidth
	case borderTopWidth
	case borderBottomWidth
	case borderLeftWidth
	case borderRightWidth
	case borderRadius
	case borderTopLeftRadius
	case borderTopRightRadius
	case borderBottomLeftRadius
	case borderBottomRightRadius
	case cursor
	case width
	case height
	case top
	case bottom
	case left
	case right
	case flex
	case flexBasis
	case flexDirection
	case flexFlow
	case flexGrow
	case flexShrink
	case flexWrap
	case gap
	case justifyContent
	case margin
	case marginTop
	case marginBottom
	case marginLeft
	case marginRight
	case maxWidth
	case maxHeight
	case minWidth
	case minHeight
	case opacity
	case overflow
	case padding
	case paddingTop
	case paddingBottom
	case paddingLeft
	case paddingRight
	case position
	case transform
	case zIndex
}

enum TextStyleAttribute: String {
	case color
	case fontSize
	case fontFamily
	case fontStyle
	case fontWeight
	case textAlign
	case textDecorationLine
	case textDecorationStyle
	case textDecorationThickness
	case wordSpacing
}

enum TextProp: String {
	case text
}

enum FlexAlign: String {
	case auto
	case flexStart
	case center
	case flexEnd
	case stretch
	case baseline
	case spaceBetween
	case spaceAround
	case spaceEvenly

	var yoga: YGAlign {
		switch self {
		case .auto:
			return .auto
		case .flexStart:
			return .flexStart
		case .center:
			return .center
		case .flexEnd:
			return .flexEnd
		case .stretch:
			return .stretch
		case .baseline:
			return .baseline
		case .spaceBetween:
			return .spaceBetween
		case .spaceAround:
			return .spaceAround
		case .spaceEvenly:
			return .spaceEvenly
		}
	}
}

enum FlexDirection: String {
	case column
	case columnReverse
	case row
	case rowReverse
	
	var yoga: YGFlexDirection {
		switch self {
		case .column:
			return .column
		case .columnReverse:
			return .columnReverse
		case .row:
			return .row
		case .rowReverse:
			return .rowReverse
		}
	}
}

enum Justify: String {
	case flexStart
	case flexEnd
	case center
	case spaceBetween
	case spaceAround
	case spaceEvenly
	
	var yoga: YGJustify {
		switch self {
		case .flexStart:
			return .flexStart
		case .flexEnd:
			return .flexEnd
		case .center:
			return .center
		case .spaceBetween:
			return .spaceBetween
		case .spaceAround:
			return .spaceAround
		case .spaceEvenly:
			return .spaceEvenly
		}
	}
}

enum TextAlign: String {
	case left
	case right
	case center
	case justify
	
	var nsTextAlignment: NSTextAlignment {
		switch self {
		case .left:
			return .left
		case .right:
			return .right
		case .center:
			return .center
		case .justify:
			return .justified
		}
	}
}
