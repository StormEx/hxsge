package hxsge.dataprovider.providers.common;

import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.batch.Batch;

class ProviderBatch extends Batch<IDataProvider> {
	public function new() {
		super();
	}

	override function startHandleItem() {
		_current.finished.addOnce(onItemHandled);
		_current.dataNeeded.add(onDataNeeded);
		_current.load();
	}

	function onDataNeeded(provider:IDataProvider, info:IDataProviderInfo) {
		_current.provideRequestedData(null);
	}
}
