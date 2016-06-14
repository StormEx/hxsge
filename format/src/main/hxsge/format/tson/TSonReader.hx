package hxsge.format.tson;

import haxe.io.Bytes;
import hxsge.format.base.BytesReader;
import hxsge.format.tson.parts.TsonBlock;

class TsonReader extends BytesReader {
	public var tson(get, never):TsonBlock;

	var _decoder:TsonDecoder;

	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		_decoder = new TsonDecoder(_data);
	}

	inline function get_tson():TsonBlock {
		return (_decoder != null && _decoder.root != null) ? _decoder.root : null;
	}
}
