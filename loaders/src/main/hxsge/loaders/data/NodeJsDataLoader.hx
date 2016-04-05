package hxsge.loaders.data;

#if hxnode
import hxsge.loaders.base.BaseLoader;

import js.node.Buffer;
import js.node.Fs;
import js.Error;

class NodeJsDataLoader extends BaseLoader {
	public function new(url:String) {
		super(url);
	}

	override function performLoad() {
		try {
			Fs.readFile(url, onFileReaded);
		}
		catch(e) {
			performFail("Can't load data...");
		}
	}

	function onFileReaded(err:Error, buffer:Buffer) {
		if(isCanceled) {
			return;
		}

		if(err != null) {
			performFail("[" + err.name + "]" + err.message);

			return;
		}

		content = buffer.buffer;

		performComplete();
	}
}
#end
