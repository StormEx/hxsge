package hxsge.dataprovider.providers.swf;

#if flash
import hxsge.dataprovider.providers.common.IDataProvider;
import hxsge.core.utils.progress.IProgress;
import hxsge.core.debug.error.Error;
import hxsge.format.common.IReader;
import hxsge.format.swf.SwfReader;
import flash.display.Loader;
import hxsge.dataprovider.providers.swf.data.SwfMetaDataType;
import hxsge.core.platforms.Platforms;
import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.swf.data.SwfMetaData;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.common.DataProvider;
import hxsge.format.images.common.Image;
import hxsge.format.sounds.common.ISoundData;
import hxsge.memory.Memory;

using hxsge.core.utils.StringTools;

class SwfDataProvider extends DataProvider {
	public var images(default, null):Map<String, Image>;
	public var sounds(default, null):Map<String, ISoundData>;
//	public var videos(default, null):Array<Image> = [];

	var _meta:SwfMetaData;
	var _swfLoader:Loader;
	var _reader:SwfReader;

	public function new(info:IDataProviderInfo, parent:IDataProvider = null) {
		super(info, parent);

		images = new Map();
		sounds = new Map();

		setMeta(info.meta);
	}

	override public function clear() {
		super.clear();

		Memory.dispose(_reader);
	}

	override public function dispose() {
		super.dispose();

 		Memory.disposeIterable(images);
		Memory.disposeIterable(sounds);

		_meta = null;
		_swfLoader = null;
		Memory.dispose(_reader);
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
							images.set(d.name, img);
						}
					case SwfMetaDataType.SOUND:
						var snd:ISoundData = _reader.getSound(d.name);
						if(snd != null) {
							sounds.set(d.name, snd);
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
import hxsge.dataprovider.providers.common.DataProvider;
import hxsge.core.debug.Debug;
import hxsge.core.platforms.Platforms;
import hxsge.format.images.common.Image;
import hxsge.format.sounds.common.ISoundData;

class SwfDataProvider extends DataProvider {
	public var images(default, null):Map<String, Image>;
	public var sounds(default, null):Map<String, ISoundData>;

	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function prepareData() {
		Debug.trace("[SwfDataProvider] not implemented for " + Platforms.getCurrentPlatform() + " platform...");

		finished.emit(this);
	}
}
#end