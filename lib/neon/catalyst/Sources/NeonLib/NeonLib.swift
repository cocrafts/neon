import UIKit

public class Element {
	var instance: UIView

	init(view: UIView) {
		instance = view
	}

	public func setProp(key _: String, value _: String) {}
	public func addChild(child _: Element) {}
}
