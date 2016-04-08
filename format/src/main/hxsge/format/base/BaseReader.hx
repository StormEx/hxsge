package hxsge.format.base;

import haxe.io.Bytes;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.memory.Memory;
import hxsge.core.signal.Signal.Signal1;
import hxsge.core.IDisposable;
import hxsge.core.debug.Debug;

class BaseReader<T> implements IReader implements IDisposable {
	public var errors(default, null):ErrorHolder;

	public var finished(default, null):Signal1<IReader>;

	var _data:T;

	public function new(data:T) {
		Debug.assert(data != null);

		_data = data;
		finished = new Signal1();
		errors = new ErrorHolder();
	}

	public function dispose() {
		Memory.dispose(finished);
		errors = null;
	}

	public function read() {
		readData();
	}

	function readData() {
		Debug.error("need to override");
	}
}
