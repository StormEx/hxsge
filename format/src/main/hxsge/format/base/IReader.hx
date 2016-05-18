package hxsge.format.base;

import hxsge.core.IDisposable;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.photon.Signal;

interface IReader extends IDisposable {
	public var errors(default, null):ErrorHolder;
	public var finished(default, null):Signal1<IReader>;

	public function read():Void;
}
