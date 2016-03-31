package hxsge.dataprovider.providers.base;

import hxsge.core.debug.error.ErrorHolder;

interface IDataProvider {
	public var info(default, null):DataProviderInfo;
	public var errors(default, null):ErrorHolder;

	public function check(info:DataProviderInfo):Bool;
}
