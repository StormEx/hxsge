package hxsge.format.sounds.platforms.flash;

#if flash
import hxsge.core.debug.Debug;

class FlashSoundData implements ISoundData {
	public var sound(default, null):flash.media.Sound;

	public function new(sound:flash.media.Sound) {
		Debug.assert(sound != null);

		this.sound = sound;
	}

	public function create(volume:Float, sourceVolume:Float):ISound {
		var res:FlashSound = new FlashSound(sound, volume, sourceVolume);

		return res;
	}

	public function remove(sound:ISound) {
	}
}
#end