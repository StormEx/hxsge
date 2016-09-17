package hxsge.assets.data;

import hxsge.assets.data.AssetChangeType;
import hxsge.core.IClonable;
import hxsge.photon.Signal.Signal1;
import hxsge.memory.IDisposable;

interface IAsset extends IDisposable extends IClonable<IAsset> {
	public var id(default, null):String;

	public var changed(default, null):Signal1<AssetChangeType>;

	public function instance():IAsset;
}
