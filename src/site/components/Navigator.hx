package site.components;

import neon.core.Common;
import site.components.Icons;
import neon.core.Style.StyleSheet;

typedef NavigatorProps = {};

var Navigator = createComponent(function(props:NavigatorProps) {
	return createElement("div", {style: styles.container}, [
		createElement("div", {style: styles.contentContainer}, [
			createElement("a", {style: styles.leftContainer, href: githubLink},
				[
					GithubIcon({size: 26}),
					createElement("span", {style: styles.githubText}, ["Github"]),
				]),
			createElement("div", {style: styles.midContainer}, [createElement("span", {}, ["engine"]),]),
			createElement("div", {style: styles.rightContainer}, [BurgerIcon({size: 16, color: "#FFFFFF"}),]),
		]),
	]);
});

var styles = StyleSheet.create({
	container: {
		position: "fixed",
		top: 0,
		left: 0,
		right: 0,
	},
	contentContainer: {
		display: "flex",
		position: "relative",
		maxWidth: 1280,
		width: "100%",
		margin: "auto",
		height: 54,
		alignItems: "center",
		fontFamily: "Silkscreen",
	},
	leftContainer: {
		display: "flex",
		flexDirection: "row",
		alignItems: "center",
		position: "absolute",
		color: "white",
		textDecoration: "none",
		left: 18,
	},
	githubText: {
		marginLeft: 8,
	},
	rightContainer: {
		position: "absolute",
		cursor: "pointer",
		right: 18,
	},
	midContainer: {
		display: "flex",
		flex: 1,
		justifyContent: "center",
	},
});

var githubLink = "https://github.com/cocrafts/neon";
