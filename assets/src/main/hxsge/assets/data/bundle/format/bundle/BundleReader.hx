package hxsge.assets.data.bundle.format.bundle;

import hxsge.core.debug.Debug;
import hxsge.format.json.SJson;
import hxsge.format.json.Json;
import haxe.io.Bytes;
import hxsge.format.base.BytesReader;

class BundleReader extends BytesReader {
	public var data(default, null):BundleData;

	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		var str:String = Std.string(_data);

		data = new BundleData();
		data.deserialize(Json.parse(str));

//		TODO remove this code after finish working on sjson format
		var b:Bytes = SJson.convert(str);
		if(b != null) {
			Debug.trace("SJSON: " + b.length);
		}
		else {
			Debug.trace("SJSON: empty");
		}
//		data = Json.build(str, BundleData);

		finished.emit(this);
	}
}
