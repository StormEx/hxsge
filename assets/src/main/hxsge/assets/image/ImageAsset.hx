package hxsge.assets.image;

import hxsge.core.memory.Memory;
import hxsge.assets.data.Asset;
import hxsge.format.images.common.Image;

using hxsge.core.utils.StringTools;

class ImageAsset extends Asset {
	public var image(default, null):Image;

	public function new(id:String, image:Image) {
		super(id);

		this.image = image;
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(image);
	}
}
