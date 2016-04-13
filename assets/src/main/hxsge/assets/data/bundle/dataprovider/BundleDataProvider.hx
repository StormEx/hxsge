package hxsge.assets.data.bundle.dataprovider;

import haxe.io.Path;
import hxsge.assets.data.bundle.format.bundle.BundleData;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProvider;

class BundleDataProvider extends BaseDataProvider {
	public var data(get, never):BundleData;

	var _structure:BundleStructure;

	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function prepareData() {
		if(Path.extension(info.url) == "zip") {
			_structure = new ZipBundleStructure(info);
		}
		else {
			_structure = new BundleStructure(info);
		}
		_structure.finished.addOnce(onDataPrepared);
		_structure.load();
	}

	function onDataPrepared(structure:BundleStructure) {
		if(_structure.errors.isError) {
			errors.concat(_structure.errors);
		}

		finished.emit(this);
	}

	override function calculateProgress():Float {
		return _structure != null ? 1 : 0;
	}

	inline function get_data():BundleData {
		return _structure != null ? _structure.data : null;
	}
}
