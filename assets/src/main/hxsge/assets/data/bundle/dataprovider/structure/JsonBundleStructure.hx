package hxsge.assets.data.bundle.dataprovider.structure;

import hxsge.assets.data.bundle.dataprovider.meta.JsonMetaBundleDataProvider;
import hxsge.assets.data.bundle.format.bundle.BundleData;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.assets.data.bundle.dataprovider.meta.MetaBundleDataProvider;
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
