package hxsge.loaders.binary.js;

#if js
import js.html.ProgressEvent;
import haxe.io.Bytes;
import js.html.Uint8Array;
import hxsge.loaders.common.BaseLoader;

import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;

class JsDataLoader extends BaseLoader {
	var _request:XMLHttpRequest;

	public function new(url:String) {
		super(url);
	}

	override function performCleanup() {
		super.performCleanup();
	}

	override function performLoad() {
		_request = new XMLHttpRequest();
		_request.open("GET", url, true);
		_request.responseType = XMLHttpRequestResponseType.ARRAYBUFFER;
		_request.onload = onLoaded;
		_request.onerror = onErrored;
		_request.onprogress = onProgress;
		_request.send(null);
	}

	function onLoaded(e:Dynamic) {
		content = Bytes.ofData(new Uint8Array(untyped _request.response).buffer);

		performComplete();
	}

	function onErrored(e:Dynamic) {
		performFail(url);
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
