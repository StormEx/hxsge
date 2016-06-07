package hxsge.examples.format.tson.data;

import hxsge.core.debug.Debug;
import hxsge.format.tson.parts.TsonBlock;

class TsonManagerData {
	public var tson(default, set):TsonBlock;
	public var treeData:Array<TsonNode> = [];

	public var isLoaded(get, never):Bool;

	public function new() {
	}

	function rebuildData() {
		treeData = [new TsonNode(tson, "root", true)];

		untyped __js__("console.log(this.treeData)");
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
}
