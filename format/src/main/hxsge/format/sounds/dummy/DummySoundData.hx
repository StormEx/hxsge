package hxsge.format.sounds.dummy;

import hxsge.format.sounds.common.ISoundData;
import hxsge.format.sounds.common.ISound;

class DummySoundData implements ISoundData {
	public function new() {
	}

	public function create(volume:Float, sourceVolume:Float):ISound {
		return null;
	}
}
