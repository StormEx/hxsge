package hxsge.format.images;

import hxsge.core.memory.Memory;

class Image implements IImage {
	public var data(default, null):ImageData;
	public var width(get, never):Int;
	public var height(get, never):Int;

	public function new(data:ImageData) {
		this.data = data;
	}

	public function dispose() {
		Memory.dispose(data);
	}

	inline function get_width() {
		return data == null ? 0 : data.width;
	}

	inline function get_height() {
		return data == null ? 0 : data.height;
	}
}
