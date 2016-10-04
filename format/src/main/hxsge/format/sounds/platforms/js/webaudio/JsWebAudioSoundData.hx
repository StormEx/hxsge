package hxsge.format.sounds.platforms.js.webaudio;

#if js
import hxsge.format.sounds.common.ISound;
import hxsge.core.debug.Debug;
import hxsge.format.sounds.common.ISoundData;
import js.html.audio.AudioBuffer;

class JsWebAudioSoundData implements ISoundData {
	public var buffer(default, null):AudioBuffer;

	public function new(buffer:AudioBuffer) {
		Debug.assert(buffer != null);

		this.buffer = buffer;
	}

	public function dispose() {
		buffer = null;
	}

	public function create(volume:Float, sourceVolume:Float):ISound {
		var res:JsWebAudioSound = new JsWebAudioSound(buffer, volume, sourceVolume);

		return res;
	}
}
#end