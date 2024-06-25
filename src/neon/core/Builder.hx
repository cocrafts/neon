package neon.core;

typedef Greeting = {
	var name:String;
	var message:String;
}

typedef VirtualNode = {
	var tag:String;
	var props:Dynamic;
	var children:Array<VirtualNode>;
}

function greetMessage(name:String):Greeting {
	return {
		name: name,
		message: 'Welcome $name, this is Neon Engine',
	}
}

function createElement(tag:String, props:Dynamic, children:Dynamic):VirtualNode {
	return {
		tag: tag,
		props: props,
		children: children != null ? Std.isOfType(children, Array) ? children : [children] : []
	};
}
