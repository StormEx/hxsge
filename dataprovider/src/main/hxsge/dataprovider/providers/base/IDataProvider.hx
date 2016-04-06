package hxsge.dataprovider.providers.base;

import hxsge.core.signal.Signal2;
import hxsge.core.signal.Signal1;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.IDisposable;
import hxsge.core.debug.error.ErrorHolder;

interface IDataProvider extends IDisposable {
	public var info(default, null):IDataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var progress(get, never):Float;

	public var finished(default, null):Signal1<IDataProvider>;
	public var dataNeeded(default, null):Signal2<IDataProvider, IDataProviderInfo>;

	public function load():Void;
	public function provideRequestedData(provider:IDataProvider):Void;
}
