package hxsge.dataprovider.providers.swf;

#if flash
import hxsge.core.platforms.Platforms;
import hxsge.core.debug.Debug;
import hxsge.dataprovider.providers.swf.data.SwfMetaData;
import hxsge.core.utils.meta.Meta;
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProvider;

using hxsge.core.utils.StringTools;

class SwfDataProvider extends DataProvider {
	var _meta:Meta<SwfMetaData>;

	public function new(info:IDataProviderInfo) {
		super(info);

		setMeta(info.meta);
	}

	public function setMeta(meta:String) {
		if(meta.isNotEmpty()) {
			_meta = Meta.parse(meta, SwfMetaData);
		}
		else {
			_meta = new Meta(new SwfMetaData());
		}
	}

	override function prepareData() {
		finished.emit(this);
	}
}
#else
import hxsge.dataprovider.data.IDataProviderInfo;
import hxsge.dataprovider.providers.base.DataProvider;
import hxsge.core.debug.Debug;
import hxsge.core.platforms.Platforms;

class SwfDataProvider extends DataProvider {
	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override function prepareData() {
		Debug.trace("[SwfDataProvider] not implemented for " + Platforms.getCurrentPlatform() + " platform...");

		finished.emit(this);
	}
}
#end