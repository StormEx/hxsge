package hxsge.dataprovider.providers.bundle;

import hxsge.format.bundle.BundleData;
import hxsge.format.base.IReader;
import haxe.io.Bytes;
import hxsge.format.bundle.BundleReader;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProvider;

class BundleDataProvider extends BaseDataProvider {
	var data(get, never):BundleData;

	var _reader:BundleReader;

	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function prepareData() {
		_reader = new BundleReader(Bytes.ofData(info.data));
		_reader.finished.addOnce(onDataPrepared);
		_reader.read();
	}

	function onDataPrepared(reader:IReader) {
		if(_reader.errors.isError) {
			errors.concat(_reader.errors);
		}

		finished.emit(this);
	}

	override function calculateProgress():Float {
		return _reader != null ? 1 : 0;
	}

	inline function get_data():BundleData {
		return _reader != null ? _reader.data : null;
	}
}
