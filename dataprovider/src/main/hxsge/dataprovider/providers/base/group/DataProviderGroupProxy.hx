package hxsge.dataprovider.providers.base.group;

import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.base.IDataProvider;
import haxe.io.Path;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProviderProxy;

class DataProviderGroupProxy<TType> extends BaseDataProviderProxy{
	var _types:DataProviderGroupTypes<TType>;

	function new(type:String, values:Map<String, TType>) {
		super(type);

		_types = Type.createInstance(DataProviderGroupTypes, [values]);
	}

	override public function check(info:IDataProviderInfo):Bool {
		var ext:String = Path.extension(info.url);

		return _types.readers.exists(ext);
	}

	override public function create(info:IDataProviderInfo):IDataProvider {
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
