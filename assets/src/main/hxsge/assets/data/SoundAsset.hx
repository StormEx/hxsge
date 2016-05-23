package hxsge.assets.data;

import hxsge.format.sounds.ISound;
import hxsge.format.sounds.ISoundData;
import hxsge.dataprovider.providers.sounds.SoundDataProvider;
import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.base.IDataProvider;

class SoundAsset extends Asset {
	var _sound:ISoundData;

	public function new(id:String, data:IDataProvider) {
		super(id, data);

		if(Std.is(data, SoundDataProvider)) {
			var sdp:SoundDataProvider = Std.instance(data, SoundDataProvider);
			Debug.assert(sdp.sound != null);
			_sound = sdp.sound;
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
