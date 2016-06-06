package hxsge.format.tson.converters;

import haxe.io.BytesOutput;
import hxsge.format.tson.parts.TsonBlock;
import hxsge.format.tson.parts.TsonHeader;
import haxe.io.Bytes;

class TsonFromBlockConverter {
	public var tson(default, null):Bytes;

	var _names:Map<String, Int>;
	var _namesCount:Int = 0;

	var _string:String;
	var _pos:Int;

	public function new(header:TsonHeader, block:TsonBlock) {
		var out:BytesOutput = new BytesOutput();

		try {
			if(out != null) {
				header.write(out);
				block.write(out);
			}
		}

		tson = out.getBytes();
	}
}
