package hxsge.format.sounds.common;

import hxsge.photon.Signal.Signal0;
import hxsge.memory.IDisposable;

interface ISound extends IDisposable {
	public var volume(get, set):Float;
	public var sourceVolume(get, set):Float;
	public var loop(get, set):Bool;
	public var isPaused(get, set):Bool;
	public var length(get, never):Float;

	public var completed(default, null):Signal0;

	public function play(startTime:Float = 0):Void;
	public function pause():Void;
	public function resume():Void;
	public function stop():Void;
}
