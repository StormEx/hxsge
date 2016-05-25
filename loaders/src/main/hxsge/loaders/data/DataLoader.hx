package hxsge.loaders.data;

#if flash
typedef DataLoader = FlashDataLoader;
#elseif nodejs
typedef DataLoader = NodeJsDataLoader;
#elseif js
typedef DataLoader = JsDataLoader;
#elseif java
typedef DataLoader = JavaDataLoader;
#elseif cpp
typedef DataLoader = CppDataLoader;
#elseif cs
typedef DataLoader = CsDataLoader;
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
