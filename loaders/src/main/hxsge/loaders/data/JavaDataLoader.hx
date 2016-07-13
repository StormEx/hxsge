package hxsge.loaders.data;

#if java
//import hxsge.loaders.base.BaseLoader;
//
//typedef JavaDataLoader = BaseLoader;
import haxe.io.Bytes;
import sys.io.FileInput;
import hxsge.loaders.base.BaseLoader;
import java.io.NativeInput;
import java.StdTypes;

class JavaDataLoader extends BaseLoader {
	var _stream:FileInput;
//	var _stream:java.io.NativeInput

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
