package hxsge.loaders.data;

#if js
import js.html.FileReader;
import js.html.File;
import js.html.ProgressEvent;
import haxe.io.Bytes;
import js.html.Uint8Array;
import hxsge.loaders.base.BaseLoader;

class JsFileLoader extends BaseLoader {
	var _file:File;
	var _reader:FileReader;

	public function new(file:File) {
		super("not used");

		_file = file;
	}

	override function performCleanup() {
		super.performCleanup();
	}

	override function performLoad() {
		_reader = new FileReader();
		_reader.onload = onLoaded;
		_reader.onerror = onErrored;
		_reader.onprogress = onProgress;
		_reader.readAsArrayBuffer(_file);
	}

	function onLoaded(e:Dynamic) {
		content = Bytes.ofData(new Uint8Array(untyped _reader.result).buffer);

		performComplete();
	}

	function onErrored(e:Dynamic) {
		performFail("fail load from file object");
	}

	function onProgress(e:ProgressEvent) {
		var res:Float = 0;
		if(e.lengthComputable) {
			res = e.loaded / e.total;
		}

		_progress.set(res);
	}
}
#end
