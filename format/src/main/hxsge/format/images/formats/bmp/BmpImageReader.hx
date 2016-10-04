package hxsge.format.images.formats.bmp;

import hxsge.format.images.common.ImageData;
import hxsge.format.images.common.Image;
import haxe.io.Bytes;
#if !(js || jsnode)
import haxe.io.BytesInput;
import format.png.Reader;
import format.png.Data;
using format.png.Tools;
#end

class BmpImageReader extends ImageReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
#if (js || jsnode)
		ImageData.fromBytes(0, 0, _data, onCreateFromBytesImageCompleted, "bmp");
#else
		var reader:Reader = new Reader(new BytesInput(_data));
		var d:Data = reader.read();
		var h:Header = d.header;
		var bytes:Bytes = d.extractBGRA();

		ImageData.fromBytes(h.width, h.height, bytes, onCreateFromBytesImageCompleted);
#end
	}

	function onCreateFromBytesImageCompleted(image:ImageData) {
		this.image = image == null ? null : new Image(image);

		finished.emit(this);
	}
}