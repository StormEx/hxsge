package hxsge.assets.format.bdl;

import hxsge.assets.format.bdl.data.BundleData;
import hxsge.format.tson.Tson;
import haxe.io.Bytes;

class TsonBundleReader extends BundleReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		data = new BundleData();
		data.deserialize(Tson.parse(_data));

		finished.emit(this);
	}
}
