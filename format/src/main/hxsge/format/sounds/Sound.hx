package hxsge.format.sounds;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSound;

typedef Sound = FlashSound;
#elseif(js || nodejs)
import hxsge.format.sounds.platforms.js.JsSound;

typedef Sound = JsSound;
#else
import hxsge.format.sounds.platforms.dummy.DummySound;

typedef Sound = DummySound;
#end

//import hxsge.format.sounds.platforms.base.SoundData;
//import hxsge.core.memory.Memory;
//
//class Sound implements ISound {
//	public var data(default, null):SoundData;
//
//	public function new(data:SoundData) {
//		this.data = data;
//	}
//
//	public function dispose() {
//		Memory.dispose(data);
//	}
//
//	public function play() {
//		data.play();
//	}
//
//	public function stop() {
//		data.stop();
//	}
//}
