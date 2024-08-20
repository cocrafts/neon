import SwiftUI
import yoga

struct ContentView: View {
	public init() {
		let root: YGNodeRef = YGNodeNew()
		justAnotherMethod()
		YGNodeStyleSetWidth(root, 100)
		Main.main()
		print("width of node from Swift: ", YGNodeStyleGetWidth(root).value)
	}

	var body: some View {
		Text("Hello, SwiftUI!")
			.padding()
	}
}

public func greet() -> String {
	return "Greet"
}
