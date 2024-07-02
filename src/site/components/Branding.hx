package site.components;

import neon.core.Common.VirtualNode;
import neon.core.Style.StyleSheet;
import neon.core.Element;

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
		textAlign: "center",
	},
});
