package hxsge.format.images;

import haxe.io.Bytes;

class RawImage implements IImage {
	public var width(get, never):Int;
	public var height(get, never):Int;

	var _width:Int;
	var _height:Int;
	var _data:Bytes;

	public function new(data:Bytes, width:Int, height:Int) {
		_data = data;
		_width = width;
		_height = height;
	}

	public function dispose() {
		_data = null;
		_width = 0;
		_height = 0;
	}

	inline function get_width():Int {
		return _width;
	}

	inline function get_height():Int {
		return _height;
	}
}
