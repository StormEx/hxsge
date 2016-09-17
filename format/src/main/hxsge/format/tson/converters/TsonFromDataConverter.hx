package hxsge.format.tson.converters;

import hxsge.format.tson.data.TsonData;
import hxsge.format.tson.data.TsonDataWriter;
import hxsge.core.debug.Debug;
import haxe.io.BytesOutput;
import haxe.io.Bytes;

class TsonFromDataConverter {
	public var tson(default, null):Bytes;

	public function new(data:TsonData) {
		var stream:BytesOutput = new BytesOutput();

		try {
			TsonDataWriter.write(data, stream);
		}
		catch(e:Dynamic) {
			Debug.trace(e);
		}

		tson = stream.getBytes();
	}
}
