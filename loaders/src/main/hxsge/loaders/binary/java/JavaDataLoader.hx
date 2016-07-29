package hxsge.loaders.binary.java;

#if java
import haxe.io.Bytes;
import sys.io.FileInput;
import hxsge.loaders.common.BaseLoader;

using hxsge.loaders.extensions.PathExtension;

class JavaDataLoader extends BaseLoader {
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
