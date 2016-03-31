package hxsge.dataprovider;

import hxsge.core.log.Log;
import hxsge.dataprovider.providers.base.IDataProviderProxy;
import hxsge.dataprovider.providers.base.IDataProvider;

class DataProviderManager {
	static var _proxies:Array<IDataProviderProxy> = [];

	public static function add(proxy:IDataProviderProxy) {
		for(p in _proxies) {
			if(p.type == proxy.type) {
				Log.log("try to register proxie duplicate: " + proxy.type);

				return;
			}
		}

		_proxies.push(proxy);
		Log.log("registered proxy for provider: " + proxy.type);
	}

	public static function get(info:DataProviderInfo):IDataProvider {
		for(p in _proxies) {
			if(p.check(info)) {
				return p.create(info);
			}
		}

		return null;
	}

	function new() {
	}
}
