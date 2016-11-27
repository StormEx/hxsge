package hxsge.candyland.platforms.stage3d;

import flash.display3D.Context3DTextureFormat;
import hxsge.candyland.platforms.stage3d.Stage3dRender;
import flash.display.BitmapData;
import flash.display3D.textures.Texture;
import hxsge.core.utils.Color32;
import hxsge.candyland.common.TextureFormat;
import hxsge.candyland.common.material.ITexture;

class Stage3dTexture implements ITexture {
	public var width(get, never):Int;
	public var height(get, never):Int;
	public var format(get, never):TextureFormat;

	public var impl(default, null):Texture = null;

	var _width:Int = 0;
	var _height:Int = 0;
	var _format:TextureFormat = TextureFormat.BGRA_8888;

	public function new(render:Stage3dRender, width:Int, height:Int, format:TextureFormat) {
		_width = width;
		_height = height;
		_format = format;

		impl = render._context3D.createTexture(_width, _height, Context3DTextureFormat.BGRA, false);
	}

	public function dispose() {
		if(impl != null) {
			impl.dispose();
			impl = null;
		}

		_width = 0;
		_height = 0;
	}

	public function fill(color:Color32) {
		var bd:BitmapData = new BitmapData(_width, _height, true, color);
		impl.uploadFromBitmapData(bd, 0);
//		bd.dispose();
//		bd = null;
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
