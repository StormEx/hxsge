package hxsge.examples.format.tson.data;

import hxsge.format.tson.parts.TsonValueType;
import hxsge.format.tson.parts.TsonValueType;
import hxsge.core.debug.Debug;
import hxsge.format.tson.parts.TsonBlock;

class TsonManagerData {
	public var tson(default, set):TsonBlock;
	public var treeData:Array<TsonNode> = [];
	public var properties(get, never):Array<TsonProperty>;
	public var types:Array<String> = [];

	public var isLoaded(get, never):Bool;

	var _selectedNode:TsonNode;
	var _propObj:Dynamic;
	var _propMeta:Dynamic;

	public function new() {
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_NULL));
		types.push("null");
		types.push("bool");
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_FALSE));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_TRUE));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_ESTRING));
		types.push("int");
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_UINT8));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_UINT16));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_UINT32));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_UINT64));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_INT8));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_INT16));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_INT32));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_INT64));
		types.push("float");
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_FLOAT32));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_FLOAT64));
		types.push("string");
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_STRING_UINT8));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_STRING_UINT16));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_STRING_UINT32));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_STRING_UINT64));
		types.push("binary");
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_BINARY_UINT8));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_BINARY_UINT16));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_BINARY_UINT32));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_BINARY_UINT64));
		types.push("array");
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_ARRAY_UINT8));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_ARRAY_UINT16));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_ARRAY_UINT32));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_ARRAY_UINT64));
		types.push("object");
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_MAP_UINT8));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_MAP_UINT16));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_MAP_UINT32));
//		types.push(TsonValueType.toString(TsonValueType.TSON_BT_MAP_UINT64));
	}

	public function removeNode(id:String) {
		Debug.trace("remove node: " + id);
	}

	public function insertNode(id:String) {
		Debug.trace("insert node into: " + id);
	}

	public function selectNode(node:TsonNode) {
		_selectedNode = node;
		if(_selectedNode != null) {
			_propObj = {
				font: 'Consolas',
				fontSize: 14,
				fontColor: '#a3ac03',
				jQuery: true,
				modernizr: false,
				framework: 'angular',
				iHaveNoMeta: 'Never mind...',
				iAmReadOnly: 'I am a label which is not editable'
			};

			_propMeta = {
				// Since string is the default no nees to specify type
				font: { group: 'Editor', name: 'Font', description: 'The font editor to use'},
				// The "options" would be passed to jQueryUI as its options
				fontSize: { group: 'Editor', name: 'Font size', type: 'number', options: { min: 0, max: 20, step: 2 }},
				// The "options" would be passed to Spectrum as its options
				fontColor: { group: 'Editor', name: 'Font color', type: 'color', options: { preferredFormat: 'hex' }},
				// since typeof jQuery is boolean no need to specify type, also since "jQuery" is also the display text no need to specify name
				jQuery: { group: 'Plugins', description: 'Whether or not to include jQuery on the page' },
				// We can specify type boolean if we want...
				modernizr: {group: 'Plugins', type: 'boolean', description: 'Whether or not to include modernizr on the page'},
				iAmReadOnly: { name: 'I am read only', type: 'label', description: 'Label types use a label tag for read-only properties', showHelp: false }

			};
			untyped __js__("$('#propGrid').jqPropertyGrid(this._propObj, this._propMeta)");
			Debug.trace("selected node: " + _selectedNode.id);
		}
		else {
			Debug.trace("node unselected");
		}
	}

	public function setType(type:String) {
		if(_selectedNode != null) {
			_selectedNode.setBlockType(type);
		}
	}

	public function hasProperty(id:String):Bool {
		if(_selectedNode != null) {
			return _selectedNode.hasProperty(id);
		}

		return false;
	}

	function rebuildData() {
		_selectedNode = null;
		treeData = [new TsonNode(tson, "root", true)];
	}

	function set_tson(value:TsonBlock):TsonBlock {
		if(tson != value) {
			tson = value;

			rebuildData();
		}

		return tson;
	}

	function get_isLoaded():Bool {
		return tson != null;
	}

	function get_properties():Array<TsonProperty> {
		return _selectedNode == null ? [] : _selectedNode.properties;
	}
}
