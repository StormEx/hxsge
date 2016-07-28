package hxsge.core.utils.progress;

import hxsge.core.debug.Debug;

class MinMaxProgress extends BaseProgress {
	public var min(default, null):Int;
	public var max(default, null):Int;

	var _value:Int = 0;
	var _delta:Int;

	public function new(min:Int = 0, max:Int = 1) {
		super();

		reset(min, max);
	}

	inline public function change(count:Int = 1) {
		_value += count;
		if(_value < 0) {
			_value = 0;
		}
		else if(_value > _delta) {
			_value = _delta;
		}

		calculate();
	}

	inline public function reset(min:Int = 0, max:Int = 1) {
		Debug.assert(max > min);

		this.min = min;
		this.max = max;

		_delta = max - min;
		_value = 0;
		_progress = 0;
	}

	inline function calculate() {
		_progress = _value == 0 ? 0 : _delta / _value;
	}
}
