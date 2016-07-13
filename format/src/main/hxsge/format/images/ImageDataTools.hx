package hxsge.format.images;

#if flash
import flash.utils.ByteArray;
import flash.display.BitmapData;
#end

import haxe.io.Bytes;

class ImageDataTools {
	public static function fromBytes(image:ImageData, width:Int, height:Int, bytes:Bytes):ImageData {
#if flash
		var bd:BitmapData = new BitmapData(width, height, true, 0xFFFF0000);
		var ba:ByteArray = bytes.getData();
		ba.position = 0;
		for(j in 0...height) {
			for(i in 0...width) {
				bd.setPixel32(i, j, ba.readUnsignedInt());
			}
		}

		@:privateAccess image.data = bd;
		@:privateAccess image._bytes = bytes;
#else
		@:privateAccess image.data = new RawImage(bytes, width, height);
		@:privateAccess image._bytes = bytes;
#end

		return image;
	}
}
