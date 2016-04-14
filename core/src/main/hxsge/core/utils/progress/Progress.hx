package hxsge.core.utils.progress;

class Progress implements IProgress {
	public var progress(get, never):Float;
	public var isFinished(get, never):Bool;

	var _progress:Float = 0;

	public function new(progress:Float = 0) {
		_progress = progress;
	}

	public function set(progress:Float):Float {
		if(isFinished) {
			return _progress;
		}

		return _progress = progress;
	}

	public function reset(progress:Float = 0):Float {
		if(progress < 0) {
			return _progress = 0;
		}
		if(progress > 1) {
			return _progress = 1;
		}

		return _progress = progress;
	}

	inline function get_progress():Float {
		return _progress;
	}

	inline function get_isFinished():Bool {
		return _progress == 1;
	}
}
