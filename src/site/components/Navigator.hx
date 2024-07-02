package site.components;

import site.components.Icons.GithubIcon;
import neon.core.Style.StyleSheet;
import neon.core.Element;

function Navigator() {
	return View({style: styles.container}, [
		View({style: styles.contentContainer}, [
			Anchor({style: styles.leftContainer, href: githubLink}, [GithubIcon({size: 26}), Span({style: styles.githubText}, "Github"),]),
			View({style: styles.midContainer}, [Span({style: styles.brandingText}, "neon"),]),
			View({style: styles.rightContainer}, "menu"),
		]),
	]);
}

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
		right: 18,
	},
	midContainer: {
		display: "flex",
		flex: 1,
		justifyContent: "center",
	},
	brandingText: {
		fontWeight: 600,
	},
});

var githubLink = "https://github.com/cocrafts/neon";
