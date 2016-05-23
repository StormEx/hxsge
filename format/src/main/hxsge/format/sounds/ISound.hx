package hxsge.format.sounds;

import hxsge.core.IDisposable;

interface ISound extends IDisposable {
	public var volume(get, set):Float;
	public var sourceVolume(get, set):Float;
	public var loop(get, set):Bool;
	public var isPaused(get, set):Bool;
	public var length(get, never):Float;

	public function play(startTime:Float = 0):Void;
	public function pause():Void;
	public function resume():Void;
	public function stop():Void;
}
