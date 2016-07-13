package hxsge.assets.bundle.dataprovider.structure;

import hxsge.assets.bundle.dataprovider.meta.JsonMetaBundleDataProvider;
import hxsge.assets.bundle.format.bundle.BundleData;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.assets.bundle.dataprovider.meta.MetaBundleDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class JsonBundleStructure extends BundleStructure {
	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function performLoad() {
		_provider = new JsonMetaBundleDataProvider(_info);
		_provider.finished.addOnce(onMetaFinished);
		_provider.load();
	}

	function onMetaFinished(provider:IDataProvider) {
		if(!provider.errors.isError) {
			data = Std.instance(provider, MetaBundleDataProvider).data;

			prepareData();
		}

		finished.emit(this);
	}
}
