package hxsge.dataprovider.providers.images;

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
			_reader.read();

			if(_reader.image == null) {
				errors.addError(Error.create("Can't read image bytes..."));
			}
		}
		else {
			errors.addError(Error.create("Can't convert data to bytes image..."));
		}

		finished.emit(this);
	}

	override function calculateProgress():Float {
		return _reader != null ? 1 : 0;
	}
}
