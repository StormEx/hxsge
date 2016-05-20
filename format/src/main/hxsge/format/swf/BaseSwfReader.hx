package hxsge.format.swf;

import haxe.io.Bytes;
import hxsge.format.base.BytesReader;
import hxsge.format.sounds.Sound;
import hxsge.format.images.Image;

class BaseSwfReader extends BytesReader {
	public var frameRate(default, null):Float = 30;

	public function new(data:Bytes) {
		super(data);
	}

	public function getImage(symbolName:String):Image {
		return null;
	}

	public function getSound(symbolName:String):Sound {
		return null;
	}
}
