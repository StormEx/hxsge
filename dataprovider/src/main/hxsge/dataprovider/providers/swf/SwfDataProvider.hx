package hxsge.dataprovider.providers.swf;

import hxsge.core.utils.meta.Meta;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProvider;

using hxsge.core.utils.StringTools;

class SwfDataProvider extends DataProvider {
	var _meta:Meta<SwfMetaData>;

	public function new(info:IDataProviderInfo) {
		super(info);

		if(info.meta.isNotEmpty()) {
			_meta = Meta.parse(info.meta, SwfMetaData);
		}
		else {
			_meta = new Meta(new SwfMetaData());
		}
	}

	override function prepareData() {
		finished.emit(this);
	}
}
