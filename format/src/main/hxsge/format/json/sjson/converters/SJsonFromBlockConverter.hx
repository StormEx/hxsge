package hxsge.format.json.sjson.converters;

import haxe.io.BytesOutput;
import hxsge.format.json.sjson.parts.SJsonBlock;
import hxsge.format.json.sjson.parts.SJsonHeader;
import haxe.io.Bytes;

class SJsonFromBlockConverter {
	public var sjson(default, null):Bytes;

	var _names:Map<String, Int>;
	var _namesCount:Int = 0;

	var _string:String;
	var _pos:Int;

	public function new(header:SJsonHeader, block:SJsonBlock) {
		var out:BytesOutput = new BytesOutput();

		try {
			if(out != null) {
				header.write(out);
				block.write(out);
			}
		}

		sjson = out.getBytes();
	}
}
