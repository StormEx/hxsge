package hxsge.loaders.binary;

#if flash
import hxsge.loaders.binary.flash.FlashDataLoader;

typedef DataLoader = FlashDataLoader;
#elseif nodejs
import hxsge.loaders.binary.js.NodeJsDataLoader;

typedef DataLoader = NodeJsDataLoader;
#elseif js
import hxsge.loaders.binary.js.JsDataLoader;

typedef DataLoader = JsDataLoader;
#elseif java
import hxsge.loaders.binary.java.JavaDataLoader;

typedef DataLoader = JavaDataLoader;
#else
import haxe.io.Bytes;
import sys.io.FileInput;
import hxsge.loaders.common.BaseLoader;

using hxsge.loaders.extensions.PathExtension;

class DataLoader extends BaseLoader {
	var _stream:FileInput;

	public function new(url:String) {
		super(url);
	}

	override function performLoad() {
		if(url.isLocalPath()) {
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
