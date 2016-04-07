package hxsge.dataprovider.providers.images;

import hxsge.format.images.ImageReader;
import hxsge.format.images.jxr.JxrImageReader;
import hxsge.format.images.png.PngImageReader;

class ImageDataProviderTypes {
	static public var readers:Map<String, Class<ImageReader>> = [
		"png" => PngImageReader,
		"jxr" => JxrImageReader
	];

	static public function add(ext:String, cls:Class<ImageReader>) {
		readers.set(ext, cls);
	}
}
