package site;

import js.Browser.document;
import neon.core.Common;
import neon.core.State;
import site.components.App;
import game.components.Game;
import hxd.App;

class Main extends App {
	override function init() {
		var count = createSignal(0);
		setInterval(function() {
			var currentCount = count.get();
			if (currentCount > 9999) {
				count.set(0);
			} else {
				count.set(currentCount + 1);
			}
		}, 10);
		neon.platform.heaps.Renderer.render(s2d, Game, {count: count});
		neon.platform.browser.Renderer.render(document.body, App, {count: count});
	}

	public static function main() {
		new Main();
	}
}
