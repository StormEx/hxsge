package hxsge.format.sounds.platforms.js.audioelement;

#if (js || nodejs)
import hxsge.format.sounds.common.ISound;
import hxsge.core.debug.Debug;
import hxsge.format.sounds.common.ISoundData;
import js.html.AudioElement;

class JsAudioElementSoundData implements ISoundData {
	public var element(default, null):AudioElement;

	public function new(element:AudioElement) {
		Debug.assert(element != null);

		this.element = element;
	}

	public function dispose() {
		element = null;
	}

	public function create(volume:Float, sourceVolume:Float):ISound {
		var res:JsAudioElementSound = new JsAudioElementSound(element, volume, sourceVolume);

		return res;
	}
}
#end