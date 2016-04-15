package hxsge.assets.data.bundle.dataprovider.structure;

import hxsge.assets.data.bundle.format.bundle.BundleResourceType;
import haxe.io.Path;
import hxsge.dataprovider.data.DataProviderInfo;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.core.memory.Memory;
import hxsge.core.IDisposable;
import hxsge.core.debug.error.ErrorHolder;
import hxsge.core.signal.Signal.Signal1;
import hxsge.assets.data.bundle.dataprovider.meta.MetaBundleDataProvider;
import hxsge.assets.data.bundle.format.bundle.BundleData;
import hxsge.dataprovider.data.IDataProviderInfo;

using hxsge.core.utils.ArrayTools;

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
				var type:BundleResourceType = data.resources[i].type;
				var list:Array<String> = data.resources[i].list;
				tags = data.resources[i].tags;
				for(r in list) {
					switch(type) {
						case BundleResourceType.ASYNCHRONOUS:
							asyncData.push(getInfo(r, tags));
						default:
							syncData.push(getInfo(r, tags));
					}
				}
			}
		}
	}

	function getDependencyUrl(name:String):String {
		return Path.normalize(Path.directory(_info.url) + "/" + name + "/meta.bundle");
	}

	function getInfo(name:String, tags:Array<String>):IDataProviderInfo {
		var ext:String = Path.extension(name);
		var dir:String = Path.directory(_info.url) + "/" + name;

		return new DataProviderInfo(dir, null, getMeta(tags));
	}

	function getMeta(tags:Array<String>):String {
		if(tags.isEmpty()) {
			return "";
		}

		if(tags.indexOf("loop") != -1) {
			return '{"data":[{"name":"SoundSymbol","type":"sound"}]}';
		}
		if(tags.indexOf("video") != -1) {
			return '{"data":[{"name":"VideoSymbol","type":"video"}]}';
		}

		return "";
	}

	inline function get_data():BundleData {
		return _provider != null ? _provider.data : null;
	}
}
