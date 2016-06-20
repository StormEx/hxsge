package hxsge.assets.data.bundle.format.bundle;

import haxe.Json;
import haxe.io.Bytes;

class JsonBundleReader extends BundleReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		var str:String = Std.string(_data);

		data = new BundleData();
		data.deserialize(Json.parse(str));

		finished.emit(this);
	}
}
