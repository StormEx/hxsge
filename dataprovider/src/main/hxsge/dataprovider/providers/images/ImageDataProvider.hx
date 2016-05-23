package hxsge.dataprovider.providers.images;

import hxsge.format.images.ImageReader;
import hxsge.dataprovider.providers.base.group.DataProviderGroup;
import hxsge.dataprovider.data.IDataProviderInfo;

class ImageDataProvider extends DataProviderGroup<ImageReader> {
	public function new(info:IDataProviderInfo, values:Map<String, Class<ImageReader>>) {
		super(info, values);
	}
}
