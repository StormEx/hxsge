package hxsge.dataprovider.providers.common.group;

import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.common.IDataProvider;
import haxe.io.Path;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.common.DataProviderProxy;

class DataProviderGroupProxy<TType> extends DataProviderProxy{
	var _types:DataProviderGroupTypes<TType>;

	function new(type:String, values:Map<String, TType>) {
		super(type);

		_types = Type.createInstance(DataProviderGroupTypes, [values]);
	}

	override public function check(info:IDataProviderInfo):Bool {
		Debug.assert(info != null);

		var ext:String = Path.extension(info.url);

		return _types.readers.exists(ext);
	}

	override public function create(info:IDataProviderInfo, parent:IDataProvider = null):IDataProvider {
		Debug.error("need to override");

		return null;
	}

	override function get_info():String {
		var types:Array<String> = [];

		for(k in _types.readers.keys()) {
			types.push(k);
		}

		return type + "[" + types.join(", ") + "]";
	}
}
