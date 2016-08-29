package hxsge.candyland.platforms.webgl;

#if js
import hxsge.candyland.common.AntialiasType;
import hxsge.photon.Signal;
import hxsge.candyland.common.IRender;

class WebGLRender implements IRender {
	public var info(get, never):String;
	public var isLost(get, never):Bool;
	public var antialias(default, set):AntialiasType;

	public var initialized(default, null):Signal1<Bool>;
	public var restored(default, null):Signal0;

	public function new() {
	}

	public function dispose() {

	}

	public function clear(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1) {

	}

	public function initialize() {

	}

	public function begin() {

	}

	public function present() {

	}

	public function resize(width:Int, height:Int) {

	}

	inline function get_info():String {
		return "";
	}

	inline function get_isLost():Bool {
		return false;
	}

	inline function set_antialias(value:AntialiasType):AntialiasType {
		return value;
	}
}
#end