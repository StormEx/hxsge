package hxsge.dataprovider.providers.base;

import hxsge.core.IDisposable;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.core.debug.error.ErrorHolder;
import msignal.Signal;

interface IDataProvider extends IDisposable {
	public var info(default, null):DataProviderInfo;
	public var errors(default, null):ErrorHolder;

	public var finished(default, null):Signal1<IDataProvider>;

	public function load():Void;
}
