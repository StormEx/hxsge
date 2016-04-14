package hxsge.format.images.formats.bmp;

import haxe.io.BytesInput;
import haxe.io.Bytes;
import format.bmp.Reader;
import format.bmp.Data;

using format.bmp.Tools;
using hxsge.format.images.ImageDataTools;

class BmpImageReader extends ImageReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		var reader:Reader = new Reader(new BytesInput(_data));
		var d:Data = reader.read();
		var h:Header = d.header;
		var bytes:Bytes = d.extractBGRA();

		var img:ImageData = new ImageData(null).fromBytes(h.width, h.height, bytes);
		image = new Image(img);

		finished.emit(this);
	}
}