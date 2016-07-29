package hxsge.format.images;

import hxsge.format.images.common.Image;
import hxsge.format.common.BytesReader;
import haxe.io.Bytes;

class ImageReader extends BytesReader {
	public var image(default, null):Image;

	public function new(data:Bytes) {
		super(data);
	}
}
