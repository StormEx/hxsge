package hxsge.assets.base;

import hxsge.dataprovider.providers.base.IDataProvider;

interface IAssetProxy {
	public function check(data:IDataProvider):Bool;
	public function create(data:IDataProvider):Array<IAsset>;
}
