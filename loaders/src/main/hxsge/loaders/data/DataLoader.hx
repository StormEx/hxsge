package hxsge.loaders.data;

#if flash
typedef DataLoader = FlashDataLoader;
#elseif js
typedef DataLoader = JsDataLoader;
#else
import hxsge.core.debug.Debug;
import hxsge.loaders.base.BaseLoader;

class DataLoader extends BaseLoader {
	public function new(url:String) {
		super(url);

		Debug.error("Can't find data loader for this platform...");
	}
}
#end
