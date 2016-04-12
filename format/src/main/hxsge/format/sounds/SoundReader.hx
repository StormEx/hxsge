package hxsge.format.sounds;

import haxe.io.Bytes;
import hxsge.format.base.BytesReader;

class SoundReader extends BytesReader {
	public var sound(default, null):Sound;

	public function new(data:Bytes) {
		super(data);
	}
}
