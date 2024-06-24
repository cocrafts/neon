package neon.core;

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
		children: children != null ? Std.is(children, Array) ? children : [children] : []
	};
}

typedef Greeting = {
	name:String,
	message:String
}

typedef VirtualNode = {
	tag:String,
	props:Dynamic,
	children:Array<VirtualNode>
}
