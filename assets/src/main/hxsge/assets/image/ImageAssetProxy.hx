package hxsge.assets.image;

import hxsge.dataprovider.providers.swf.SwfDataProvider;
import hxsge.dataprovider.providers.images.ImageDataProvider;
import hxsge.assets.data.IAsset;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.assets.data.IAssetProxy;

class ImageAssetProxy implements IAssetProxy {
	public function new() {
	}

	public function check(data:IDataProvider):Bool {
		if(Std.is(data, SwfDataProvider)) {
			var dp:SwfDataProvider = Std.instance(data, SwfDataProvider);

			return dp.images.keys().hasNext();
		}
		else {
			return Std.is(data, ImageDataProvider);
		}

		return false;
	}

	public function create(data:IDataProvider):Array<IAsset> {
		var res:Array<IAsset> = [];

		if(Std.is(data, ImageDataProvider)) {
			var idp:ImageDataProvider = Std.instance(data, ImageDataProvider);

			res.push(new ImageAsset(data.info.id, idp.image));
		}
		else if(Std.is(data, SwfDataProvider)) {
			var sdp:SwfDataProvider = Std.instance(data, SwfDataProvider);

			for(k in sdp.images.keys()) {
				res.push(new ImageAsset(data.info.id + "/" + k, sdp.images.get(k)));
			}
		}

		return res;
	}
}
