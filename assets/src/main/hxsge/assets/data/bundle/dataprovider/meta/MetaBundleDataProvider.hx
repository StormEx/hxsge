package hxsge.assets.data.bundle.dataprovider.meta;

import hxsge.core.utils.progress.IProgress;
import hxsge.core.platforms.Platforms;
import hxsge.core.debug.error.Error;
import haxe.io.Bytes;
import hxsge.format.base.IReader;
import hxsge.assets.data.bundle.format.bundle.BundleReader;
import hxsge.assets.data.bundle.format.bundle.BundleData;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.BaseDataProvider;

class MetaBundleDataProvider extends BaseDataProvider {
	public var data(get, never):BundleData;

	var _reader:BundleReader;
	var _version:String;

	public function new(info:IDataProviderInfo, version:String = null) {
		super(info);

		_version = version;
	}

	override function prepareData() {
		_reader = new BundleReader(info.data);
		_reader.finished.addOnce(onDataPrepared);
		_reader.read();
	}

	function onDataPrepared(reader:IReader) {
		if(_reader.errors.isError) {
			errors.concat(_reader.errors);
		}
		else {
			check(_version);
		}

		finished.emit(this);
	}

	function check(version:String = null):Bool {
		if(data == null) {
			errors.addError(Error.create("Can't parse bundle metadata."));

			return false;
		}
		else if(!data.checkPlatform()) {
			errors.addError(Error.create("Wrong bundle platform type [" + data.platforms.toString() + "] but needed [" + Platforms.getCurrentPlatform() + "]."));

			return false;
		}
		else if(!data.checkVersion(version)) {
			errors.addError(Error.create("Required version[" + version + " greater than bundle metadata version[" + data.version + "."));

			return false;
		}

		return true;
	}

	override function calculateProgress():IProgress {
		if(_progress != null) {
			_progress.set(_reader != null ? 1 : 0);
		}

		return _progress;
	}

	inline function get_data():BundleData {
		return _reader != null ? _reader.data : null;
	}
}
