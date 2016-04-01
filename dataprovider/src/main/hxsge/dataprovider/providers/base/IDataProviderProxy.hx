package hxsge.dataprovider.providers.base;

import hxsge.dataprovider.data.IDataProviderInfo;

interface IDataProviderProxy {
	public var type(default, null):String;

	public function check(info:IDataProviderInfo):Bool;
	public function create(info:IDataProviderInfo):IDataProvider;
}
