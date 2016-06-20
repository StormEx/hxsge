package hxsge.assets.data.bundle.dataprovider.structure;

import hxsge.assets.data.bundle.dataprovider.meta.TsonMetaBundleDataProvider;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class TsonBundleStructure extends JsonBundleStructure {
	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function performLoad() {
		_provider = new TsonMetaBundleDataProvider(_info);
		_provider.finished.addOnce(onMetaFinished);
		_provider.load();
	}
}
