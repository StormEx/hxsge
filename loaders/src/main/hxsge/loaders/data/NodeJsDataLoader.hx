package hxsge.loaders.data;

#if hxnodejs
import haxe.io.Bytes;
import js.html.Uint8Array;
import hxsge.loaders.base.BaseLoader;

import js.node.Buffer;
import js.node.Fs;
import js.Error;

using hxsge.loaders.utils.LoaderTools;

class NodeJsDataLoader extends BaseLoader {
	public function new(url:String) {
		super(url);
	}

	override function performLoad() {
		try {
			Fs.readFile(url, onFileReaded);
		}
		catch(e:Dynamic) {
			performFail("Can't load data...");
		}
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
}
#end
