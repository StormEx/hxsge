package hxsge.dataprovider.providers.base;

import hxsge.core.batch.Batch;

class ProviderBatch extends Batch<IDataProvider> {
	public function new() {
		super();
	}

	override function startHandleItem() {
		_current.finished.addOnce(onItemHandled);
		_current.load();
	}
}
