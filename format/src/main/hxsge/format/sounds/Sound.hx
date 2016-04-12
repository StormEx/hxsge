package hxsge.format.sounds;

import hxsge.core.memory.Memory;

class Sound implements ISound {
	public var data(default, null):SoundData;

	public function new(data:SoundData) {
		this.data = data;
	}

	public function dispose() {
		Memory.dispose(data);
	}
}
