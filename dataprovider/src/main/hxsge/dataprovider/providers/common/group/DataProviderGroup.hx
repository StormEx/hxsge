package hxsge.dataprovider.providers.common.group;

import hxsge.core.utils.progress.IProgress;
import hxsge.core.debug.error.Error;
import haxe.io.Path;
import haxe.io.Bytes;
import hxsge.memory.Memory;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.format.common.IReader;
import hxsge.dataprovider.providers.common.DataProvider;

class DataProviderGroup<TReader:IReader> extends DataProvider {
	var _reader:TReader;
	var _readers:Map<String, Class<TReader>>;

	public function new(info:IDataProviderInfo, readers:Map<String, Class<TReader>>, parent:IDataProvider = null) {
		super(info, parent);

		_readers = readers;
		if(_readers == null) {
			_readers = new Map();
		}
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(_reader);
		_readers = null;
	}

	override public function clear() {
		super.clear();

		Memory.dispose(_reader);
	}

	override function prepareData() {
		var bytes:Bytes = _data;
		if(bytes != null) {
			_reader = Type.createInstance(
				_readers.get(Path.extension(info.url)),
				[bytes]
			);
			_reader.finished.addOnce(onDataPrepared);
			_reader.read();
		}
		else {
			errors.addError(Error.create("Can't convert data to reader's bytes..."));

			finished.emit(this);
		}
	}

	function onDataPrepared(reader:IReader) {
		if(_reader.errors.isError) {
			errors.addError(Error.create("Can't read bytes by reader..."));
		}

		prepareDataAfterRead();

		finished.emit(this);
	}

	function prepareDataAfterRead() {

	}

	override function calculateProgress():IProgress {
		if(_progress != null) {
			_progress.set(_reader != null ? 1 : 0);
		}

		return _progress;
	}
}
