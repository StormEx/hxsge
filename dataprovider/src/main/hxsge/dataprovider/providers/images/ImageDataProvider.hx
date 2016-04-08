package hxsge.dataprovider.providers.images;

import hxsge.format.base.IReader;
import haxe.io.Path;
import hxsge.core.debug.error.Error;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import hxsge.format.images.ImageReader;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProvider;

class ImageDataProvider extends BaseDataProvider {
	var _reader:ImageReader;

	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function prepareData() {
		var bytes:Bytes = Bytes.ofData(info.data);
		if(bytes != null) {
			_reader = Type.createInstance(
				ImageDataProviderTypes.readers.get(Path.extension(info.url)),
				[new BytesInput(bytes, 0, bytes.length)]
			);
			_reader.finished.addOnce(onDataPrepared);
			_reader.read();
		}
		else {
			errors.addError(Error.create("Can't convert data to bytes image..."));

			finished.emit(this);
		}
	}

	function onDataPrepared(reader:IReader) {
		if(_reader.errors.isError) {
			errors.addError(Error.create("Can't read image bytes..."));
		}

		finished.emit(this);
	}

	override function calculateProgress():Float {
		return _reader != null ? 1 : 0;
	}
}
