package hxsge.assets.format.bdl.provider.data;

import hxsge.assets.data.bundle.data.BundleStructure;
import hxsge.assets.format.bdl.data.BundleResourceType;
import hxsge.assets.format.bdl.data.BundleResourceData;
import hxsge.dataprovider.data.DataProviderInfo;
import haxe.io.Path;
import hxsge.assets.format.bdl.data.BundleData;
import hxsge.dataprovider.data.IDataProviderInfo;

using hxsge.core.utils.ArrayTools;
using hxsge.core.utils.StringTools;

class BdlBundleStructure extends BundleStructure {
	public var data(default, null):BundleData;

	public function new() {
		super();
	}

	override function prepareData() {
		var tags:Array<String> = [];
		if(data != null && data.isHasResources) {
			for(d in data.dependencies) {
				dependencies.push(getDependencyUrl(d));
			}

			for(i in 0...data.resources.length) {
				for(r in data.resources[i].list) {
					switch(data.resources[i].type) {
						case BundleResourceType.ASYNCHRONOUS:
							asyncData.push(getInfo(r, data.resources[i].tags));
						default:
							syncData.push(getInfo(r, data.resources[i].tags));
					}
				}
			}
		}
	}

	function getInfo(resourceData:BundleResourceData, tags:Array<String>):IDataProviderInfo {
		var ext:String = Path.extension(resourceData.name);
		var dir:String = Path.directory(_info.url) + "/" + resourceData.name;

		return new DataProviderInfo(resourceData.getId(), dir, resourceData.data, getMeta(resourceData.meta));
	}

	function getMeta(meta:Dynamic):Dynamic {
		if(meta == null) {
			return {};
		}

		return meta;
	}
}
