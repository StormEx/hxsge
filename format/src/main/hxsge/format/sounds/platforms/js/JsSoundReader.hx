package hxsge.format.sounds.platforms.js;

#if js
import js.html.AudioElement;
import hxsge.format.sounds.platforms.js.webaudio.JsWebAudioSoundData;
import hxsge.format.sounds.platforms.js.audioelement.JsAudioElementSoundData;
import hxsge.core.debug.error.Error;
import haxe.crypto.Base64;
import js.Browser;
import js.html.audio.AudioBuffer;
import js.html.audio.AudioContext;
import haxe.io.Bytes;

class JsSoundReader extends SoundReader {
	var _context:AudioContext;
	var _element:AudioElement;
	var _ext:String = "mp3";

	public function new(data:Bytes) {
		super(data);

		_context = JsSoundManager.getContext();
	}

	override public function dispose() {
		super.dispose();
	}

	override function readData() {
		try {
			if(_context != null) {
				_context.decodeAudioData(_data.getData(), onAudioDataDecoded);
			}
			else {
				_element = Browser.document.createAudioElement();

				_element.onerror = onElementError;
				_element.oncanplaythrough = onElementCanPlayThrough;
				_element.src = "data:audio/" + _ext + ";base64," + Base64.encode(_data);
			}
		}
		catch(e:Dynamic) {
			errors.addError(Error.create("Can't create sound data..."));

			finished.emit(this);
		}
	}

	function onElementCanPlayThrough(_) {
		sound = new JsAudioElementSoundData(_element);

		finished.emit(this);
	}

	function onElementError(_) {
		errors.addError(Error.create("Can't create audio element..."));

		finished.emit(this);
	}

	function onAudioDataDecoded(buffer:AudioBuffer) {
		if(!errors.isError) {
			sound = new JsWebAudioSoundData(buffer);
		}

		finished.emit(this);
	}
}
#end