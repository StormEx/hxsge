package hxsge.dataprovider.providers.zip;

import haxe.zip.Reader;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProvider;
import haxe.zip.Entry;

class ZipDataProvider extends DataProvider {
	public var entries(default, null):Array<Entry> = [];

	public var directories(default, null):Array<Entry> = [];
	public var files(default, null):Array<Entry> = [];

	var _reader:Reader;

	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override public function dispose() {
		super.dispose();

		entries = null;
		directories = null;
		files = null;
		_reader = null;
	}

	public function filter(ereg:EReg, ?list:Array<Entry>):Array<Entry> {
		var r:EReg = ereg;
		var res:Array<Entry> = [];

		if(list == null) {
			list = entries;
		}

		for(e in list) {
			if(r.match(e.fileName)) {
				res.push(e);
			}
		}

		return res;
	}

	override function prepareData() {
		var bytes:Bytes = _data;
		var i:BytesInput = new BytesInput(bytes);

		_reader = new Reader(i);
		entries = Lambda.array(_reader.read());
		for(e in entries) {
			if(e.fileSize == 0) {
				directories.push(e);
			}
			else {
				files.push(e);
			}
		}

		finished.emit(this);
	}

	public function unzip(entry:Entry):Bytes {
		if(entry == null) {
			return null;
		}

#if flash
		return entry.data;
#else
		return Reader.unzip(entry);
#end
	}
}
