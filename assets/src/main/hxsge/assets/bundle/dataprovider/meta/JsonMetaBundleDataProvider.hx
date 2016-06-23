package hxsge.assets.bundle.dataprovider.meta;

import hxsge.assets.bundle.format.bundle.JsonBundleReader;
import hxsge.dataprovider.data.IDataProviderInfo;

class JsonMetaBundleDataProvider extends MetaBundleDataProvider {
	public function new(info:IDataProviderInfo, version:String = null) {
		super(info, version);
	}

	override function prepareData() {
		_reader = new JsonBundleReader(_data);
		_reader.finished.addOnce(onDataPrepared);
		_reader.read();
	}
}
