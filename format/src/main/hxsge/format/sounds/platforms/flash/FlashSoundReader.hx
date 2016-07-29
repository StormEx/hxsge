package hxsge.format.sounds.platforms.flash;

#if flash
import flash.utils.ByteArray;
import haxe.io.Bytes;
import hxsge.core.debug.error.Error;

class FlashSoundReader extends SoundReader {
	var _soundLoader:flash.media.Sound;

	public function new(data:Bytes) {
		super(data);
	}

	override public function dispose() {
		super.dispose();
	}

	override function readData() {
		_soundLoader = new flash.media.Sound();
		try {
			var ba:ByteArray = _data.getData();
			ba.position = 0;
			_soundLoader.loadCompressedDataFromByteArray(ba, ba.length);
		}
		catch(e:Dynamic) {
			errors.addError(Error.create(Std.string(e)));
		}

		if(!errors.isError) {
			sound = new FlashSoundData(_soundLoader);
		}

		finished.emit(this);
	}
}
#end