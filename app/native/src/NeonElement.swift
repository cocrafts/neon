import UIKit
import yoga

public enum Atomic {
	case String(String)
	case Float(Float)
	case Int(Int)
}

public class Element {
	var instance: UIView
	var yoga: YGNodeRef

	init(view: UIView) {
		instance = view
		yoga = YGNodeNew()
	}

	public func synchornizeSize() {
		instance.frame.size.width = CGFloat(YGNodeStyleGetWidth(yoga).value)
		instance.frame.size.height = CGFloat(YGNodeStyleGetHeight(yoga).value)
	}

	public func synchornizePosition() {
		instance.layoutMargins.top = CGFloat(YGNodeStyleGetPosition(yoga, YGEdge.top).value)
		instance.layoutMargins.bottom = CGFloat(YGNodeStyleGetPosition(yoga, YGEdge.bottom).value)
		instance.layoutMargins.left = CGFloat(YGNodeStyleGetPosition(yoga, YGEdge.left).value)
		instance.layoutMargins.right = CGFloat(YGNodeStyleGetPosition(yoga, YGEdge.right).value)
	}

	public func addChild(child: Element) {
		print("adding child..")
		child.instance.sizeToFit()
		child.instance.frame = instance.bounds
		instance.addSubview(child.instance)
	}

	public func setProp(key: String, value: Atomic) {
		print("setProp \(key): \(value) for this component not implemented yet!")
	}

	public func setStyle(key: String, value: Atomic) {
		print("setStyle \(key): \(value) for this component not implemented yet!")
	}
}
