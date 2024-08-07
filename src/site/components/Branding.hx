package site.components;

import neon.core.Common;
import neon.core.State;
import neon.core.Style;

typedef BrandingProps = {
	var main:String;
	var sub:String;
	var count:Signal<Int>;
};

var Branding = createComponent(function(props:BrandingProps):Dynamic {
	var doubleCount = function() {
		return props.count.get() * 2;
	}

	return createElement("div", {
		style: styles.brandingContainer,
		className: "extra",
		click: function() props.count.set(0),
	}, [
		createElement("span", {style: styles.mainText}, [props.main, createElement("span", {}, ":"), doubleCount()]),
		createElement("span", {style: styles.subText}, props.sub),
	]);
});

var styles = createStyle({
	brandingContainer: {
		cursor: "pointer",
		display: "flex",
		flexDirection: "column",
		alignItems: "center",
		marginTop: 64,
		userSelect: "none",
	},
	mainText: {
		color: "#ffd9e2",
		fontFamily: "Silkscreen",
		fontSize: 140,
		textShadow: "0 0 0 transparent,0 0 10px #ff003c,0 0 20px rgba(255,0,60,.5),0 0 40px #ff003c,0 0 100px #ff003c,0 0 200px #ff003c,0 0 300px #ff003c,0 0 500px #ff003c,0 0 1000px #ff003c",
		"@media (max-width: 600px)": {
			fontSize: 80,
			textShadow: "0 0 0 transparent,0 0 10px #759eff,0 0 20px rgba(142,185,255,.5),0 0 40px #759eff,0 0 100px #759eff,0 0 200px #759eff,0 0 300px #759eff,0 0 500px #759eff,0 0 1000px #759eff"
		},
	},
	subText: {
		color: "#ffc0c8",
		fontSize: 16,
		fontFamily: "Silkscreen",
		textAlign: "center",
	},
});
