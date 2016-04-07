package hxsge.format.base;

import hxsge.core.IDisposable;
import hxsge.core.debug.Debug;

class BaseReader<T> implements IReader implements IDisposable {
	var _input:T;

	public function new(input:T) {
		Debug.assert(input != null);

		this._input = input;
	}

	public function dispose() {
		_input = null;
	}

	public function read() {
		readData();
	}

	function readData() {
		Debug.error("need to override");
	}
}
