package hxsge.format.sounds;

interface ISoundData {
	public function create(volume:Float, sourceVolume:Float):ISound;
	public function remove(sound:ISound):Void;
}
