package game;

import hxd.App;
import game.components.Game;

class Main extends App {
	override function init() {
		neon.platform.heaps.Renderer.render(s2d, Game);
	}

	public static function main() {
		new Main();
	}
}
