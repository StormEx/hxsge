package hxsge.dataprovider.providers.swf.data;

import hxsge.forge.ISerializable;

class SwfMetaDataItem implements ISerializable {
	public var name(default, null):String;
	public var type(default, null):SwfMetaDataType;

	public function new() {
	}
}
