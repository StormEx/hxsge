package hxsge.format.images.common;

import haxe.io.Bytes;

class ImageData implements IImage {
	public var bytes(get, never):Bytes;
	public var width(get, never):Int;
	public var height(get, never):Int;

	public var data(default, null):ImageDataImpl;

	var _bytes:Bytes;

	public function new(data:ImageDataImpl) {
		this.data = data;
	}

	public function dispose() {
#if flash
		data.dispose();
#elseif js
#end
		data = null;
	}

	function get_bytes():Bytes {
		return _bytes;
	}

	function get_width():Int {
		return data.width;
	}

	function get_height():Int {
		return data.height;
	}
}