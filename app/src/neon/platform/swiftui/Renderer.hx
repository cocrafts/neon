package neon.platform.swiftui;

@:headerInclude("Bridge.h")
class SwiftUIRenderer {
	public function new() {}
}

function render() {
	untyped __cpp__("neon::bridge::render()");
}
