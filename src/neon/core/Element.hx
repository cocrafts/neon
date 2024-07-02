package neon.core;

import neon.core.Common.VirtualNode;
import neon.core.Common.createElement;

function View(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("div", props, children);
}

function Anchor(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("a", props, children);
}

function Image(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("image", props, children);
}

function P(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("p", props, children);
}

function Span(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("span", props, children);
}

function H1(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("h1", props, children);
}

function H2(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("h2", props, children);
}

function H3(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("h3", props, children);
}

function H4(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("h4", props, children);
}

function H5(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("h5", props, children);
}

function H6(props:Dynamic, ?children:Dynamic):VirtualNode {
	return createElement("h6", props, children);
}
