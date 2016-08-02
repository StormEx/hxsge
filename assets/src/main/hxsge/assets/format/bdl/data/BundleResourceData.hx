package hxsge.assets.format.bdl.data;

import hxsge.forge.ISerializable;

using hxsge.core.utils.StringTools;

class BundleResourceData implements ISerializable {
	public var id(default, null):String;
	public var name(default, null):String;
	public var data(default, null):Dynamic;
	public var meta(default, null):Dynamic;

	public function new() {
	}

	inline public function getId():String {
		return id.isEmpty() ? name : id;
	}
}
