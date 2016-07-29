package hxsge.format.images.formats.gif;

import hxsge.format.images.common.ImageData;
import hxsge.format.images.common.Image;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import format.gif.Reader;
import format.gif.Data;

using format.gif.Tools;
using hxsge.format.images.extension.ImageDataExtension;

class GifImageReader extends ImageReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		var reader:Reader = new Reader(new BytesInput(_data));
		var d:Data = reader.read();
		var h:Frame = d.frame(0);
		var bytes:Bytes = d.extractBGRA(0);

		var img:ImageData = new ImageData(null).fromBytes(h.width, h.height, bytes);
		image = new Image(img);

		finished.emit(this);
	}
}
