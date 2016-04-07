package hxsge.format.images.png;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import format.png.Reader;
import format.png.Data;

using format.png.Tools;
using hxsge.format.images.ImageDataTools;

class PngImageReader extends ImageReader {
	public function new(input:BytesInput) {
		super(input);
	}

	override function readData() {
		var reader:Reader = new Reader(_input);
		reader.checkCRC = false;
		var d:Data = reader.read();
		var h:Header = d.getHeader();
		var bytes:Bytes = d.extract32();

		var img:ImageData = new ImageData(null).fromBytes(h.width, h.height, bytes);
		image = new Image(img);
	}
}
