package hxsge.format.sounds.common;

import hxsge.memory.IDisposable;

interface ISoundData extends IDisposable {
	public function create(volume:Float, sourceVolume:Float):ISound;
}
