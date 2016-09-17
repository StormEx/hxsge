package hxsge.format.images;

import haxe.io.Bytes;
import hxsge.core.debug.error.Error;

class DummyImageReader extends ImageReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		errors.addError(Error.create("Not implemented for this platform"));

		finished.emit(this);
	}
}
