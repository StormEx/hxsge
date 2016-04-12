package hxsge.format.sounds;

import hxsge.core.debug.error.Error;
import haxe.io.Bytes;

class DummySoundReader extends SoundReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		errors.addError(Error.create("Not implemented for this platform"));

		finished.emit(this);
	}
}
