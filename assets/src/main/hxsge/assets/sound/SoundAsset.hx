package hxsge.assets.sound;

import hxsge.assets.data.Asset;
import hxsge.dataprovider.providers.swf.SwfDataProvider;
import hxsge.format.sounds.ISound;
import hxsge.format.sounds.ISoundData;
import hxsge.dataprovider.providers.sounds.SoundDataProvider;
import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.common.IDataProvider;

using hxsge.core.utils.StringTools;

class SoundAsset extends Asset {
	var _sound:ISoundData;
	var _soundName:String;

	public function new(id:String, data:IDataProvider, soundName:String = null) {
		super(id + (soundName.isEmpty() ? "" : "/" + soundName), data);

		if(Std.is(data, SoundDataProvider)) {
			var sdp:SoundDataProvider = Std.instance(data, SoundDataProvider);
			Debug.assert(sdp.sound != null);
			_sound = sdp.sound;
		}
		else if(Std.is(data, SwfDataProvider)) {
			var sdp:SwfDataProvider = Std.instance(data, SwfDataProvider);
			if(soundName.isEmpty()) {
				for(s in sdp.sounds) {
					_sound = s;

					break;
				}
			}
			else {
				_sound = sdp.sounds.get(soundName);
			}
		}
	}

	public function create(volume:Float = 1, sourceVolume:Float = 1):ISound {
		return _sound != null ? _sound.create(volume, sourceVolume) : null;
	}

	override public function dispose() {
		super.dispose();

		_sound = null;
	}
}
