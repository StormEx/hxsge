package hxsge.format.sounds.platforms.js;

#if (js || nodejs)
import hxsge.memory.Memory;
import hxsge.format.sounds.common.SoundVolume;
import hxsge.photon.Signal.Signal0;
import hxsge.format.sounds.common.ISound;

class JsSound implements ISound {
	public var volume(get, set):Float;
	public var sourceVolume(get, set):Float;
	public var loop(get, set):Bool;
	public var isPaused(get, set):Bool;
	public var length(get, never):Float;

	public var completed(default, null):Signal0;

	var _position:Float = 0;
	var _volume:SoundVolume;
	var _loop:Bool = false;
	var _isPaused:Bool = false;

	public function new(volume:Float, sourceVolume:Float) {
		completed = new Signal0();
		_volume = new SoundVolume(volume, sourceVolume);
	}

	public function dispose() {
		Memory.dispose(completed);

		stop();

		_volume = null;
	}

	public function play(startTime:Float = 0) {
		stop();

		_position = startTime;

		performPlay();
	}

	public function pause() {
		if(!_isPaused) {
			_position = getCurrentTime();
			stop();
			_isPaused = true;
		}
	}

	public function resume() {
		if(_isPaused) {
			play(_position);
			_isPaused = false;
		}
	}

	public function stop() {
		_position = 0;
		performStop();
	}

	function performPlay(startTime:Float = 0) {
	}

	function performStop() {
	}

	function changeVolume() {
	}

	function getDuration():Float {
		return 0;
	}

	function getCurrentTime():Float {
		return 0;
	}

	function onSoundCompleted() {
		stop();

		if(completed != null) {
			completed.emit();
		}
	}

	inline function get_volume():Float {
		return _volume != null ? _volume.value : 0;
	}

	inline function set_volume(value:Float):Float {
		if(_volume == null || _volume.value == value) {
			return 0;
		}
		_volume.value = value;
		changeVolume();

		return _volume.value;
	}

	inline function get_sourceVolume():Float {
		return _volume.source;
	}

	inline function set_sourceVolume(value:Float):Float {
		if(_volume == null || _volume.source == value) {
			return value;
		}

		_volume.source = value;
		volume = _volume.value;

		return _volume.source;
	}

	inline function get_loop():Bool {
		return _loop;
	}

	inline function set_loop(value:Bool):Bool {
		return _loop = value;
	}

	inline function get_isPaused():Bool {
		return _isPaused;
	}

	inline function set_isPaused(value:Bool):Bool {
		value ? pause() : resume();

		return _isPaused;
	}

	inline function get_length():Float {
		return getDuration();
	}
}
#end