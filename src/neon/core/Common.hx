package neon.core;

import neon.state.Effect;
import haxe.extern.EitherType;

typedef FC<T> = (props:T) -> VirtualNode;
typedef FunctionComponent = (props:Dynamic) -> VirtualNode;
typedef NodeCreator = EitherType<String, FunctionComponent>;

typedef VirtualNode = {
	var tag:NodeCreator;
	var props:Dynamic;
	var ?key:String;
	var ?ref:Dynamic;
	var ?effect:Effect;
}

function createElement(tag:NodeCreator, props:Dynamic, ?children:Dynamic):VirtualNode {
	Reflect.setField(props, "children", children != null ? Std.isOfType(children, Array) ? children : [children] : []);

	return {
		tag: tag,
		props: props,
	};
}
