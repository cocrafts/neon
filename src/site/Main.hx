package site;

import neon.core.Style.StyleSheet;
import neon.core.Common.createElement;
import neon.core.State;
import neon.platform.Renderer;
import js.Browser.document;
import haxe.Timer;

var count = new Signal(0);

class Main {
	static function setInterval(callback:Void->Void, interval:Int):Timer {
		var timer = new Timer(interval);
		timer.run = callback;
		return timer;
	}

	static function main() {
		// var el = View({id: "app", className: "container",}, [
		// 	Branding({main: "neon", sub: "Build cross-platform App in native runtime!", count: count}),
		// 	Navigator({count: count}),
		// ]);
		// js.Browser.console.log(App({name: "Cloud", count: count}), App, '<--');

		setInterval(function() {
			count.set(count.get() + 1);
		}, 100);

		var val = count.get();
		var headingEl = createElement("h1", {}, ["I'm a heading!!"]);
		var el = createElement("div", {style: styles.container}, [
			"hello world!",
			headingEl,
			createElement("span", {}, ["I'm a span, "]),
			createElement("a", {}, ["and here is anchor!"]),
			createElement("span", {}, [" counter: ", count.get()]),
			" ",
			10 > 8,
			" ",
			count.get() > 100 ? "BIG" : "SMALL",
			" ",
			{
				message: "object is supported!"
			},
			" ",
			val,
		]);
		// var el = createElement("div", {}, ["hello", " world?", heading, span]);
		// var el = createElement("div", {}, [App({name: "Cloud", count: count})]);
		// var el = createElement(App, {});

		universalRender(el, document.body);
	}
}

var styles = StyleSheet.create({
	container: {
		color: "#dedede",
		paddingHorizontal: 12,
	},
});

// var App = createComponent(function(props:{name:String, count:Signal<Int>}):Dynamic {
// 	var obj = {message: "object also accepted!!"};
// 	// return createElement("h1", {});
// 	return createElement("h1", {}, ["hello ", count.get(), " ", false, " ", obj]);
// });

var githubLink = "https://github.com/cocrafts/neon";
