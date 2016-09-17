package hxsge.format.swf;

import hxsge.core.debug.error.Error;
import haxe.io.Bytes;

class DummySwfReader extends BaseSwfReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		errors.addError(Error.create("Not implemented for this platform"));

		finished.emit(this);
	}
}
