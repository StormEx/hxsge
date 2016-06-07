package hxsge.examples.format.tson.data;

import hxsge.format.tson.parts.TsonValueType;
import hxsge.core.debug.Debug;
import hxsge.format.tson.parts.TsonBlock;

using hxsge.core.utils.StringTools;
using hxsge.format.tson.TsonTools;

class TsonNode {
	public var nodeUrl:String = "";
	public var name:String;
	public var type:String = "";
	public var children:Array<TsonNode> = [];

	var _block:TsonBlock;

	public function new(block:TsonBlock, parentName:String, root:Bool = false, index:Int = -1) {
		if(root) {
			name = "tson document";
		}
		else {
			name = block.name.isEmpty() ? (index == -1 ? "default" : "[" + Std.string(index) + "]") : block.name;
		}

		_block = block;
		nodeUrl += parentName;

		fillType();
		fillChildren();
	}

	function fillType() {
		if(_block.isArray()) {
			type = "[array]";
		}
		else if(_block.isMap()) {
			type = "[object]";
		}
		else if(TsonValueType.isSimple(_block.type) || TsonValueType.isString(_block.type)){
			type = ": " + Std.string(_block.data);
		}
	}

	function fillChildren() {
		var index:Int = 0;
		children = [];
		if(_block != null && _block.isIterable()) {
			for(i in _block.array) {
				children.push(new TsonNode(i, nodeUrl + "/" + name, false, index));
				index++;
			}
		}
	}
}
