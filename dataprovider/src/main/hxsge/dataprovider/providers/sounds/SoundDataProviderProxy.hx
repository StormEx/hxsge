package hxsge.dataprovider.providers.sounds;

import hxsge.format.sounds.SoundReader;
import hxsge.dataprovider.providers.base.group.DataProviderGroupTypes;
import hxsge.dataprovider.providers.base.group.DataProviderGroupProxy;
import hxsge.format.sounds.formats.ogg.OggSoundReader;
import hxsge.format.sounds.formats.mp3.Mp3SoundReader;
import hxsge.format.sounds.formats.wav.WavSoundReader;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class SoundDataProviderProxy extends DataProviderGroupProxy<Class<SoundReader>>{
	public function new() {
		super("sounds", ["mp3" => Mp3SoundReader, "ogg" => OggSoundReader, "wav" => WavSoundReader]);
	}
	override public function create(info:IDataProviderInfo):IDataProvider {
		return new SoundDataProvider<SoundReader>(info, _types.readers);
	}
}
