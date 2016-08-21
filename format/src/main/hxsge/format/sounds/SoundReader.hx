package hxsge.format.sounds;

import hxsge.format.sounds.common.ISoundData;
import haxe.io.Bytes;
import hxsge.format.common.BytesReader;

class SoundReader extends BytesReader {
	public var sound(default, null):ISoundData;

	public function new(data:Bytes) {
		super(data);
	}

	override public function dispose() {
		super.dispose();

		sound = null;
	}
}
