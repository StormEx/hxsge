package hxsge.dataprovider.providers.sounds;

import hxsge.format.sounds.ISoundData;
import hxsge.format.sounds.SoundReader;
import hxsge.format.common.IReader;
import hxsge.dataprovider.providers.common.group.DataProviderGroup;
import hxsge.dataprovider.data.IDataProviderInfo;

class SoundDataProvider extends DataProviderGroup<SoundReader> {
	public var sound(default, null):ISoundData;

	public function new(info:IDataProviderInfo, values:Map<String, Class<SoundReader>>) {
		super(info, values);
	}

	override function prepareDataAfterRead() {
		super.prepareDataAfterRead();

		if(Std.is(_reader, SoundReader)) {
			var sr:SoundReader = cast _reader;
			sound = sr.sound;
		}
	}
}
