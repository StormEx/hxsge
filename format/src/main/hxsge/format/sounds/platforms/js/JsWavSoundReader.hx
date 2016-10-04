package hxsge.format.sounds.platforms.js;

#if (js || nodejs)
import haxe.io.Bytes;

class JsWavSoundReader extends JsSoundReader {
	public function new(data:Bytes) {
		super(data);

		_ext = "wav";
	}
}
#end