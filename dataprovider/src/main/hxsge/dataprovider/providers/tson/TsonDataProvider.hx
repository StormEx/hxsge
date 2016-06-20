package hxsge.dataprovider.providers.tson;

import hxsge.core.debug.error.Error;
import hxsge.format.tson.data.TsonDataReader;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import hxsge.core.memory.Memory;
import hxsge.format.tson.data.TsonData;
import hxsge.dataprovider.providers.base.DataProvider;
import hxsge.dataprovider.data.IDataProviderInfo;

class TsonDataProvider extends DataProvider {
	public var tson(default, null):TsonData;

	public function new(info:IDataProviderInfo) {
		super(info);
	}

	override public function dispose() {
		super.dispose();

		Memory.dispose(tson);
	}

	override function prepareData() {
		var bytes:Bytes = _data;
		var stream:BytesInput = new BytesInput(bytes);

		try {
			tson = TsonDataReader.read(stream);
		}
		catch(e:Dynamic) {
			errors.addError(Error.create("Can't prepare tson data...", e));
		}

		finished.emit(this);
	}
}
