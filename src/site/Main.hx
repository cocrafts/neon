package site;

import js.Browser.document;
import neon.core.Common;
import neon.core.State;
import neon.platform.Renderer;
import site.components.Branding;
import site.components.Navigator;

typedef AppProps = {
	var name:String;
};

class Main {
	public static function main() {
		render(App, document.body);
	}
}

var App = createComponent(function(props:{}) {
	var count = createSignal(100);

	setInterval(function() {
		var currentCount = count.get();
		if (currentCount > 9999) {
			count.set(0);
		} else {
			count.set(currentCount + 1);
		}
	}, 10);

	return createElement("div", {}, [
		Branding({main: "neon", sub: "build cross-platform app in native runtime!", count: count}),
		Navigator({}),
	]);
});
