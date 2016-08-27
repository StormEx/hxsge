package hxsge.assets.format.bdl.provider.data;

import hxsge.memory.Memory;
import haxe.io.Path;
import hxsge.assets.format.bdl.provider.JsonMetaBundleDataProvider;
import hxsge.assets.format.bdl.data.BundleResourceData;
import hxsge.core.debug.error.Error;
import haxe.zip.Entry;
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.dataprovider.providers.zip.ZipDataProvider;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.dataprovider.data.IDataProviderInfo;

using hxsge.core.utils.StringTools;

class ZipBundleStructure extends JsonBundleStructure {
	var _zip:ZipDataProvider;

	public function new() {
		super();
	}

	override function performLoad() {
		_zip = new ZipDataProvider(_info);
		_zip.finished.addOnce(onZipLoaded);
		_zip.load();
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(_zip);
	}

	function onZipLoaded(provider:IDataProvider) {
		if(!_zip.errors.isError) {
			var bundles:Array<Entry> = _zip.filter(~/^(.*.bundle).*/, _zip.files);
			if(bundles.length > 0) {
				_provider = new JsonMetaBundleDataProvider(new DataProviderInfo("", null, _zip.unzip(bundles[0])));
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
		var dir:String = _info.url.isNotEmpty() ? Path.directory(_info.url) : "";
		var dpi:DataProviderInfo = null;

		dir = dir.isNotEmpty() ? (dir + "/" + resourceData.name) : resourceData.name;

		for(f in _zip.files) {
			if(f.fileName == resourceData.name) {
				dpi = new DataProviderInfo(resourceData.getId(), dir, _zip.unzip(f), getMeta(resourceData.meta));

				break;
			}
		}

		return dpi;
	}
}
