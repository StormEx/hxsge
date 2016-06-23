package hxsge.assets.image;

import hxsge.dataprovider.providers.images.ImageDataProvider;
import hxsge.assets.base.IAsset;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.assets.base.IAssetProxy;

class ImageAssetProxy implements IAssetProxy {
	public function new() {
	}

	public function check(data:IDataProvider):Bool {
		return Std.is(data, ImageDataProvider);
	}

	public function create(data:IDataProvider):Array<IAsset> {
		return [new ImageAsset(data.info.url, data)];
	}
}
