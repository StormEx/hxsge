package hxsge.loaders.binary.js;

#if nodejs
import hxsge.loaders.extensions.LoaderExtension;
import haxe.io.Bytes;
import js.html.Uint8Array;
import hxsge.loaders.common.BaseLoader;

import js.node.Buffer;
import js.node.Fs;
import js.node.Http;
import js.node.Https;
import js.node.http.ClientRequest;
import js.node.http.IncomingMessage;
import js.Error;

using hxsge.loaders.extensions.LoaderExtension;

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
			Fs.access(url, Fs.R_OK, onCheckLocalFileFinished);
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

	function onCheckLocalFileFinished(error:js.Error) {
		try {
			if(error == null) {
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
