package hxsge.examples.format.tson.data;

import hxsge.format.tson.Tson;
import hxsge.format.tson.parts.TsonValueType;
import hxsge.core.debug.Debug;
import hxsge.format.tson.parts.TsonBlock;

using hxsge.core.utils.StringTools;
using hxsge.format.tson.TsonTools;

class TsonNode {
	public var id:Float;
	public var nodeUrl:String = "";
	public var name:String;
	public var type:String = "";
	public var children:Array<TsonNode> = [];
	public var properties:Array<TsonProperty> = [];

	var _block:TsonBlock;
	var _isArrayElement:Bool = false;

	public function new(block:TsonBlock, parentName:String, root:Bool = false, index:Int = -1) {
		nodeUrl += parentName;
		_block = block;
		id = Math.random();
		_isArrayElement = index != -1;

		if(root) {
			name = "tson document";
		}
		else {
			name = _block.name.isEmpty() ? (_isArrayElement ? "[" + Std.string(index) + "]" : "default") : _block.name;
		}

		fillType();
		fillProperties();
		fillChildren();
	}

	public function getProperty(id:String):TsonProperty {
		for(p in properties) {
			if(p.id == id) {
				return p;
			}
		}

		return null;
	}

	public function hasProperty(id:String):Bool {
		for(p in properties) {
			if(p.id == id) {
				return true;
			}
		}

		return false;
	}

	public function setBlockType(value:String) {
		var prop:TsonProperty = getProperty(value);

		if(prop != null && prop.id != value) {
			switch(type) {
				case "null":
					_block.type = TsonValueType.TSON_BT_NULL;
					_block.data = null;
				case "bool":
					_block.type = TsonValueType.TSON_BT_NULL;
					_block.data = null;
				case "int":
				case "float":
				case "string":
				case "binary":
				case "array":
				case "object":
				default:
			}
		}
	}

	function fillType() {
		if(_block.isArray()) {
			type = "[array]";
		}
		else if(_block.isMap()) {
			type = "[object]";
		}
		else if(TsonValueType.isSimple(_block.type) || TsonValueType.isString(_block.type)){
			type = Std.string(_block.data);
		}
	}

	function fillProperties() {
		properties = [];
		properties.push(new TsonProperty("name", name, name, (name == "tson document" || _isArrayElement)));
		properties.push(new TsonProperty("type", TsonValueType.toString(_block.type), _block.type, (name == "tson document")));
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
