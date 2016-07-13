package hxsge.dataprovider.providers.common;

import hxsge.dataprovider.data.IDataProviderInfo;

interface IDataProviderProxy {
	public var type(default, null):String;
	public var info(get, never):String;

	public function check(info:IDataProviderInfo):Bool;
	public function create(info:IDataProviderInfo):IDataProvider;
}
