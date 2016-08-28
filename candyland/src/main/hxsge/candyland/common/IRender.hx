package hxsge.candyland.common;

import hxsge.photon.Signal.Signal1;
import hxsge.core.IDisposable;

interface IRender extends IDisposable {
	public var info(get, never):String;
	public var isLost(get, never):Bool;

	public var initialized(default, null):Signal1<Bool>;

	public function clear(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1):Void;
	public function initialize():Void;
	public function begin():Void;
	public function present():Void;
	public function resize(width:Int, height:Int):Void;
	public function restore():Void;
}
