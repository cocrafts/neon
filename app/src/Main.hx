package;

import neon.yoga.Types;
import neon.core.Common;
import neon.core.State;
import neon.platform.catalyst.Renderer;
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
	}

	public static function onApplicationReady(container:Any) {
		// Renderer.render(container);
	}

	static function configure() {
		var message = createElement("Text", {
			text: "Hello world from Haxe!",
			style: {
				color: "#ffffff",
				fontSize: 18,
				backgroundColor: "#ff0000",
				textAlign: "center"
			},
		}, []);

		var greet = createElement("Text", {
			text: "Greeting message...",
			style: {
				color: "#ffffff",
				fontSize: 18,
				textAlign: "center"
			},
		}, []);

		var app = createElement("View", {}, [message, greet]);
		Renderer.render(Renderer.getRootElement(), app);

		// var node = new YogaNode();
		// node.setHeight(100.0);
		// node.setWidth(100.0);
		// node.setPadding(Edge.All, 10.0);
		// var height = node.getHeight();
		// var getEl = createElement("div", {}, []);
		// var el = getEl();
		// el.setProp("text", "Definitely Cool!!!");
		// trace(height.value, height.unit == Unit.Point, node.getPadding(Edge.All), "<-- element");
	}
}
