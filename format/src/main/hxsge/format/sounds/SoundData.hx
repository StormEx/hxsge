package hxsge.format.sounds;

class SoundData implements ISound {
	public var data(default, null):SoundImpl;

	public function new(data:SoundImpl) {
		this.data = data;
	}

	public function dispose() {
#if flash
		data.close();
#elseif js
#end
		data = null;
	}
}
