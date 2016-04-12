package hxsge.dataprovider.providers.sounds;

import hxsge.format.base.IReader;
import hxsge.dataprovider.providers.base.group.DataProviderGroup;
import hxsge.dataprovider.data.IDataProviderInfo;

class SoundDataProvider<T:IReader> extends DataProviderGroup<T> {
	public function new(info:IDataProviderInfo, values:Map<String, Class<T>>) {
		super(info, values);
	}
}
