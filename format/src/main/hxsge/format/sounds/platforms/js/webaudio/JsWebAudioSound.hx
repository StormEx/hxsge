package hxsge.format.sounds.platforms.js.webaudio;

#if js
import js.html.audio.GainNode;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioContext;

class JsWebAudioSound extends JsSound {
	var _buffer:AudioBuffer;
	var _source:AudioBufferSourceNode;
	var _gain:GainNode;
	var _context:AudioContext = null;

	public function new(buffer:AudioBuffer, volume:Float, sourceVolume:Float) {
		super(volume, sourceVolume);

		_buffer = buffer;
		_context = JsSoundManager.getContext();
	}

	override public function dispose() {
		super.dispose();

		_buffer = null;
		_gain = null;
		_context = null;
	}

	override function performPlay(startTime:Float = 0) {
		if(_buffer != null && _context != null && _source == null) {
			_source = _context.createBufferSource();
			_source.buffer = _buffer;
			_source.connect(_context.destination);
			_source.loop = loop;
			_source.onended = onSoundCompleted;
			if(_gain == null) {
				_gain = _context.createGain();
				_source.connect(_gain);
				_gain.connect(_context.destination);
				_gain.gain.value = _volume.value - 1;
			}
			_source.start(_position);
		}
	}

	override function performStop() {
		if(_source != null) {
			_gain.disconnect();
			_gain = null;
			_source.stop();
			_source.disconnect();
			_source = null;
		}
	}

	override function changeVolume() {
		if(_gain != null) {
			_gain.gain.value = _volume.value;
		}
	}

	override function getDuration():Float {
		return _buffer != null ? _buffer.duration : 0;
	}

	override function getCurrentTime():Float {
		return _context != null ? _context.currentTime : 0;
	}
}
#end