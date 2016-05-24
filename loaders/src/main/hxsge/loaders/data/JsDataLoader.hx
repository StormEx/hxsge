package hxsge.loaders.data;

#if js
import hxsge.core.utils.Json;
import hxsge.core.debug.Debug;
import js.html.ProgressEvent;
import haxe.io.Bytes;
import js.html.Uint8Array;
import hxsge.loaders.base.BaseLoader;

import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;

using hxsge.loaders.utils.LoaderTools;

//TODO need to add errors handling for remote flow
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
		_request.withCredentials = true;
		_request.send(null);
	}

	function onLoaded(e:Dynamic) {
		content = Bytes.ofData(new Uint8Array(untyped content).buffer);
		Debug.trace("=================> JS LOADED: " + (content == null));
		performComplete();
//		content = Bytes.ofData(new Uint8Array(untyped e.response).buffer);
	}

	function onErrored(e:Dynamic) {
		Debug.trace("=================> JS ERROR: " + Json.stringify(e));
	}
//
//	function createClientRequest():ClientRequest {
//		if(url.indexOf("https:") == 0) {
//			return Https.get(url, onResponseRetrieved);
//		}
//
//		return Http.get(url, onResponseRetrieved);
//	}
//
//	function onCheckLocalFileFinished(isLocal:Bool) {
//		try {
//			if(isLocal) {
//				Fs.readFile(url, onFileReaded);
//			}
//			else {
//				_buffers = [];
//				var request:ClientRequest = createClientRequest();
//			}
//		}
//		catch(e:Dynamic) {
//			performFail("Can't load data...");
//		}
//	}
//
//	function onResponseRetrieved(message:IncomingMessage) {
//		if(message != null) {
//			message.on('data', onChunkReaded);
//			message.on('end', onFileDownloaded);
//		}
//	}
//
//	function onChunkReaded(chunk:Buffer) {
//		_buffers.push(chunk);
//	}
//
//	function onFileReaded(error:Error, buffer:Buffer) {
//		if(this.isFinished()) {
//			return;
//		}
//
//		if(error != null) {
//			performFail("[" + error.name + "]" + error.message);
//
//			return;
//		}
//
//		content = Bytes.ofData(new Uint8Array(untyped buffer).buffer);
//
//		performComplete();
//	}
//
//	function onFileDownloaded() {
//		content = Bytes.ofData(new Uint8Array(untyped Buffer.concat(_buffers)).buffer);
//
//		performComplete();
//	}
}
#end
