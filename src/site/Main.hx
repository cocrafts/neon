package site;

import haxe.Timer;
import js.Browser.document;
import neon.core.Common;
import neon.core.State;
import neon.platform.Renderer;
import site.components.Branding;
import site.components.Navigator;

var count = new Signal(0);

typedef AppProps = {
	var name:String;
};

class Main {
	public static function main() {
		setInterval(function() {
			var currentCount = count.get();
			if (currentCount > 9999) {
				count.set(0);
			} else {
				count.set(currentCount + 1);
			}
		}, 10);

		var app = createElement("div", {}, [
			Branding({main: "neon", sub: "build cross-platform app in native runtime!", count: count}),
			Navigator({}),
		]);

		universalRender(app, document.body);
		render(app, document.body);
	}

	static function setInterval(callback:Void->Void, interval:Int):Timer {
		var timer = new Timer(interval);
		timer.run = callback;
		return timer;
	}
}
