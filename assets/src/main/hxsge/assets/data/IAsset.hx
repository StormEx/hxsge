package hxsge.assets.data;

import hxsge.photon.Signal.Signal1;
import hxsge.core.IDisposable;

interface IAsset extends IDisposable {
	public var id(default, null):String;

	public var changed(default, null):Signal1<AssetChangeType>;
}
