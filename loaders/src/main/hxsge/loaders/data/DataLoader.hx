package hxsge.loaders.data;

#if flash
typedef DataLoader = FlashDataLoader;
#elseif nodejs
typedef DataLoader = NodeJsDataLoader;
#elseif js
typedef DataLoader = JsDataLoader;
#elseif java
typedef DataLoader = JavaDataLoader;
//#elseif cpp
//typedef DataLoader = CppDataLoader;
//#elseif cs
//typedef DataLoader = CsDataLoader;
#else
import haxe.io.Bytes;
import sys.io.FileInput;
import hxsge.loaders.base.BaseLoader;

class DataLoader extends BaseLoader {
	var _stream:FileInput;

	public function new(url:String) {
		super(url);
	}

	override function performLoad() {
		if(url.indexOf("http") == -1) {
			_stream = sys.io.File.read(url, true);
			content = _stream.readAll();

			performComplete();
		}
		else {
			performFail(url);
		}
	}

	function onLoaded(e:Dynamic) {
		performComplete();
	}

	function onErrored(e:Dynamic) {
		performFail(url);
	}

	function onProgress() {
	}
}
#end
