package neon.core;

typedef VirtualNode = {
	var tag:String;
	var props:Dynamic;
	var children:Array<VirtualNode>;
}

function createElement(tag:String, props:Dynamic, children:Dynamic):VirtualNode {
	return {
		tag: tag,
		props: props,
		children: children != null ? Std.isOfType(children, Array) ? children : [children] : []
	};
}
