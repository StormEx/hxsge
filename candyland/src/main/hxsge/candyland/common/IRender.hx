package hxsge.candyland.common;

import hxsge.photon.Signal.Signal1;
import hxsge.core.IDisposable;

interface IRender extends IDisposable {
	public var info(get, never):String;

	public var initialized(default, null):Signal1<Bool>;

	public function initialize():Void;
	public function begin():Void;
	public function present():Void;
}
