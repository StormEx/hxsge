package hxsge.dataprovider.providers.base;

import hxsge.core.utils.progress.IProgress;
import hxsge.core.signal.Signal;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.IDisposable;
import hxsge.core.debug.error.ErrorHolder;

interface IDataProvider extends IDisposable {
	public var info(default, null):IDataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var progress(get, never):IProgress;

	public var finished(default, null):Signal1<IDataProvider>;
	public var dataNeeded(default, null):Signal2<IDataProvider, IDataProviderInfo>;

	public function load():Void;
	public function provideRequestedData(provider:IDataProvider):Void;
}
