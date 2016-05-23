package hxsge.format.sounds.formats.wav;

#if flash
import hxsge.format.sounds.platforms.flash.FlashSoundData;
import hxsge.core.debug.error.Error;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import format.wav.Reader;
import format.wav.Data;

using hxsge.format.sounds.SoundDataTools;

class WavSoundReader extends SoundReader {
	public function new(data:Bytes) {
		super(data);
	}

	override function readData() {
		var reader:Reader = new Reader(new BytesInput(_data));
		var d:WAVE = reader.read();
		var h:WAVEHeader = d.header;
		var bytes:Bytes = d.data;

		try {
			var snd:ISoundData = new FlashSoundData(null);
			snd = snd.fromBytes(bytes, h.byteRate);
			sound = snd;
		}
		catch(e:Dynamic) {
			errors.addError(Error.create("Can't encode wav data..."));
		}

		finished.emit(this);
	}
}
#else
import hxsge.format.sounds.platforms.dummy.DummySoundReader;

typedef WavSoundReader = DummySoundReader;
#end