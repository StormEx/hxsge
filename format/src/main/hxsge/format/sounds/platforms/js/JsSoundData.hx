package hxsge.format.sounds.platforms.js;

#if js
import haxe.io.Bytes;
import hxsge.core.debug.Debug;

class JsSoundData implements ISoundData {
	public var data(default, null):Bytes;

	public function new(data:Bytes) {
		Debug.assert(data != null);

		this.data = data;
	}

	public function create(volume:Float, sourceVolume:Float):ISound {
		var res:JsSound = new JsSound(data, volume, sourceVolume);

		return res;
	}
}
#end