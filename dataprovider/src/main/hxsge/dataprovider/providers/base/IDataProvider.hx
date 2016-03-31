package hxsge.dataprovider.providers.base;

import hxsge.core.IDisposable;
import hxsge.core.debug.error.ErrorHolder;

interface IDataProvider extends IDisposable {
	public var info(default, null):DataProviderInfo;
	public var errors(default, null):ErrorHolder;

	public function check(info:DataProviderInfo):Bool;
}
