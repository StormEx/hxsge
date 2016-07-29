package hxsge.assets.image;

import hxsge.dataprovider.providers.images.ImageDataProvider;
import hxsge.assets.data.IAsset;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.assets.data.IAssetProxy;

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
