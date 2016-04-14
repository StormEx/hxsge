package hxsge.core.utils.progress;

interface IProgress {
	public var progress(get, never):Float;
	public var isFinished(get, never):Bool;

	public function set(progress:Float):Float;
	public function reset(progress:Float = 0):Float;
}
