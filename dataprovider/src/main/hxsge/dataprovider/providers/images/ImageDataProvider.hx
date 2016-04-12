package hxsge.dataprovider.providers.images;

import hxsge.format.base.IReader;
import hxsge.dataprovider.providers.base.group.DataProviderGroup;
import hxsge.dataprovider.data.IDataProviderInfo;

class ImageDataProvider<T:IReader> extends DataProviderGroup<T> {
	public function new(info:IDataProviderInfo, values:Map<String, Class<T>>) {
		super(info, values);
	}
}
