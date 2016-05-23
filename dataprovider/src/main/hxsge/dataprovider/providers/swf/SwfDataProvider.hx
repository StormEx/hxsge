package hxsge.dataprovider.providers.swf;

#if flash
import hxsge.core.utils.progress.IProgress;
import hxsge.core.debug.error.Error;
import hxsge.format.base.IReader;
import hxsge.format.swf.SwfReader;
import hxsge.format.sounds.Sound;
import hxsge.format.images.Image;
import flash.display.Loader;
import hxsge.dataprovider.providers.base.IDataProvider;
import hxsge.dataprovider.providers.swf.data.SwfMetaDataType;
import hxsge.core.platforms.Platforms;
import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.swf.data.SwfMetaData;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProvider;

using hxsge.core.utils.StringTools;

class SwfDataProvider extends DataProvider {
	public var images(default, null):Array<Image> = [];
	public var sounds(default, null):Array<Sound> = [];
//	public var videos(default, null):Array<Image> = [];

	var _meta:SwfMetaData;
	var _swfLoader:Loader;
	var _reader:SwfReader;

	public function new(info:IDataProviderInfo) {
		super(info);

		setMeta(info.meta);
	}

	public function setMeta(meta:Dynamic) {
		_meta = new SwfMetaData();
		_meta.deserialize(meta);
	}

	override function prepareData() {
		if(_reader == null) {
			_reader = new SwfReader(_data);
			_reader.finished.addOnce(onDataPrepared);
			_reader.read();
		}
		else {
			finished.emit(this);
		}
	}

	function onDataPrepared(reader:IReader) {
		if(_reader.errors.isError) {
			errors.addError(Error.create("Can't read bytes by reader..."));
		}
		else {
			for(d in _meta.data) {
				switch(d.type) {
					case SwfMetaDataType.IMAGE:
						var img:Image = _reader.getImage(d.name);
						if(img != null) {
							images.push(img);
						}
					case SwfMetaDataType.SOUND:
						var snd:Sound = _reader.getSound(d.name);
						if(snd != null) {
							sounds.push(snd);
						}
					case SwfMetaDataType.VIDEO:
					default:
				}
			}
		}

		finished.emit(this);
	}

	override function calculateProgress():IProgress {
		if(_progress != null) {
			_progress.set(_reader != null ? 1 : 0);
		}

		return _progress;
	}
}
#else
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProvider;
import hxsge.core.debug.Debug;
import hxsge.core.platforms.Platforms;

class SwfDataProvider extends DataProvider {
	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function prepareData() {
		Debug.trace("[SwfDataProvider] not implemented for " + Platforms.getCurrentPlatform() + " platform...");

		finished.emit(this);
	}
}
#end