package hxsge.format.sounds.platforms.js;

#if (js || nodejs)
import haxe.io.Bytes;

class JsOggSoundReader extends JsSoundReader {
	public function new(data:Bytes) {
		super(data);

		_ext = "ogg";
	}
}
#end