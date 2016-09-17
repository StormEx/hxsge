package hxsge.assets.sound;

import hxsge.memory.Memory;
import hxsge.assets.data.Asset;
import hxsge.format.sounds.common.ISound;
import hxsge.format.sounds.common.ISoundData;

using hxsge.core.utils.StringTools;

class SoundAsset extends Asset {
	public var sound(default, null):ISoundData;

	public function new(id:String, sound:ISoundData) {
		super(id);

		this.sound = sound;
	}

	public function create(volume:Float = 1, sourceVolume:Float = 1):ISound {
		return sound != null ? sound.create(volume, sourceVolume) : null;
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(sound);
	}
}
