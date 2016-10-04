package hxsge.format.sounds.platforms.js.audioelement;

#if (js || jsnode)
import js.html.AudioElement;

class JsAudioElementSound extends JsSound {
	var _element:AudioElement;

	public function new(element:AudioElement, volume:Float, sourceVolume:Float) {
		super(volume, sourceVolume);

		_element = element;
	}

	override public function dispose() {
		super.dispose();

		_element = null;
	}

	override public function performPlay(startTime:Float = 0) {
		if(_element != null) {
			_element.loop = loop;
			_element.onended = onSoundCompleted;
			_element.volume = _volume.value;
//			_element.fastSeek(_position);
			_element.play();
		}
	}

	override public function performStop() {
		if(_element != null) {
			_element.pause();
		}
	}

	override function changeVolume() {
		if(_element != null) {
			_element.volume = _volume.value;
		}
	}

	override function getDuration():Float {
		return _element != null ? _element.duration : 0;
	}

	override function getCurrentTime():Float {
		return _element != null ? _element.duration : 0;
	}
}
#end