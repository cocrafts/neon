package game.components;

import neon.core.Common;
import neon.core.State;

var Game = createComponent(function(props:{count:Signal<Int>}) {
	var count = props?.count;
	if (count == null) {
		count = createSignal(1988);
	}

	return createElement("Object", {x: 600, y: 200}, Hand({count: count}));
});

var Hand = createComponent(function(props:{count:Signal<Int>}) {
	var shadow = {
		dx: 0.5,
		dy: 0.5,
		color: 0xFF0000,
		alpha: 0.8
	};

	return createElement("Text", {
		scale: 12,
		textColor: 0xFFFFFF,
		textAlign: h2d.Text.Align.Center,
		dropShadow: shadow,
		text: props.count.get(),
	});
});
