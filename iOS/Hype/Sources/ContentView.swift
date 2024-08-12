import SwiftUI
import yoga

public struct ContentView: View {
	public init() {
        justAnotherMethod();
        Main.main();

		var root: YGNodeRef = YGNodeNew()
        YGNodeStyleSetWidth(root, 100);
        print("width of node from Swift: ", YGNodeStyleGetWidth(root).unit);
	}

	public var body: some View {
		Text("Display !!")
			.padding()
	}
}
