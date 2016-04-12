package hxsge.assets.data.bundle.format.bundle;

import hxsge.core.utils.Json;
import haxe.io.Bytes;
import hxsge.format.base.BytesReader;

class BundleReader extends BytesReader {
	public var data(default, null):BundleData;

	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		var str:String = Std.string(_data);

		data = Json.build(str, BundleData);

		finished.emit(this);
	}
}
