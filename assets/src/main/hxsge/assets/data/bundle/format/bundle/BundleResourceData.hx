package hxsge.assets.data.bundle.format.bundle;

import hxsge.forge.ISerializable;

class BundleResourceData implements ISerializable {
	public var name(default, null):String;
	public var data(default, null):Dynamic;
	public var meta(default, null):Dynamic;

	public function new() {
	}
}
