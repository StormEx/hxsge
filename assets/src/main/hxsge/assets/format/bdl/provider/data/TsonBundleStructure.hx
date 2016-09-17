package hxsge.assets.format.bdl.provider.data;

import hxsge.assets.format.bdl.provider.TsonMetaBundleDataProvider;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class TsonBundleStructure extends JsonBundleStructure {
	public function new() {
		super();
	}

	override function performLoad() {
		_provider = new TsonMetaBundleDataProvider(_info);
		_provider.finished.addOnce(onMetaFinished);
		_provider.load();
	}
}
