package hxsge.format.tools.tson.data;

import hxsge.format.tson.data.TsonData;
import hxsge.core.IClonable;
import hxsge.core.IDisposable;
import hxsge.core.math.MathFloatTools;
import hxsge.core.memory.Memory;
import hxsge.format.tson.data.TsonValueType;
import hxsge.loaders.data.JsFileLoader;
import hxsge.loaders.base.ILoader;
import js.JQuery;
import js.Browser;
import js.html.InputElement;

using hxsge.core.utils.StringTools;
using hxsge.format.tson.data.TsonValueTypeTools;
using hxsge.core.math.MathFloatTools;
using hxsge.core.utils.ArrayTools;
using hxsge.loaders.utils.LoaderTools;

class TsonNode implements IDisposable implements IClonable<TsonNode> {
	static var ROOT_NAME:String = "tson document";

	public var id:Float;
	public var nodeUrl(get, never):String;
	public var name:String;
	public var info:String = "";
	public var parent:TsonNode = null;
	public var children:Array<TsonNode> = [];
	public var index(get, never):Int;
	public var type:TsonPropertyDataType;

	public var propertyGroups:Array<TsonPropertyGroup> = [];

	var _callback:Void->Void;
	var _name:String;
	var _data:Dynamic;

	public function new(data:TsonData = null, parent:TsonNode = null, callback:Void->Void = null) {
		id = Math.random();

		this._callback = callback;
		this.parent = parent;

		if(data != null) {
			this.type = TsonPropertyDataType.convertType(data.type);
			this._data = data.data;
			this._name = data.name;

			children = [];
			if(_data != null && (type == TsonPropertyDataType.ARRAY || type == TsonPropertyDataType.OBJECT)) {
				var arr:Array<TsonData> = cast data.data;
				for(i in arr) {
					insertChild(new TsonNode(i, this, _callback));
				}
			}
		}
		else {
			this.type = TsonPropertyDataType.OBJECT;
			this._data = {};
			this._name = "default";
			children = [];
		}

		fillName();
		fillInfo();
		fillProperties();
	}

	public function dispose() {
		_callback = null;
		clearChildren();
		clearProperties();
	}

	public function update() {
		fillName();
	}

	function fillName() {
		if(parent == null) {
			name = "tson document";
		}
		else {
			name = parent.type == TsonPropertyDataType.ARRAY ? "[" + Std.string(index) + "]" : (_name.isEmpty() ? "default" : _name);
		}
	}

	function fillInfo() {
		if(type == TsonPropertyDataType.ARRAY) {
			info = "[array]";
		}
		else if(type == TsonPropertyDataType.OBJECT) {
			info = "[object]";
		}
		else if(type == TsonPropertyDataType.BINARY) {
			info = "[binary - " + (_data == null ? "empty" : (_data.length == 0 ? "empty" : ((_data.length / 1024.0).format(2) + " kB"))) + "]";
		}
		else {
			info = _data;
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
			prop = new TsonProperty(TsonPropertyType.NODE_TYPE, "Type", type, (isRoot() || (parent.type == TsonPropertyDataType.ARRAY && parent.children.length > 1)));
			prop.setOptions(TsonPropertyDataType.getTypesMapForChoose());
			group.add(prop);
			prop = new TsonProperty(TsonPropertyType.NODE_NAME, "Name", _name, (isRoot() || parent.type == TsonPropertyDataType.ARRAY));
			group.add(prop);
			switch(type) {
				case TsonPropertyDataType.STRING:
					prop = new TsonProperty(TsonPropertyType.STRING_VALUE, "Value", _data, isRoot());
					group.add(prop);
				case TsonPropertyDataType.BOOL:
					prop = new TsonProperty(TsonPropertyType.BOOL_VALUE, "Value", _data, isRoot());
					prop.setOptions(["true"=>"true", "false"=>"false"]);
					group.add(prop);
				case TsonPropertyDataType.INT | TsonPropertyDataType.FLOAT:
					prop = new TsonProperty(TsonPropertyType.NUMBER_VALUE, "Value", _data, isRoot());
					group.add(prop);
				case TsonPropertyDataType.BINARY:
					prop = new TsonProperty(TsonPropertyType.BINARY_VALUE, "Value", _data, isRoot());
					group.add(prop);
				default:
			}
			group.changed.add(onGroupChanged);
			group.loadSpawned.add(onLoadSpawned);
			propertyGroups.push(group);

			group = new TsonPropertyGroup("Specific");
			group.changed.add(onGroupChanged);
			propertyGroups.push(group);
		}
	}

	function clearChildren() {
		Memory.disposeIterable(children);
		children = [];
	}

	public function clone():TsonNode {
		var node:TsonNode = new TsonNode(null);

		node._callback = _callback;
		node.parent = parent;
		node.type = type;
		node._data = _data;
		node._name = _name;
		children = [];
		if(_data != null && type == TsonPropertyDataType.ARRAY) {
			for(c in children) {
				insertChild(c.clone());
			}
		}
		node.fillName();
		node.fillInfo();
		node.fillProperties();

		return node;
	}

	public function isBinary():Bool {
		return type == TsonPropertyDataType.BINARY;
	}

	public function duplicateNode() {
		if(parent != null) {
			parent.insertChild(clone());
		}
	}

	public function isDuplicable():Bool {
		return !isRoot();
	}

	public function insertNode() {
		if(type == TsonPropertyDataType.ARRAY) {
			if(children.isEmpty()) {
				children = [];
				var node:TsonNode = new TsonNode(null, this, _callback);
				insertChild(node);
			}
			else {
				var node:TsonNode = children[children.length - 1].clone();
				insertChild(node);
			}
		}
		else {
			insertChild(new TsonNode(null, this, _callback));
		}
	}

	function updateChildren() {
		if(children.isNotEmpty()) {
			for(c in children) {
				c.update();
			}
		}
	}

	public function insertChild(node:TsonNode) {
		children.push(node);
		updateChildren();
	}

	public function isInsertable():Bool {
		return type == TsonPropertyDataType.ARRAY || type == TsonPropertyDataType.OBJECT;
	}

	public function removeNode() {
		if(parent != null) {
			parent.removeChild(this);
			updateChildren();
		}
	}

	public function cutChild(node:TsonNode) {
		for(i in 0...children.length) {
			if(children[i] == node) {
				children.splice(i, 1);
				updateChildren();

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
				updateChildren();

				return;
			}
		}
	}

	public function isRemovable():Bool {
		return !isRoot();
	}

	public function getData(parent:TsonData = null):TsonData {
		var res:TsonData = null;

		if(type == TsonPropertyDataType.ARRAY || type == TsonPropertyDataType.OBJECT) {
			var arr:Array<TsonData> = [];

			for(c in children) {
				arr.push(c.getData(res));
			}
			if(type == TsonPropertyDataType.ARRAY) {
				res = TsonData.create(arr, _name, parent);
			}
			else {
				res = TsonData.create({data: arr}, _name, parent);
			}
		}
		else {
			res = TsonData.create(_data, _name, parent);
		}

		return res;
	}

	public function isRoot():Bool {
		return parent == null;
	}

	function changeType(prop:TsonProperty) {
		type = prop.data;

		switch(type) {
			case TsonPropertyDataType.BOOL:
				_data = true;
			case TsonPropertyDataType.INT | TsonPropertyDataType.FLOAT:
				_data = 0;
			case TsonPropertyDataType.STRING:
				_data = "";
			case TsonPropertyDataType.ARRAY | TsonPropertyDataType.OBJECT:
				_data = [];
			default:
				_data = null;
		}

		clearChildren();
		fillName();
		fillInfo();
		fillProperties();
	}

	function onLoadSpawned(group:TsonPropertyGroup, prop:TsonProperty) {
		if(type == TsonPropertyDataType.BINARY) {
			loadFile();
		}
	}

	function loadFile() {
		var dialog:InputElement = Browser.document.createInputElement();
		dialog.type = 'file';
		dialog.multiple = false;

		var q = new JQuery(dialog);
		q.change(function(event:JqEvent) {
			var sjl:JsFileLoader = new JsFileLoader(dialog.files[0]);
			sjl.finished.addOnce(onFileLoaded);
			sjl.load();
		});
		q.click();
	}

	function onFileLoaded(loader:ILoader) {
		if(loader.isSuccess()) {
			_data = loader.content;

			fillInfo();
			fillProperties();

			if(_callback != null) {
				_callback();
			}
		}
	}

	function onGroupChanged(group:TsonPropertyGroup, prop:TsonProperty) {
		switch(prop.type) {
			case TsonPropertyType.NODE_TYPE:
				changeType(prop);
			case TsonPropertyType.NODE_NAME:
				_name = prop.info;
				_data = prop.data;
				fillName();
			case TsonPropertyType.STRING_VALUE:
				_data = prop.info;
				fillInfo();
			case TsonPropertyType.BOOL_VALUE:
				_data = prop.info == "true" ? true : false;
				fillInfo();
			case TsonPropertyType.NUMBER_VALUE:
				_data = Std.parseFloat(prop.info);
				fillInfo();
			case TsonPropertyType.BINARY_VALUE:
				_data = prop.data;
				fillInfo();
			default:
		}

		if(_callback != null) {
			_callback();
		}
	}

	function get_nodeUrl():String {
		return ((parent == null ? "" : parent.nodeUrl) + "/" + name);
	}

	function get_index():Int {
		if(parent != null && parent.children.length > 0) {
			for(i in 0...parent.children.length) {
				if(parent.children[i].id == id) {
					return i;
				}
			}
		}

		return 0;
	}
}
