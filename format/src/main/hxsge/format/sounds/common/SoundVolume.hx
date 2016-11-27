package hxsge.format.sounds.common;

using hxsge.math.extentions.MathFloatExtension;

class SoundVolume {
	public var value(get, set):Float;
	public var source(get, set):Float;

	var _master:Float;
	var _current:Float;
	var _raw:Float = 1;

	public function new(volume:Float = 1, sourceVolume:Float = 1) {
		_master = sourceVolume;
		_current = _master;
		this.value = volume;
	}

	inline function get_value():Float {
		return _current;
	}

	inline function set_value(value:Float):Float {
		if(value != _raw) {
			_raw = value;
			_current = value.clamp(0, 1) * _master;
		}

		return _raw;
	}

	inline function get_source():Float {
		return _master;
	}

	inline function set_source(value:Float):Float {
		if(_master != value) {
			_master = value;
			this.value = _raw;
		}

		return _master;
	}
}
