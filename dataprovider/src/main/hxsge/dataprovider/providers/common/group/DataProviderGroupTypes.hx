package hxsge.dataprovider.providers.common.group;

class DataProviderGroupTypes<T> {
	public var readers:Map<String, T>;

	public function new(values:Map<String, T>) {
		readers = values;
		if(values == null) {
			readers = new Map();
		}
	}

	public function add(ext:String, cls:T) {
		readers.set(ext, cls);
	}
}
