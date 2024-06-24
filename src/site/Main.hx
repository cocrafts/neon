package site;

import js.Browser.document;
import neon.core.Builder;
import neon.core.Element;
import neon.macro.Render;
import neon.browser.Render;

class Main {
	static function main() {
		var el = View({ id: "app", className: "container" }, [
			H1({}, "Welcome to Neon Engine"),
			MyComponent({ 
				name: "Cloud Le", 
				onPress: function(args:Dynamic) {
					duplicate(trace(args));
				},
			}),
			P({}, "This is a simple virtual DOM powered by Neon")
		]);

		render(el, document.body);
	}

	public static function getMessage(name: String): Greeting {	
		return greetMessage(name);
	}
}

function MyComponent(props:{ name: String, onPress: Dynamic -> Void }) {
	return View({ click: props.onPress }, [
		P({}, 'Hello ${props.name}'),
		P({}, "Greeting...")
	]);
}
