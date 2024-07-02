package site;

import js.Browser.document;
import neon.core.Element;
import neon.web.Client.NeonDom;
import site.components.Navigator;
import site.components.Branding;

class Main {
	static function main() {
		var el = View({id: "app", className: "container",}, [
			Branding({main: "neon", sub: "Build cross-platform Apps with native runtime!"}),
			Navigator(),
		]);

		NeonDom.render(el, document.body);
	}
}

var githubLink = "https://github.com/cocrafts/neon";
