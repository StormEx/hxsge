package hxsge.dataprovider.providers.images;

import hxsge.format.images.formats.gif.GifImageReader;
import hxsge.format.images.formats.bmp.BmpImageReader;
import hxsge.dataprovider.providers.common.group.DataProviderGroupProxy;
import hxsge.format.images.ImageReader;
import hxsge.format.images.formats.png.PngImageReader;
import hxsge.format.images.formats.jxr.JxrImageReader;
import hxsge.format.images.formats.jpg.JpgImageReader;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class ImageDataProviderProxy extends DataProviderGroupProxy<Class<ImageReader>>{
	public function new() {
		super(
			"images",
			[
				"jpg" => JpgImageReader,
				"jxr" => JxrImageReader,
				"png" => PngImageReader,
				"bmp" => BmpImageReader,
				"gif" => GifImageReader
			]
		);
	}
	override public function create(info:IDataProviderInfo):IDataProvider {
		return new ImageDataProvider(info, _types.readers);
	}
}
