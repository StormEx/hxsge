package hxsge.dataprovider.providers.common;

import hxsge.core.utils.progress.IProgress;
import hxsge.photon.Signal;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.IDisposable;
import hxsge.core.debug.error.ErrorHolder;

interface IDataProvider extends IDisposable {
	public var info(default, null):IDataProviderInfo;
	public var errors(default, null):ErrorHolder;
	public var progress(get, never):IProgress;

	public var finished(default, null):Signal1<IDataProvider>;
	public var dataProviderNeeded(default, null):Signal2<IDataProvider, String>;

	public function load():Void;
	public function clear():Void;
	public function provideRequestedDataProvider(provider:IDataProvider):Void;
}
