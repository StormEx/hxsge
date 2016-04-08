package hxsge.format.images;

import hxsge.format.base.BytesReader;
import haxe.io.Bytes;

class ImageReader extends BytesReader {
	public var image(default, null):Image;

	public function new(data:Bytes) {
		super(data);
	}
}
