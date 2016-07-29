package hxsge.format.swf;

import hxsge.format.sounds.ISoundData;
import haxe.io.Bytes;
import hxsge.format.common.BytesReader;
import hxsge.format.images.common.Image;

class BaseSwfReader extends BytesReader {
	public var frameRate(default, null):Float = 30;

	public function new(data:Bytes) {
		super(data);
	}

	public function getImage(symbolName:String):Image {
		return null;
	}

	public function getSound(symbolName:String):ISoundData {
		return null;
	}
}
