package hxsge.assets.format.bdl.data;

import hxsge.forge.ISerializable;

using hxsge.core.utils.StringTools;

class BundleResourceData implements ISerializable {
	public var id(default, null):String;
	public var name(default, null):String;
	public var data(default, null):Dynamic;
	public var meta(default, null):Dynamic;

	public function new(id:String = null, name:String = null, data:Dynamic = null, meta:Dynamic = null) {
		this.id = id;
		this.name = name;
		this.data = data;
		this.meta = meta;
	}

	inline public function getId():String {
		return id.isEmpty() ? name : id;
	}
}
