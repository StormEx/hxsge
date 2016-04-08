package hxsge.format.base;

import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.signal.Signal.Signal1;

interface IReader {
	public var errors(default, null):ErrorHolder;
	public var finished(default, null):Signal1<IReader>;

	public function read():Void;
}
