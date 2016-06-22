package hxsge.assets.data;

import hxsge.format.images.Image;
import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.images.ImageDataProvider;
import hxsge.dataprovider.providers.base.IDataProvider;

using hxsge.core.utils.StringTools;

class ImageAsset extends Asset {
	public var image(default, null):Image;

	var _subName:String;

	public function new(id:String, data:IDataProvider, subName:String = null) {
		super(id + (subName.isEmpty() ? "" : "/" + subName), data);

		if(Std.is(data, ImageDataProvider)) {
			var dp:ImageDataProvider = Std.instance(data, ImageDataProvider);
			Debug.assert(dp.image != null);
			image = dp.image;
		}
	}
}
