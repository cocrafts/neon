package site.components;

import neon.core.Common;
import neon.core.State;
import site.components.Branding;
import site.components.Navigator;

var App = createComponent(function(props:{count:Signal<Int>}) {
	var count = props?.count;
	if (count == null) {
		count = createSignal(0);
	}

	return createElement("div", {}, [
		Branding({main: "neon", sub: "build cross-platform app in native runtime!", count: count}),
		Navigator({}),
	]);
});
