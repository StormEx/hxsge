package hxsge.assets.data.bundle.dataprovider.structure;

import hxsge.assets.data.bundle.format.bundle.BundleResourceData;
import hxsge.assets.data.bundle.format.bundle.BundleResourceType;
import haxe.io.Path;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.core.memory.Memory;
import hxsge.core.IDisposable;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.photon.Signal;
import hxsge.assets.data.bundle.dataprovider.meta.MetaBundleDataProvider;
import hxsge.assets.data.bundle.format.bundle.BundleData;
import hxsge.dataprovider.data.IDataProviderInfo;

using hxsge.core.utils.ArrayTools;
using hxsge.core.utils.StringTools;

class BundleStructure implements IDisposable {
	public var data(get, never):BundleData;
	public var errors(default, null):ErrorHolder;

	public var dependencies(default, null):Array<String> = [];
	public var syncData(default, null):Array<IDataProviderInfo> = [];
	public var asyncData(default, null):Array<IDataProviderInfo> = [];

	public var finished(default, null):Signal1<BundleStructure>;

	var _info:IDataProviderInfo;
	var _provider:MetaBundleDataProvider;

	public function new(info:IDataProviderInfo) {
		_info = info;

		errors = new ErrorHolder();
		finished = new Signal1();
	}

	public function dispose() {
		Memory.dispose(finished);

		errors = null;
	}

	public function load() {
		if(_provider == null) {
			performLoad();
		}
		else {
			if(_provider.progress.isFinished) {
				finished.emit(this);
			}
		}
	}

	function performLoad() {
		_provider = new MetaBundleDataProvider(_info);
		_provider.finished.addOnce(onMetaFinished);
		_provider.load();
	}

	function onMetaFinished(provider:IDataProvider) {
		if(!provider.errors.isError) {
			prepareData();
		}

		finished.emit(this);
	}

	function prepareData() {
		var tags:Array<String> = [];
		if(data != null && data.isHasResources) {
			for(d in data.dependencies) {
				dependencies.push(getDependencyUrl(d));
			}

			for(i in 0...data.resources.length) {
				for(r in data.resources[i].list) {
					switch(data.resources[i].type) {
						case BundleResourceType.ASYNCHRONOUS:
							asyncData.push(getInfo(r.name, data.resources[i].tags, r.meta));
						default:
							syncData.push(getInfo(r.name, data.resources[i].tags, r.meta));
					}
				}
			}
		}
	}

	function getDependencyUrl(name:String):String {
		return Path.normalize(Path.directory(_info.url) + "/" + name + "/meta.bundle");
	}

	function getInfo(name:String, tags:Array<String>, meta:Dynamic):IDataProviderInfo {
		var ext:String = Path.extension(name);
		var dir:String = Path.directory(_info.url) + "/" + name;

		return new DataProviderInfo(dir, null, getMeta(meta));
	}

	function getMeta(meta:Dynamic):Dynamic {
		if(meta == null) {
			return {};
		}

		return meta;
	}

	inline function get_data():BundleData {
		return _provider != null ? _provider.data : null;
	}
}
