package hxsge.assets.data;

import hxsge.dataprovider.providers.common.IDataProvider;

interface IAssetProxy {
	public function check(data:IDataProvider):Bool;
	public function create(data:IDataProvider):Array<IAsset>;
}
