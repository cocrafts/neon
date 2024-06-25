package neon.parser;

#if jsprop @:build(JsProp.marked()) #end
class HtmlNodeElement extends HtmlNode {
	public var name:String;
	public var attributes:Array<HtmlAttribute>;
	public var nodes:Array<HtmlNode>;
	public var children:Array<HtmlNodeElement>;

	public function getPrevSiblingElement():HtmlNodeElement {
		if (parent == null)
			return null;
		var n = parent.children.indexOf(this);
		if (n < 0)
			return null;
		if (n > 0)
			return parent.children[n - 1];
		return null;
	}

	public function getNextSiblingElement():HtmlNodeElement {
		if (parent == null)
			return null;
		var n = parent.children.indexOf(this);
		if (n < 0)
			return null;
		if (n + 1 < parent.children.length)
			return parent.children[n + 1];
		return null;
	}

	public function new(name:String, attributes:Array<HtmlAttribute>) {
		this.name = name;
		this.attributes = attributes;
		this.nodes = [];
		this.children = [];
	}

	public function addChild(node:HtmlNode, beforeNode:HtmlNode = null):Void {
		if (beforeNode == null) {
			nodes.push(node);
			node.parent = this;
			if (Std.isOfType(node, HtmlNodeElement))
				children.push((cast node : HtmlNodeElement));
		} else {
			var n = nodes.indexOf(beforeNode);
			if (n < 0)
				throw new haxe.Exception("`beforeNode` is not found.");
			nodes.insert(n, node);
			node.parent = this;
			children = cast nodes.filter(x -> Std.isOfType(x, HtmlNodeElement));
		}
	}

	public function addChildren(nodesToAdd:Array<HtmlNode>, beforeNode:HtmlNode = null):Void {
		var n = beforeNode != null ? nodes.indexOf(beforeNode) : 0;
		if (n < 0)
			throw new haxe.Exception("`beforeNode` is not found.");
		nodes = (n > 0 ? nodes.slice(0, n) : []).concat(nodesToAdd).concat(nodes.slice(n));
		for (node in nodesToAdd)
			node.parent = this;
		children = cast nodes.filter(x -> Std.isOfType(x, HtmlNodeElement));
	}

	public override function toString():String {
		var sAttrs = new StringBuf();
		for (a in attributes) {
			sAttrs.add(" ");
			sAttrs.add(a.toString());
		}

		var innerBuf = new StringBuf();
		for (node in nodes) {
			innerBuf.add(node.toString());
		}
		var inner = innerBuf.toString();

		if (inner == "" && isSelfClosing()) {
			return "<" + name + sAttrs.toString() + " />";
		}

		return name != null && name != "" ? "<" + name + sAttrs.toString() + ">" + inner + "</" + name + ">" : inner;
	}

	public function getAttribute(name:String):String {
		var nameLC = name.toLowerCase();

		for (a in attributes) {
			if (a.name.toLowerCase() == nameLC)
				return a.value;
		}

		return null;
	}

	public function setAttribute(name:String, value:String) {
		var nameLC = name.toLowerCase();

		for (a in attributes) {
			if (a.name.toLowerCase() == nameLC) {
				a.value = value;
				return;
			}
		}

		attributes.push(new HtmlAttribute(name, value, '"'));
	}

	public function removeAttribute(name:String) {
		var nameLC = name.toLowerCase();

		for (i in 0...attributes.length) {
			var a = attributes[i];
			if (a.name.toLowerCase() == nameLC) {
				attributes.splice(i, 1);
				return;
			}
		}
	}

	public function hasAttribute(name:String):Bool {
		var nameLC = name.toLowerCase();

		for (a in attributes) {
			if (a.name.toLowerCase() == nameLC)
				return true;
		}

		return false;
	}

	@:property
	public var innerHTML(get, set):String;

	function get_innerHTML():String {
		var r = new StringBuf();
		for (node in nodes) {
			r.add(node.toString());
		}
		return r.toString();
	}

	function set_innerHTML(value:String):String {
		var newNodes = HtmlParser.run(value);
		nodes = [];
		children = [];
		for (node in newNodes)
			addChild(node);
		return value;
	}

	@:property
	public var innerText(get, set):String;

	function get_innerText():String {
		return toText();
	}

	function set_innerText(text:String):String {
		fastSetInnerHTML(HtmlTools.escape(text));
		return text;
	}

	/**
	 * Replace all inner nodes to the text node w/o escaping and parsing.
	 */
	public function fastSetInnerHTML(html:String) {
		nodes = [];
		children = [];
		addChild(new HtmlNodeText(html));
	}

	override function toText():String {
		var r = new StringBuf();
		for (node in nodes) {
			r.add(node.toText());
		}
		return r.toString();
	}

	public function find(selector:String):Array<HtmlNodeElement> {
		var parsedSelectors:Array<Array<CssSelector>> = CssSelector.parse(selector);

		var resNodes = new Array<HtmlNodeElement>();
		for (s in parsedSelectors) {
			for (node in children) {
				var nodesToAdd = node.findInner(s);
				for (nodeToAdd in nodesToAdd) {
					if (resNodes.indexOf(nodeToAdd) < 0) {
						resNodes.push(nodeToAdd);
					}
				}
			}
		}
		return resNodes;
	}

	private function findInner(selectors:Array<CssSelector>):Array<HtmlNodeElement> {
		if (selectors.length == 0)
			return [];

		var nodes = [];
		if (selectors[0].type == " ") {
			for (child in children) {
				nodes = nodes.concat(child.findInner(selectors));
			}
		}
		if (isSelectorTrue(selectors[0])) {
			if (selectors.length > 1) {
				var subSelectors = selectors.slice(1);
				for (child in children) {
					nodes = nodes.concat(child.findInner(subSelectors));
				}
			} else if (selectors.length == 1) {
				if (parent != null) {
					nodes.push(this);
				}
			}
		}
		return nodes;
	}

	private function isSelectorTrue(selector:CssSelector) {
		if (selector.tagNameLC != null && name.toLowerCase() != selector.tagNameLC)
			return false;

		if (selector.id != null && getAttribute("id") != selector.id)
			return false;

		for (clas in selector.classes) {
			var reg = new EReg("(?:^|\\s)" + clas + "(?:$|\\s)", "");
			var classAttr = getAttribute("class");
			if (classAttr == null || !reg.match(classAttr))
				return false;
		}

		if (selector.index != null && (parent == null || parent.children.indexOf(this) + 1 != selector.index)) {
			return false;
		}

		return true;
	}

	public function replaceChild(node:HtmlNode, newNode:haxe.extern.EitherType<HtmlNode, Array<HtmlNode>>) {
		if (Std.isOfType(newNode, Array))
			replaceChildByMany(node, newNode);
		else
			replaceChildByOne(node, newNode);
	}

	function replaceChildByOne(node:HtmlNode, newNode:HtmlNode) {
		var n = nodes.indexOf(node);
		if (n < 0)
			throw new haxe.Exception("Node to replace is not found.");
		nodes[n].parent = null;
		nodes[n] = newNode;
		newNode.parent = this;
		children = cast nodes.filter(x -> Std.isOfType(x, HtmlNodeElement));
	}

	function replaceChildByMany(node:HtmlNode, newNodes:Array<HtmlNode>) {
		var n = nodes.indexOf(node);
		if (n < 0)
			throw new haxe.Exception("Node to replace is not found.");
		nodes[n].parent = null;
		var lastNodes = nodes.slice(n + 1, nodes.length);
		nodes = (n > 0 ? nodes.slice(0, n) : []).concat(newNodes).concat(lastNodes);
		for (n in newNodes)
			n.parent = this;
		children = cast nodes.filter(x -> Std.isOfType(x, HtmlNodeElement));
	}

	public function removeChild(node:HtmlNode) {
		var n = nodes.indexOf(node);
		if (n < 0)
			throw new haxe.Exception("Node to remove is not found.");
		nodes.splice(n, 1);
		node.parent = null;

		if (Std.isOfType(node, HtmlNodeElement)) {
			n = children.indexOf(cast node);
			if (n >= 0) {
				children.splice(n, 1);
			}
		}
	}

	public function getAttributesAssoc():Map<String, String> {
		var attrs = new Map();
		for (attr in attributes) {
			attrs.set(attr.name, attr.value);
		}
		return attrs;
	}

	public function getAttributesObject():Dynamic<String> {
		var attrs = {};
		for (attr in attributes) {
			Reflect.setField(attrs, attr.name, attr.value);
		}
		return attrs;
	}

	function isSelfClosing():Bool {
		return Reflect.hasField(HtmlParser.SELF_CLOSING_TAGS_HTML, name) || name.indexOf(":") >= 0;
	}

	override function hxSerialize(s:{function serialize(d:Dynamic):Void;}) {
		s.serialize(name);
		s.serialize(attributes);
		s.serialize(nodes);
	}

	override function hxUnserialize(s:{function unserialize():Dynamic;}) {
		name = s.unserialize();
		attributes = s.unserialize();

		nodes = [];
		children = [];
		var ns:Array<HtmlNode> = s.unserialize();
		for (n in ns) {
			addChild(n);
		}
	}
}
