package hxsge.format.sounds.platforms.flash;

#if flash
import flash.media.SoundTransform;
import hxsge.format.sounds.platforms.base.SoundVolume;
import flash.events.Event;
import flash.media.SoundChannel;
import flash.media.Sound;
import hxsge.format.sounds.ISound;

class FlashSound implements ISound {
	public var volume(get, set):Float;
	public var sourceVolume(get, set):Float;
	public var loop(get, set):Bool;
	public var isPaused(get, set):Bool;
	public var length(get, never):Float;

	var _isPaused:Bool = false;
	var _position:Float = 0;
	var _volume:SoundVolume;
	var _sound:Sound;
	var _channel:SoundChannel;
	var _st:SoundTransform;
	var _loop:Bool = false;

	public function new(sound:Sound, volume:Float = 1, sourceVolume:Float = 1) {
		_sound = sound;
		_volume = new SoundVolume(volume, sourceVolume);
		_st = new SoundTransform(_volume.value);
	}

	public function dispose() {
		stop();

		_volume = null;
		_channel = null;
		_sound = null;
	}

	public function play(startTime:Float = 0) {
		stop();

		if(_sound != null) {
			_position = startTime;
			_channel = _sound.play(_position, loop ? 999999 : 0, _st);
			if(_channel != null) {
				_position = _channel.position;
				_channel.addEventListener(Event.SOUND_COMPLETE, onSoundCompleted, false, 0, true);
			}
		}
	}

	public function pause() {
		if(!_isPaused && _channel != null) {
			_position = _channel.position;
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
		if(_channel != null) {
			_channel.removeEventListener(Event.SOUND_COMPLETE, onSoundCompleted);
			_channel.stop();
			_channel = null;
		}
	}

	function onSoundCompleted(event:Event) {
		stop();
	}

	inline function get_volume():Float {
		return _volume.value;
	}

	inline function set_volume(value:Float):Float {
		_volume.value = value;
		if(_channel != null) {
			_st.volume = _volume.value;
			_channel.soundTransform = _st;
		}

		return _volume.value;
	}

	inline function get_sourceVolume():Float {
		return _volume.source;
	}

	inline function set_sourceVolume(value:Float):Float {
		if(_volume.source != value) {
			_volume.source = value;

			this.volume = _volume.value;
		}

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
		return _sound != null ? _sound.length : 0;
	}
}
#end
