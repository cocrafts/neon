import SwiftUI
import yoga

public struct ContentView: View {
	public init() {
        justAnotherMethod();
        
        var root: YGNodeRef = YGNodeNew();
        print(root);
	}

	public var body: some View {
		Text("Display !!")
			.padding()
	}
}
