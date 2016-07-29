package hxsge.assets.data.bundle;

import hxsge.core.batch.Batch;

class BundleBatch extends Batch<Bundle> {
	public function new() {
		super();
	}

	override function startHandleItem() {
		_current.finished.addOnce(onItemHandled);
		_current.load();
	}
}
