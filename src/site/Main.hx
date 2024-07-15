package site;

import neon.core.Common.createElement;
import neon.state.Signal;
import js.Browser.document;
import neon.core.Element;
import neon.web.Client.NeonDom;
import site.components.Navigator;
import site.components.Branding;

var h = createElement;
var count = new Signal(0);

class Main {
	static function main() {
		var el = h("div", {id: "app", className: "container",}, [
			h(Branding, {main: "neon", sub: "Build cross-platform App in native runtime!", count: count}),
			h(Navigator, {}),
		]);

		NeonDom.render(el, document.body);
	}
}

var githubLink = "https://github.com/cocrafts/neon";
