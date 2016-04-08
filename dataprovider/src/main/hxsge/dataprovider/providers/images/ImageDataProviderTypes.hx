package hxsge.dataprovider.providers.images;

import hxsge.format.images.formats.jpg.JpgImageReader;
import hxsge.format.images.ImageReader;
import hxsge.format.images.formats.jxr.JxrImageReader;
import hxsge.format.images.formats.png.PngImageReader;

class ImageDataProviderTypes {
	static public var readers:Map<String, Class<ImageReader>> = [
		"png" => PngImageReader,
		"jxr" => JxrImageReader,
		"jpg" => JpgImageReader
	];

	static public function add(ext:String, cls:Class<ImageReader>) {
		readers.set(ext, cls);
	}
}
