package hxsge.assets.format.bdl.provider.data;

import hxsge.assets.format.bdl.provider.JsonMetaBundleDataProvider;
import hxsge.assets.format.bdl.provider.MetaBundleDataProvider;
import hxsge.assets.format.bdl.data.BundleData;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class JsonBundleStructure extends BdlBundleStructure {
	public function new() {
		super();
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
