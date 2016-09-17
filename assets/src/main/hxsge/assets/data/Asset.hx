package hxsge.assets.data;

import hxsge.assets.data.AssetChangeType;
import hxsge.memory.Memory;
import hxsge.photon.Signal.Signal1;

class Asset implements IAsset {
	public var id(default, null):String;

	public var changed(default, null):Signal1<AssetChangeType>;

	public function new(id:String) {
		this.id = id;

		changed = new Signal1();
	}

	public function dispose() {
		Memory.dispose(changed);

		id = null;
	}

	public function instance():IAsset {
		return this;
	}

	public function clone():IAsset {
		return copyTo(new Asset(id));
	}

	function copyTo(value:Asset):Asset {
		value.id = id;

		return value;
	}
}
