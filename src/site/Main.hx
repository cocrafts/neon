package site;

import neon.core.Style.StyleSheet;
import js.Browser.document;
import neon.core.Common;
import neon.core.Element;
import neon.web.Client.NeonDom;
import site.components.Navigator;

class Main {
	static function main() {
		var el = View({id: "app", className: "container",}, [
			Branding({main: "neon", sub: "Build cross-platform Apps with native runtime!"}),
			Navigator(),
		]);

		NeonDom.render(el, document.body);
	}
}

function Branding(props:{main:String, sub:String}):VirtualNode {
	return View({
		style: styles.brandingContainer,
		click: function() {
			// js.Browser.window.open(githubLink);
		},
	}, [
		Span({style: styles.mainText}, props.main),
		Span({style: styles.subText}, props.sub),
	]);
}

var x = StyleSheet.create({
	calculatedContainer: {
		paddingHorizontal: 24,
		paddingLeft: 32,
	},
});

var styles = StyleSheet.create({
	brandingContainer: {
		display: "flex",
		flexDirection: "column",
		alignItems: "center",
		marginTop: 64,
	},
	mainText: {
		color: "#ffd9e2",
		fontFamily: "Silkscreen",
		fontSize: 140,
		textShadow: "0 0 0 transparent,0 0 10px #ff003c,0 0 20px rgba(255,0,60,.5),0 0 40px #ff003c,0 0 100px #ff003c,0 0 200px #ff003c,0 0 300px #ff003c,0 0 500px #ff003c,0 0 1000px #ff003c",
	},
	subText: {
		color: "#ffc0c8",
		fontSize: 16,
		fontFamily: "Silkscreen",
	},
});

var githubLink = "https://github.com/cocrafts/neon";
