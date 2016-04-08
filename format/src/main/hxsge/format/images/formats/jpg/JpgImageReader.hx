package hxsge.format.images.formats.jpg;

#if flash
import hxsge.format.images.platforms.flash.FlashImageReader;

typedef JpgImageReader = FlashImageReader;
#else
import hxsge.core.debug.Debug;
import haxe.io.BytesInput;

class JpgImageReader extends ImageReader {
	public function new(input:BytesInput) {
		super(input);
	}

	override function readData() {
		Debug.error("Not implemented for this platform");

		finished.emit(this);
	}
}
#end