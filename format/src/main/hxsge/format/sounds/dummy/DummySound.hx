package hxsge.format.sounds.dummy;

import hxsge.photon.Signal.Signal0;
import hxsge.format.sounds.common.ISound;
import hxsge.memory.Memory;

class DummySound implements ISound {
	public var volume(get, set):Float;
	public var sourceVolume(get, set):Float;
	public var loop(get, set):Bool;
	public var isPaused(get, set):Bool;
	public var length(get, never):Float;

	public var completed(default, null):Signal0;

	public function new() {
		completed = new Signal0();
	}

	public function dispose() {
		Memory.dispose(completed);
	}

	public function play(startTime:Float = 0) {
	}

	public function pause() {
	}

	public function resume() {
	}

	public function stop() {
	}

	inline function get_volume():Float {
		return 0;
	}

	inline function set_volume(value:Float):Float {
		return 0;
	}

	inline function get_sourceVolume():Float {
		return 0;
	}

	inline function set_sourceVolume(value:Float):Float {
		return 0;
	}

	inline function get_loop():Bool {
		return false;
	}

	inline function set_loop(value:Bool):Bool {
		return false;
	}

	inline function get_isPaused():Bool {
		return false;
	}

	inline function set_isPaused(value:Bool):Bool {
		return false;
	}

	inline function get_length():Float {
		return 0;
	}
}
