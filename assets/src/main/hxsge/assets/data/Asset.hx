package hxsge.assets.data;

import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.base.IDataProvider;

class Asset implements IAsset {
	public var id(default, null):String;

	var _data:IDataProvider;

	public function new(id:String, data:IDataProvider) {
		Debug.assert(data != null);

		this.id = id;
		_data = data;
	}

	public function dispose() {
		id = null;
		_data = null;
	}
}
