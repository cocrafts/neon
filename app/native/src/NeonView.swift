import UIKit

public class NeonView: Element {
	init() {
		super.init(view: UIView())
	}
	
	override public func setProp(key _: String, value _: Atomic) {}
	override public func setStyle(key: String, value: Atomic) {
		_ = setViewStyle(key: key, value: value, element: self)
	}
}

public func makeNeonView() -> NeonView {
	NeonView()
}
