package hxsge.dataprovider;

import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.core.log.Log;
import hxsge.dataprovider.providers.common.IDataProviderProxy;
import hxsge.dataprovider.providers.common.IDataProvider;

class DataProviderManager {
	static var _proxies:Array<IDataProviderProxy> = [];

	public static function add(proxy:IDataProviderProxy) {
		for(p in _proxies) {
			if(p.type == proxy.type) {
				Log.log("try to register proxie duplicate: " + proxy.info);

				return;
			}
		}

		_proxies.push(proxy);
		Log.log("registered proxy for provider: " + proxy.info);
	}

	public static function get(info:IDataProviderInfo, parent:IDataProvider = null):IDataProvider {
		for(p in _proxies) {
			if(p.check(info)) {
				return p.create(info, parent);
			}
		}

		return null;
	}

	function new() {
	}
}
