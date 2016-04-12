package hxsge.dataprovider.providers.base.group;

import hxsge.core.debug.error.Error;
import haxe.io.Path;
import haxe.io.Bytes;
import hxsge.core.memory.Memory;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.format.base.IReader;
import hxsge.dataprovider.providers.base.BaseDataProvider;

class DataProviderGroup<TReader:IReader> extends BaseDataProvider {
	var _reader:TReader;
	var _readers:Map<String, Class<TReader>>;

	public function new(info:IDataProviderInfo, readers:Map<String, Class<TReader>>) {
		super(info);

		_readers = readers;
		if(_readers == null) {
			_readers = new Map();
		}
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(_reader);
	}

	override function prepareData() {
		var bytes:Bytes = Bytes.ofData(info.data);
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

		finished.emit(this);
	}

	override function calculateProgress():Float {
		return _reader != null ? 1 : 0;
	}
}
