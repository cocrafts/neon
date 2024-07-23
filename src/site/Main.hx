package site;

import js.Browser.document;
import neon.platform.browser.Renderer;
import site.components.App;

typedef AppProps = {
	var name:String;
};

class Main {
	public static function main() {
		render(document.body, App);
	}
}
