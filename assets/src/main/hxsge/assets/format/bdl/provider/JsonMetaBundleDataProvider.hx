package hxsge.assets.format.bdl.provider;

import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class JsonMetaBundleDataProvider extends MetaBundleDataProvider {
	public function new(info:IDataProviderInfo, version:String = null, parent:IDataProvider = null) {
		super(info, version, parent);
	}

	override function prepareData() {
		_reader = new JsonBundleReader(_data);
		_reader.finished.addOnce(onDataPrepared);
		_reader.read();
	}
}
