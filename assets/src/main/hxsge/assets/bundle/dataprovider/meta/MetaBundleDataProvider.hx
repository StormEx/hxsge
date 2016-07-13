package hxsge.assets.bundle.dataprovider.meta;

import hxsge.core.utils.progress.IProgress;
import hxsge.core.platforms.Platforms;
import hxsge.core.debug.error.Error;
import hxsge.format.common.IReader;
import hxsge.assets.bundle.format.bundle.BundleReader;
import hxsge.assets.bundle.format.bundle.BundleData;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.common.DataProvider;

class MetaBundleDataProvider extends DataProvider {
	public var data(get, never):BundleData;

	var _reader:BundleReader;
	var _version:String;

	public function new(info:IDataProviderInfo, version:String = null) {
		super(info);

		_version = version;
	}

	override function prepareData() {
		throw "need to override...";
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
