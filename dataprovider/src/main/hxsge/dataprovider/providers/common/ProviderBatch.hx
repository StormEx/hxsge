package hxsge.dataprovider.providers.common;

import hxsge.core.batch.Batch;

class ProviderBatch extends Batch<IDataProvider> {
	public function new() {
		super();
	}

	override function startHandleItem() {
		_current.finished.addOnce(onItemHandled);
		_current.dataProviderNeeded.add(onDataNeeded);
		_current.load();
	}

	function onDataNeeded(provider:IDataProvider, info:String) {
		_current.provideRequestedDataProvider(null);
	}
}
