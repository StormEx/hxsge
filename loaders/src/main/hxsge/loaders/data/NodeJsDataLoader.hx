package hxsge.loaders.data;

#if hxnodejs
import haxe.io.Bytes;
import js.html.Uint8Array;
import hxsge.loaders.base.BaseLoader;

import js.node.Buffer;
import js.node.Fs;
import js.node.Http;
import js.node.Https;
import js.node.http.ClientRequest;
import js.node.http.IncomingMessage;
import js.Error;

using hxsge.loaders.utils.LoaderTools;

//TODO need to add errors handling for remote flow
class NodeJsDataLoader extends BaseLoader {
	var _buffers:Array<Buffer> = [];

	public function new(url:String) {
		super(url);
	}

	override function performCleanup() {
		super.performCleanup();

		_buffers = null;
	}

	override function performLoad() {
		try {
			Fs.exists(url, onCheckLocalFileFinished);
		}
		catch(e:Dynamic) {
			performFail("Can't load data...");
		}
	}

	function createClientRequest():ClientRequest {
		if(url.indexOf("https:") == 0) {
			return Https.get(url, onResponseRetrieved);
		}

		return Http.get(url, onResponseRetrieved);
	}

	function onCheckLocalFileFinished(isLocal:Bool) {
		try {
			if(isLocal) {
				Fs.readFile(url, onFileReaded);
			}
			else {
				_buffers = [];
				var request:ClientRequest = createClientRequest();
			}
		}
		catch(e:Dynamic) {
			performFail("Can't load data...");
		}
	}

	function onResponseRetrieved(message:IncomingMessage) {
		if(message != null) {
			message.on('data', onChunkReaded);
			message.on('end', onFileDownloaded);
		}
	}

	function onChunkReaded(chunk:Buffer) {
		_buffers.push(chunk);
	}

	function onFileReaded(error:Error, buffer:Buffer) {
		if(this.isFinished()) {
			return;
		}

		if(error != null) {
			performFail("[" + error.name + "]" + error.message);

			return;
		}

		content = Bytes.ofData(new Uint8Array(untyped buffer).buffer);

		performComplete();
	}

	function onFileDownloaded() {
		content = Bytes.ofData(new Uint8Array(untyped Buffer.concat(_buffers)).buffer);

		performComplete();
	}
}
#end
