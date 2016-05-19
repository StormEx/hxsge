package hxsge.dataprovider.providers.swf.data;

import hxsge.forge.ISerializable;

class SwfMetaData implements ISerializable {
	var data(default, null):Array<SwfMetaDataItem> = [];

	public function new() {
	}
}
