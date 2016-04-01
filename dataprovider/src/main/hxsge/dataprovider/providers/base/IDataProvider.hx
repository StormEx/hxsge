package hxsge.dataprovider.providers.base;

import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.core.batch.IBatchable;
import hxsge.core.debug.error.ErrorHolder;

interface IDataProvider extends IBatchable {
	public var info(default, null):DataProviderInfo;
	public var errors(default, null):ErrorHolder;
}
