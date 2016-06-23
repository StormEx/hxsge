package hxsge.assets.bundle.format.bundle;

import hxsge.forge.ISerializable;

class BundleResourceGroup implements ISerializable {
	public var type:BundleResourceType;
	public var list:Array<BundleResourceData>;
	public var tags:Array<BundleResourceTagType>;

	public function new() {
	}
}
