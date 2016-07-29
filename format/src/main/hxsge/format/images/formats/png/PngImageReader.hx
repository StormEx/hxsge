package hxsge.format.images.formats.png;

#if flash
import hxsge.format.images.common.ImageData;
import hxsge.format.images.common.Image;
import hxsge.format.images.extension.ImageDataExtension;
import hxsge.format.images.platforms.flash.FlashImageReader;

typedef PngImageReader = FlashImageReader;
#else
import haxe.io.BytesInput;
import haxe.io.Bytes;
import format.png.Reader;
import format.png.Data;

using format.png.Tools;
using hxsge.format.images.extension.ImageDataExtension;

class PngImageReader extends ImageReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		var reader:Reader = new Reader(new BytesInput(_data));
		reader.checkCRC = false;
		var d:Data = reader.read();
		var h:Header = d.getHeader();
		var bytes:Bytes = d.extract32();

		var img:ImageData = new ImageData(null).fromBytes(h.width, h.height, bytes);
		image = new Image(img);

		finished.emit(this);
	}
}
#end