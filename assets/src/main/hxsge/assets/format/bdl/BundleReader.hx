package hxsge.assets.format.bdl;

import hxsge.assets.format.bdl.data.BundleData;
import haxe.io.Bytes;
import hxsge.format.common.BytesReader;

class BundleReader extends BytesReader {
	public var data(default, null):BundleData;

	public function new(data:Bytes) {
		super(data);
	}
}
