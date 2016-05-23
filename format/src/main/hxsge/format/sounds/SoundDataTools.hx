package hxsge.format.sounds;

import flash.utils.ByteArray;
import haxe.io.Bytes;

class SoundDataTools {
	public static function fromBytes(sound:ISoundData, bytes:Bytes, rate:Int):ISoundData {
#if flash
		var sd:flash.media.Sound = new flash.media.Sound();
		var ba:ByteArray = bytes.getData();
		sd.loadPCMFromByteArray(ba, ba.length);

//		@:privateAccess sound.data = sd;
#end
		return sound;
	}
}
