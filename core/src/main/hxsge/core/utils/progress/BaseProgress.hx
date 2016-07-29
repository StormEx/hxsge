package hxsge.core.utils.progress;

class BaseProgress implements IProgress {
	public var progress(get, never):Float;
	public var isFinished(get, never):Bool;

	var _progress:Float = 0;

	public function new() {}

	public function dispose() {}

	public function finish() {
		_progress = 1;
	}

	inline function get_progress():Float {
		return _progress;
	}

	inline function get_isFinished():Bool {
		return _progress == 1;
	}
}
