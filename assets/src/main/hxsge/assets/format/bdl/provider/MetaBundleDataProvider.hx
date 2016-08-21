package hxsge.assets.format.bdl.provider;

import hxsge.core.memory.Memory;
import hxsge.core.utils.progress.IProgress;
import hxsge.core.platforms.Platforms;
import hxsge.core.debug.error.Error;
import hxsge.format.common.IReader;
import hxsge.assets.format.bdl.data.BundleData;
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

	override public function dispose() {
		super.dispose();

		Memory.dispose(_reader);
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
