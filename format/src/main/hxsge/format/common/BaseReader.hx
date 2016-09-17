package hxsge.format.common;

import hxsge.memory.Memory;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.photon.Signal;
import hxsge.core.debug.Debug;

class BaseReader<T> implements IReader {
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
		_data = null;
	}

	public function read() {
		readData();
	}

	function readData() {
		Debug.error("need to override");
	}
}
