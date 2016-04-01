package hxsge.dataprovider.providers.base;

import hxsge.dataprovider.data.DataProviderInfo;
interface IDataProviderProxy {
	public var type(default, null):String;

	public function check(info:DataProviderInfo):Bool;
	public function create(info:DataProviderInfo):IDataProvider;
}
