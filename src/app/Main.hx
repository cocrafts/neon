package;

import neon.core.Common;
import neon.yoga.Node;

class Main {
	public static function main() {
		var node = new YogaNode();
		node.setHeight(100.0);
		node.setWidth(100.0);
		var height = node.getHeight();
		var el = createElement("div", {}, []);

		trace(el, "<-- element");
		trace("height of node is: ", height.value, height.unit == YogaUnit.Point);
		trace("hello again, from official hxcpp!");
	}
}
