package hxsge.loaders.base;

import hxsge.core.batch.Batch;

class LoadersBatch extends Batch<ILoader> {
	public function new() {
		super();
	}

	override function startHandleItem() {
		_current.finished.addOnce(onItemHandled);
		_current.load();
	}
}
