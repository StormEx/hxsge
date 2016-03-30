package hxsge.dataprovider;

import hxsge.dataprovider.providers.base.IDataProviderProxy;
import hxsge.dataprovider.providers.base.IDataProvider;

class DataProviderManager {
	static var _proxies:Array<IDataProviderProxy> = [];

	public static function add(proxy:IDataProviderProxy) {
		for(p in _proxies) {
			if(p.type == proxy.type) {
				trace("try to register proxie duplicate: " + proxy.type);

				return;
			}
		}

		_proxies.push(proxy);
		trace("registered proxy for provider: " + proxy.type);
	}

	public function new() {
	}

	public function get(info:DataProviderInfo):IDataProvider {
		for(p in _proxies) {
			if(p.check(info)) {
				return p.create(info);
			}
		}

		return null;
	}
}
