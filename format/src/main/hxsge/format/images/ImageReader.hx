package hxsge.format.images;

import hxsge.format.images.common.Image;
import hxsge.format.common.BytesReader;
import haxe.io.Bytes;
import hxsge.memory.Memory;

class ImageReader extends BytesReader {
	public var image(default, null):Image;

	public function new(data:Bytes) {
		super(data);
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(image);
	}
}
