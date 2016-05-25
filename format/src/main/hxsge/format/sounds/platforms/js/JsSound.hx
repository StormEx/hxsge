package hxsge.format.sounds.platforms.js;

#if js
import hxsge.format.json.Json;
import hxsge.core.debug.Debug;
import hxsge.format.sounds.platforms.base.SoundVolume;
import js.html.audio.GainNode;
import js.html.audio.AudioBufferSourceNode;
import haxe.io.Bytes;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioContext;

class JsSound implements ISound {
	public var volume(get, set):Float;
	public var sourceVolume(get, set):Float;
	public var loop(get, set):Bool;
	public var isPaused(get, set):Bool;
	public var length(get, never):Float;

	var _context:AudioContext;
	var _buffer:AudioBuffer;
	var _source:AudioBufferSourceNode;
	var _gain:GainNode;
	var _isReady:Bool = false;
	var _data:Bytes;
	var _position:Float = 0;
	var _volume:SoundVolume;
	var _loop:Bool = false;
	var _isPaused:Bool = false;

	public function new(data:Bytes, volume:Float, sourceVolume:Float) {
		try {
			_context = new AudioContext();
			_gain = _context.createGain();
			_data = data;
			_volume = new SoundVolume(volume, sourceVolume);
		}
		catch(e:Dynamic) {
			_context = null;
			_gain = null;
		}
	}

	public function dispose() {
		stop();

		_volume = null;
		_data = null;
		_buffer = null;
		_gain = null;
		_context = null;
	}

	public function play(startTime:Float = 0) {
		stop();

		_position = startTime;
		if(!_isReady) {
			if(_context != null) {
				try {
					_context.decodeAudioData(_data.getData(), onDataDecoded);
				}
				catch(e:Dynamic) {
					Debug.trace("Can't decode audio data: " + Json.stringify(e));
				}
			}
		}
		else {
			_play();
		}
	}

	function _play() {
		if(_buffer != null && _context != null && _source == null) {
			_source = _context.createBufferSource();
			_source.buffer = _buffer;
			_source.connect(_context.destination);
			_source.loop = loop;
			_gain.gain.value = _volume.value;
			_source.start(_position);
		}
	}

	public function pause() {
		if(!_isPaused && _source != null) {
			_position = _context.currentTime;
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
		if(_source != null) {
			_source.stop();
			_source.disconnect();
			_source = null;
		}
	}

	function onDataDecoded(buffer:AudioBuffer) {
		_buffer = buffer;
		_isReady = true;

		_play();
	}

	inline function get_volume():Float {
		return _volume.value;
	}

	inline function set_volume(value:Float):Float {
		_volume.value = value;
		if(_gain != null) {
			_gain.gain.value = _volume.value;
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
		return _buffer != null ? _buffer.duration : 0;
	}
}
#end