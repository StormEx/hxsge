package hxsge.format.images.formats.jxr;

#if flash
import hxsge.format.images.platforms.flash.FlashImageReader;

typedef JxrImageReader = FlashImageReader;
#else
import hxsge.core.debug.Debug;
import haxe.io.BytesInput;

class JxrImageReader extends ImageReader {
	public function new(input:BytesInput) {
		super(input);
	}

	override function readData() {
		Debug.error("Not implemented for this platform");

		finished.emit(this);
	}
}
#end