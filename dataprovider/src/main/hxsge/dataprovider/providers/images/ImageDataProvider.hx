package hxsge.dataprovider.providers.images;

import hxsge.format.images.Image;
import hxsge.format.images.ImageReader;
import hxsge.dataprovider.providers.base.group.DataProviderGroup;
import hxsge.dataprovider.data.IDataProviderInfo;

class ImageDataProvider extends DataProviderGroup<ImageReader> {
	public var image:Image;

	public function new(info:IDataProviderInfo, values:Map<String, Class<ImageReader>>) {
		super(info, values);
	}

	override function prepareDataAfterRead() {
		super.prepareDataAfterRead();

		if(Std.is(_reader, ImageReader)) {
			var ir:ImageReader = cast _reader;
			image = ir.image;
		}
	}
}
