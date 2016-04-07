package hxsge.format.images;

import haxe.io.BytesInput;
import hxsge.format.base.BaseReader;

class ImageReader extends BaseReader<BytesInput> {
	public var image(default, null):Image;

	public function new(input:BytesInput) {
		super(input);
	}
}
