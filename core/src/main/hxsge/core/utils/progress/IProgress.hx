package hxsge.core.utils.progress;

interface IProgress extends IDisposable {
	public var progress(get, never):Float;
	public var isFinished(get, never):Bool;

	public function finish():Void;
}
