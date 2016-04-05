package hxsge.loaders.base;

import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.IDisposable;
import msignal.Signal;

interface ILoader extends IDisposable {
	public var url(default, null):String;
	public var errors(default, null):ErrorHolder;
	public var finished(default, null):Signal1<ILoader>;
	public var progress(get, never):Float;
	public var isCanceled(default, null):Bool;
	public var isSuccess(default, null):Bool;
	public var content(default, null):Dynamic;

	public function load():Void;
	public function cancel():Void;
}
