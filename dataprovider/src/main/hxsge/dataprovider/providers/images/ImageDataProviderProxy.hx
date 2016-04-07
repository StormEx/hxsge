package hxsge.dataprovider.providers.images;

import hxsge.dataprovider.providers.images.ImageDataProviderTypes;
import hxsge.dataprovider.providers.base.IDataProvider;
import haxe.io.Path;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProviderProxy;

class ImageDataProviderProxy extends BaseDataProviderProxy {
	public function new() {
		super("images");
	}

	override public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return ImageDataProviderTypes.readers.exists(ext);
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
		return new ImageDataProvider(info);
	}

	override function get_info():String {
		var types:Array<String> = [];

		for(k in ImageDataProviderTypes.readers.keys()) {
			types.push(k);
		}

		return type + "[" + types.join(", ") + "]";
	}
}
