package hxsge.assets.bundle.format.bundle;

import haxe.io.Bytes;
import hxsge.format.common.BytesReader;

class BundleReader extends BytesReader {
	public var data(default, null):BundleData;

	public function new(data:Bytes) {
		super(data);
	}
}
