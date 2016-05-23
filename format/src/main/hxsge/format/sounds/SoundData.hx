package hxsge.format.sounds;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSound;

typedef SoundData = FlashSound;
#else
import hxsge.format.sounds.platforms.dummy.DummySoundData;

typedef SoundData = DummySoundData;
#end
//
//class SoundData implements ISound {
//	public var volume(get, set):Float;
//	public var sourceVolume(get, set):Float;
//	public var loop(get, set):Bool;
//	public var length(get, never):Float;
//
//	public var data(default, null):SoundImpl;
//
//	public function new(data:SoundImpl) {
//		this.data = data;
//	}
//
//	public function dispose() {
//#if flash
//		data.close();
//#elseif js
//#end
//		data = null;
//	}
//
//	public function play(startTime:Float = 0) {
//#if flash
//		data.play(startTime * 1000, loop ? 999999 : 1)
//#end
//	}
//
//	public function pause() {
//	}
//
//	public function resume() {
//	}
//
//	public function stop() {
//#if flash
//		data.close();
//#end
//	}
//}
