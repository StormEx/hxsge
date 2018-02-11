package hxsge.candyland.platforms.webgl;

import hxsge.core.utils.Color32;
import hxsge.candyland.common.TextureFormat;
import hxsge.candyland.common.material.ITexture;

class WebGLTexture implements ITexture {
	public var width(get, never):Int;
	public var height(get, never):Int;
	public var format(get, never):TextureFormat;

	var _width:Int = 0;
	var _height:Int = 0;
	var _format:TextureFormat = TextureFormat.BGRA_8888;

	public function new(width:Int, height:Int, format:TextureFormat) {
		_width = width;
		_height = height;
		_format = format;
	}

	public function dispose() {
		_width = 0;
		_height = 0;
	}

	public function fill(color:Color32) {
	}

	inline function get_width():Int {
		return _width;
	}

	inline function get_height():Int {
		return _height;
	}

	inline function get_format():TextureFormat {
		return _format;
	}
}
