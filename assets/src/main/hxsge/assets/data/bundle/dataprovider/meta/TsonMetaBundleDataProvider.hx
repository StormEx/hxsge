package hxsge.assets.data.bundle.dataprovider.meta;

import hxsge.assets.data.bundle.format.bundle.TsonBundleReader;
import hxsge.dataprovider.data.IDataProviderInfo;

class TsonMetaBundleDataProvider extends MetaBundleDataProvider {
	public function new(info:IDataProviderInfo, version:String = null) {
		super(info, version);
	}

	override function prepareData() {
		_reader = new TsonBundleReader(_data);
		_reader.finished.addOnce(onDataPrepared);
		_reader.read();
	}
}
