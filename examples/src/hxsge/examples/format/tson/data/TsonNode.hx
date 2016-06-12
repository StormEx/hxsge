package hxsge.examples.format.tson.data;

import hxsge.core.IClonable;
import hxsge.core.IDisposable;
import hxsge.core.math.MathFloatTools;
import hxsge.core.memory.Memory;
import hxsge.format.tson.Tson;
import hxsge.format.tson.parts.TsonValueType;
import hxsge.core.debug.Debug;
import hxsge.format.tson.parts.TsonBlock;

using hxsge.core.utils.StringTools;
using hxsge.format.tson.TsonTools;
using hxsge.format.tson.parts.TsonValueTypeTools;
using hxsge.core.math.MathFloatTools;
using hxsge.core.utils.ArrayTools;

class TsonNode implements IDisposable implements IClonable<TsonNode> {
	static var ROOT_NAME:String = "tson document";

	public var id:Float;
	public var nodeUrl:String = "";
	public var name:String;
	public var type:String = "";
	public var children:Array<TsonNode> = [];
	public var propertyGroups:Array<TsonPropertyGroup> = [];
	public var root:TsonNode = null;

	var _callback:Void->Void;

	var _parentName:String;
	var _block:TsonBlock;
	var _isArrayElement:Bool = false;
	var _isRoot:Bool = false;
	var _arrayIndex:Int = -1;

	public function new(block:TsonBlock, callback:Void->Void, parentName:String, root:TsonNode = null, index:Int = -1) {
		_parentName = parentName;
		nodeUrl += parentName;
		_block = block;
		id = Math.random();
		_isArrayElement = (index != -1);
		_callback = callback;
		_isRoot = (root == null);
		this.root = root;
		_arrayIndex = index;

		fillName();
		fillType();
		fillProperties();
		fillChildren();
	}

	public function dispose() {
		_callback = null;
		_block = null;
		clearChildren();
		clearProperties();
	}

	public function clone():TsonNode {
		return new TsonNode(_block.clone(), _callback, _parentName, root, _isArrayElement ? root.children.length : -1);
	}

	public function loadFile() {
		Debug.trace("load file...");
	}

	public function isBinary():Bool {
		return _block.type.isBinary();
	}

	public function duplicateNode() {
		if(root != null) {
			root.insertChild(clone());
		}
	}

	public function isDuplicable():Bool {
		return !isRoot();
	}

	public function insertNode() {
		if(_block.isArray()) {
			if(children.isEmpty()) {
				children = [];
				insertChild(new TsonNode(new TsonBlock(TsonValueType.TSON_BT_MAP_UINT8, {}), _callback, name, this, 0));
			}
			else {
				var node:TsonNode = children[children.length - 1].clone();
				node._arrayIndex = children.length;
				node.fillName();
				insertChild(node);
			}
		}
		else {
			insertChild(new TsonNode(new TsonBlock(TsonValueType.TSON_BT_MAP_UINT8, {}, -1, "default"), _callback, name, this, -1));
		}
	}

	public function insertChild(node:TsonNode) {
		children.push(node);
	}

	public function isInsertable():Bool {
		return _block.isIterable();
	}

	public function removeNode() {
		if(root != null) {
			root.removeChild(this);
		}
	}

	public function cutChild(node:TsonNode) {
		for(i in 0...children.length) {
			if(children[i] == node) {
				children.splice(i, 1);

				return;
			}
		}
	}

	public function removeChild(node:TsonNode) {
		for(i in 0...children.length) {
			if(children[i] == node) {
				var node:TsonNode = children[i];
				children.splice(i, 1);
				Memory.dispose(node);

				return;
			}
		}
	}

	public function isRemovable():Bool {
		return !isRoot();
	}

	function fillName() {
		if(_isRoot) {
			name = "tson document";
		}
		else {
			name = _block.name.isEmpty() ? (_isArrayElement ? "[" + Std.string(_arrayIndex) + "]" : "default") : _block.name;
		}
	}

	function fillType() {
		if(_block.isArray()) {
			type = "[array]";
		}
		else if(_block.isMap()) {
			type = "[object]";
		}
		else if(_block.type.isSimple() || _block.type.isString() || _block.type.isValue()) {
			type = Std.string(_block.data);
		}
		else if(_block.type.isBinary()) {
			type = "[binary - " + (_block.data == null ? "empty" : (_block.data.length == 0 ? "empty" : ((_block.data.length / 1024.0).format(2) + " kB"))) + "]";
		}
	}

	function clearProperties() {
		for(g in propertyGroups) {
			Memory.dispose(g);
		}
		propertyGroups = [];
	}

	function fillProperties() {
		var group:TsonPropertyGroup;
		var prop:TsonProperty;
		var dtype:TsonPropertyDataType = TsonPropertyDataType.NULL;

		clearProperties();

		if(!isRoot()) {
			group = new TsonPropertyGroup("General");
			prop = new TsonProperty(TsonPropertyType.NODE_TYPE, "Type", _block.type, (isRoot() || (_isArrayElement && root.children.length > 1)));
			prop.setOptions(TsonPropertyDataType.getTypesMapForChoose());
			group.add(prop);
			prop = new TsonProperty(TsonPropertyType.NODE_NAME, "Name", _block.name, (isRoot() || _isArrayElement));
			group.add(prop);
			switch(TsonPropertyDataType.convertType(_block.type)) {
				case TsonPropertyDataType.STRING:
					prop = new TsonProperty(TsonPropertyType.STRING_VALUE, "Value", _block.data, isRoot());
					group.add(prop);
				case TsonPropertyDataType.BOOL:
					prop = new TsonProperty(TsonPropertyType.BOOL_VALUE, "Value", _block.data, isRoot());
					prop.setOptions(["true"=>"true", "false"=>"false"]);
					group.add(prop);
				case TsonPropertyDataType.INT | TsonPropertyDataType.FLOAT:
					prop = new TsonProperty(TsonPropertyType.NUMBER_VALUE, "Value", _block.data, isRoot());
					group.add(prop);
				case TsonPropertyDataType.BINARY:
					prop = new TsonProperty(TsonPropertyType.BINARY_VALUE, "Value", _block.data, isRoot());
					group.add(prop);
				default:
			}
			group.changed.add(onGroupChanged);
			propertyGroups.push(group);

			group = new TsonPropertyGroup("Specific");
			group.changed.add(onGroupChanged);
			propertyGroups.push(group);
		}
	}

	function fillChildren() {
		var index:Int = 0;
		children = [];
		if(_block != null && _block.isIterable()) {
			for(i in _block.array) {
				insertChild(new TsonNode(i, _callback, nodeUrl + "/" + name, this, _block.isArray() ? index : -1));
				index++;
			}
		}
	}

	function clearChildren() {
		Memory.disposeIterable(children);
		children = [];
	}

	public function getBlock():TsonBlock {
		var res:TsonBlock = null;

		if(_block.isIterable()) {
			var arr:Array<TsonBlock> = [];
			for(c in children) {
				arr.push(c.getBlock());
			}
			if(_block.isArray()) {
				res = new TsonBlock(TsonValueType.TSON_BT_ARRAY_UINT32, arr, -1, _block.name);
			}
			else {
				res = new TsonBlock(TsonValueType.TSON_BT_MAP_UINT32, arr, -1, _block.name);
			}
		}
		else {
			if(_block.type.isValue()) {
				res = new TsonBlock(_block.type, _block.data, -1, _block.name);
			}
			else if(_block.type.isSimple()) {
				switch(_block.type) {
					case TsonValueType.TSON_BT_FLOAT32 |
							TsonValueType.TSON_BT_FLOAT64:
						res = new TsonBlock(TsonValueType.TSON_BT_FLOAT32, _block.data, -1, _block.name);
					default:
						res = new TsonBlock(TsonValueType.TSON_BT_INT32, _block.data, -1, _block.name);
				}
			}
			else if(_block.type.isString()) {
				res = new TsonBlock(TsonValueType.TSON_BT_STRING_UINT32, _block.data, -1, _block.name);
			}
			else {
				res = new TsonBlock(TsonValueType.TSON_BT_BINARY_UINT32, _block.data, -1, _block.name);
			}
		}

		return res;
	}

	public function isRoot():Bool {
		return _isRoot;
	}

	function changeType(prop:TsonProperty) {
		_block.type = prop.data;

		switch(_block.type) {
			case TsonValueType.TSON_BT_NULL:
				_block.data = null;
			case TsonValueType.TSON_BT_TRUE:
				_block.data = true;
			case TsonValueType.TSON_BT_INT8:
				_block.data = 0;
			case TsonValueType.TSON_BT_FLOAT32:
				_block.data = 0;
			case TsonValueType.TSON_BT_STRING_UINT8:
				_block.data = "";
			case TsonValueType.TSON_BT_BINARY_UINT8:
				_block.data = null;
			case TsonValueType.TSON_BT_ARRAY_UINT8:
				_block.data = [];
				clearChildren();
			case TsonValueType.TSON_BT_MAP_UINT8:
				_block.data = [];
				clearChildren();
			default:
				_block.data = null;
		}
		fillName();
		fillType();
		fillProperties();

		if(_callback != null) {
			_callback();
		}
	}

	function onGroupChanged(group:TsonPropertyGroup, prop:TsonProperty) {
		switch(prop.type) {
			case TsonPropertyType.NODE_TYPE:
				changeType(prop);
			case TsonPropertyType.NODE_NAME:
				_block.name = prop.info;
				name = _block.name;
				prop.data = _block.name;
				if(_callback != null) {
					_callback();
				}
			case TsonPropertyType.STRING_VALUE:
				_block.data = prop.info;
				type = prop.info;
				prop.data = prop.info;
				if(_callback != null) {
					_callback();
				}
			case TsonPropertyType.BOOL_VALUE:
				_block.data = prop.info == "true" ? true : false;
				type = prop.info;
				prop.data = prop.info;
				fillType();
				if(_callback != null) {
					_callback();
				}
			case TsonPropertyType.NUMBER_VALUE:
				_block.data = Std.parseFloat(prop.info);
				type = prop.info;
				prop.data = prop.info;
				fillType();
				if(_callback != null) {
					_callback();
				}
			case TsonPropertyType.BINARY_VALUE:
				_block.data = prop.data;
				type = prop.info;
				fillType();
				if(_callback != null) {
					_callback();
				}
			default:
		}
	}
}
