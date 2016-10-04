package hxsge.dataprovider.providers.images;

import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.format.images.common.Image;
import hxsge.format.images.ImageReader;
import hxsge.dataprovider.providers.common.group.DataProviderGroup;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.memory.Memory;

class ImageDataProvider extends DataProviderGroup<ImageReader> {
	public var image:Image;

	public function new(info:IDataProviderInfo, values:Map<String, Class<ImageReader>>, parent:IDataProvider = null) {
		super(info, values, parent);
	}

	override public function clear() {
		super.clear();

		Memory.dispose(_reader);
		Memory.dispose(image);
	}

	override function prepareDataAfterRead() {
		super.prepareDataAfterRead();

		if(Std.is(_reader, ImageReader)) {
			var ir:ImageReader = cast _reader;
			image = ir.image;
		}
	}
}
