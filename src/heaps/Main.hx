package heaps;

import neon.core.Common;
import neon.core.State;
import hxd.App;

class Main extends App {
	override function init() {
		var count = createSignal(0);
		setInterval(function() count.set(count.get() + 1), 10);

		neon.platform.heaps.Renderer.render(s2d, Game, {count: count});
	}

	public static function main() {
		new Main();
	}
}

var Game = createComponent(function(props:{count:Signal<Int>}) {
	return createElement("text", {}, props.count.get());
});
