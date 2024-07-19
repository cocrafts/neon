package site;

import haxe.Timer;
import js.Browser.document;
import haxe.Constraints.Function;
import neon.core.Style.StyleSheet;
import neon.core.Common;
// import neon.core.Element;
import neon.core.State;
import neon.platform.Renderer;

// import site.components.Branding;
// import site.components.Navigator;

var count = new Signal(0);
var step = new Signal(0);

class Main {
	static function setInterval(callback:Void->Void, interval:Int):Timer {
		var timer = new Timer(interval);
		timer.run = callback;
		return timer;
	}

	static function main() {
		setInterval(function() {
			count.set(count.get() + 1);
			step.set(step.get() + 5);
		}, 1000);

		universalRender(App({name: "world", count: count, step: step}), document.body);
	}
}

typedef Props = {
	var name:String;
	var count:Signal<Int>;
	var step:Signal<Int>;
};

function App(props:Props):Function {
	var obj = {message: "object also accepted!!"};

	return createElement("h1", {}, [
		"hello ",
		props.count.get(),
		" ",
		false,
		" ",
		obj,
		Header({name: props.name, count: props.step}),
	]);
};

function Header(props:{name:String, count:Signal<Int>}):Function {
	var elementProps = {style: styles.heading};

	return createElement("h2", elementProps, ["gretting ", props.name, " ", count.get(), "! "]);
}

var styles = StyleSheet.create({
	container: {
		color: "#DEDEDE",
		paddingHorizontal: 12,
	},
	heading: {
		color: "#32c55a",
	},
	other: {
		margin: 0,
	},
});

var githubLink = "https://github.com/cocrafts/neon";
