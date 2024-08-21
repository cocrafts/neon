package;

import neon.yoga.Types;
import neon.core.Common;
import neon.platform.swiftui.Renderer;
#if js
import neon.yoga.browser.Node;
#else
import neon.yoga.native.Node;
#end

class Main {
	public static function main() {
		#if js
		js.Browser.document.addEventListener('yogaReady', configure);
		#else
		configure();
		#end

		render();
		var renderer = new SwiftUIRenderer();
		trace(renderer);
	}

	static function configure() {
		// trace("height of node is: ", height.value, height.unit == YogaUnit.Point);
		var node = new YogaNode();
		node.setHeight(100.0);
		node.setWidth(100.0);
		node.setPadding(Edge.All, 10.0);
		var height = node.getHeight();
		var el = createElement("div", {}, []);
		trace(height.value, height.unit == Unit.Point, node.getPadding(Edge.All), "<-- element");
	}
}
