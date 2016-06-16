package hxsge.format.tools.tson.data;

import hxsge.format.tson.data.TsonData;
import hxsge.photon.Signal.Signal0;

using hxsge.core.utils.ArrayTools;

class TsonManagerData {
	public var tson(default, set):TsonData;
	public var treeData:Array<TsonNode> = [];
	public var types:Array<TsonPropertyDataType> = [];
	public var propertyGroups(get, never):Array<TsonPropertyGroup>;
	public var loading:Bool = false;

	public var changed(default, null):Signal0;

	var _selectedNode:TsonNode;
	var _propObj:Dynamic;
	var _propMeta:Dynamic;

	var _copy:TsonNode = null;
	var _cut:TsonNode = null;

	public function new() {
		types = TsonPropertyDataType.getTypesForChoose();

		changed = new Signal0();

		rebuildData();
	}

	public function isLoaded():Bool {
		return !loading;
	}

	public function copyNode(node:TsonNode) {
		_cut = null;
		_copy = node;
	}

	public function cutNode(node:TsonNode) {
		_copy = null;
		_cut = node;
		node.parent.cutChild(node);
	}

	public function pasteNode(node:TsonNode) {
		if(_cut != null) {
			node.insertChild(_cut);
			_cut = null;
		}
		else {
			node.insertChild(_copy.clone());
		}
	}

	public function isBuffered():Bool {
		return _cut != null || _copy != null;
	}

	public function selectNode(node:TsonNode, selected:Bool) {
		if(_selectedNode != node) {
			_selectedNode = node;
			changed.emit();
		}
	}

	public function hasPropertyGroups():Bool {
		if(propertyGroups == null || propertyGroups.length == 0) {
			return false;
		}

		for(g in propertyGroups) {
			if(!g.isEmpty()) {
				return true;
			}
		}

		return false;
	}

	public function update() {
		changed.emit();
	}

	function rebuildData() {
		_selectedNode = null;
		treeData = [new TsonNode(tson, null, update)];
	}

	public function getGroups():Array<TsonPropertyGroup> {
		return propertyGroups;
	}

	public function getChanges():TsonData {
		return treeData[0].getData();
	}

	function set_tson(value:TsonData):TsonData {
		if(tson != value) {
			tson = value;

			rebuildData();
		}

		return tson;
	}

	function get_propertyGroups():Array<TsonPropertyGroup> {
		return _selectedNode == null ? [] : _selectedNode.propertyGroups.safeGet();
	}
}

