package hxsge.assets.format.bdl.data;

import hxsge.forge.ISerializable;

class BundleResourceGroup implements ISerializable {
	public var type:BundleResourceType = BundleResourceType.REQUIRED;
	public var list:Array<BundleResourceData>;
	public var tags:Array<BundleResourceTagType>;

	public function new() {
	}
}
