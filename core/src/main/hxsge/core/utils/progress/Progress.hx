package hxsge.core.utils.progress;

class Progress extends BaseProgress {
	public function new(progress:Float = 0) {
		super();

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
}
