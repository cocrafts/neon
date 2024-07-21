package site.components;

import neon.core.Common;
import neon.core.State;
import site.components.Branding;
import site.components.Navigator;

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
