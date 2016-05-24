package hxsge.format.sounds.platforms.js;

#if (js || nodejs)
import haxe.io.Bytes;

class JsSoundReader extends SoundReader {
	var _audio:js.html.Audio;

	public function new(data:Bytes) {
		super(data);
	}

	override public function dispose() {
		super.dispose();
	}

	override function readData() {
		if(!errors.isError) {
			sound = new JsSoundData(_data);
		}

		finished.emit(this);
	}
}
#end