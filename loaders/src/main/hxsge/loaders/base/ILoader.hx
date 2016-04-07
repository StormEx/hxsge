package hxsge.loaders.base;

import hxsge.core.signal.Signal;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.IDisposable;

interface ILoader extends IDisposable {
	public var url(default, null):String;
	public var errors(default, null):ErrorHolder;
	public var finished(default, null):Signal1<ILoader>;
	public var state(default, null):LoaderStateType;
	public var content(default, null):Dynamic;
	public var progress(get, never):Float;

	public function load():Void;
	public function cancel():Void;
}
