package hxsge.assets.sound;

import hxsge.assets.data.IAssetProxy;
import hxsge.dataprovider.providers.swf.SwfDataProvider;
import hxsge.dataprovider.providers.sounds.SoundDataProvider;
import hxsge.assets.data.IAsset;
import hxsge.dataprovider.providers.common.IDataProvider;

using hxsge.core.utils.ArrayTools;

class SoundAssetProxy implements IAssetProxy {
	public function new() {
	}

	public function check(data:IDataProvider):Bool {
		if(Std.is(data, SwfDataProvider)) {
			var dp:SwfDataProvider = Std.instance(data, SwfDataProvider);

			return dp.sounds.keys().hasNext();
		}
		else {
			return Std.is(data, SoundDataProvider);
		}

		return false;
	}

	public function create(data:IDataProvider):Array<IAsset> {
		var res:Array<IAsset> = [];

		if(Std.is(data, SwfDataProvider)) {
			var dp:SwfDataProvider = Std.instance(data, SwfDataProvider);

			for(s in dp.sounds.keys()) {
				res.push(new SoundAsset(dp.info.url, dp, s));
			}
		}
		else {
			res.push(new SoundAsset(data.info.url, data));
		}

		return res;
	}
}
