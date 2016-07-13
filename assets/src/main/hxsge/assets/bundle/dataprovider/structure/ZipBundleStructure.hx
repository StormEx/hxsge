package hxsge.assets.bundle.dataprovider.structure;

import hxsge.assets.bundle.format.bundle.BundleResourceData;
import hxsge.assets.bundle.dataprovider.meta.JsonMetaBundleDataProvider;
import hxsge.core.debug.error.Error;
import haxe.zip.Entry;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.providers.zip.ZipDataProvider;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.dataprovider.data.IDataProviderInfo;

class ZipBundleStructure extends JsonBundleStructure {
	var _zip:ZipDataProvider;

	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function performLoad() {
		_zip = new ZipDataProvider(_info);
		_zip.finished.addOnce(onZipLoaded);
		_zip.load();
	}

	function onZipLoaded(provider:IDataProvider) {
		if(!_zip.errors.isError) {
			var bundles:Array<Entry> = _zip.filter(~/^(.*.bundle).*/, _zip.files);
			if(bundles.length > 0) {
				_provider = new JsonMetaBundleDataProvider(new DataProviderInfo(null, _zip.unzip(bundles[0])));
				_provider.finished.addOnce(onMetaFinished);
				_provider.load();
			}
			else {
				errors.addError(Error.create("Can't find meta data in zip bundle..."));

				finished.emit(this);
			}
		}
		else {
			errors.addError(Error.create("Can't unzip bundle..."));

			finished.emit(this);
		}
	}

	override function getInfo(resourceData:BundleResourceData, tags:Array<String>):IDataProviderInfo {
		var dir:String = resourceData.name;
		var dpi:DataProviderInfo = null;

		for(f in _zip.files) {
			if(f.fileName == resourceData.name) {
				dpi = new DataProviderInfo(dir, _zip.unzip(f), getMeta(resourceData.meta));

				break;
			}
		}

		return dpi;
	}
}
