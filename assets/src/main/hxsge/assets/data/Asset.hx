package hxsge.assets.data;

import hxsge.core.memory.Memory;
import hxsge.photon.Signal.Signal1;
import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.base.IDataProvider;

class Asset implements IAsset {
	public var id(default, null):String;

	public var changed(default, null):Signal1<AssetChangeType>;

	var _data:IDataProvider;

	public function new(id:String, data:IDataProvider) {
		Debug.assert(data != null);

		this.id = id;
		_data = data;

		changed = new Signal1();
	}

	public function dispose() {
		Memory.dispose(changed);

		id = null;
		_data = null;
	}
}
