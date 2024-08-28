import UIKit

public class NeonText: Element {
	init() {
		super.init(view: UILabel() as UIView)
	}

	override public func setProp(key: String, value: Atomic) {
		if !setTextProp(key: key, value: value, element: self) {
			print("ignored setProp [\(key): \(value)]")
		}
	}

	override public func setStyle(key: String, value: Atomic) {
		if !setViewStyle(key: key, value: value, element: self) {
			_ = setTextStyle(key: key, value: value, element: self)
		}
	}
}

public func makeNeonText() -> NeonText {
	NeonText()
}
