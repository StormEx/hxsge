package hxsge.dataprovider.providers.images;

import hxsge.format.images.formats.bmp.BmpImageReader;
import hxsge.dataprovider.providers.base.group.DataProviderGroupProxy;
import hxsge.format.images.ImageReader;
import hxsge.format.images.formats.png.PngImageReader;
import hxsge.format.images.formats.jxr.JxrImageReader;
import hxsge.format.images.formats.jpg.JpgImageReader;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class ImageDataProviderProxy extends DataProviderGroupProxy<Class<ImageReader>>{
	public function new() {
		super(
			"images",
			[
				"jpg" => JpgImageReader,
				"jxr" => JxrImageReader,
				"png" => PngImageReader,
				"bmp" => BmpImageReader
			]
		);
	}
	override public function create(info:IDataProviderInfo):IDataProvider {
		return new ImageDataProvider<ImageReader>(info, _types.readers);
	}
}
