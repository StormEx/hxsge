package hxsge.examples.format.tson.data;

import hxsge.core.memory.Memory;
import hxsge.core.IDisposable;
import hxsge.photon.Signal;

using hxsge.core.utils.ArrayTools;

class TsonPropertyGroup implements IDisposable {
	public var name:String = "default";
	public var properties:Array<TsonProperty> = [];

	public var changed(default, null):Signal2<TsonPropertyGroup, TsonProperty>;

	public function new(name:String) {
		this.name = name;

		changed = new Signal2();
	}

	public function dispose() {
		Memory.disposeIterable(properties);
		Memory.dispose(changed);
	}

	public function add(property:TsonProperty) {
		if(property != null) {
			properties.push(property);
			property.changed.add(onPropertyChanged);
			property.updated.add(onPropertyUpdated);
		}
	}

	inline public function getDescription():String {
		return "no description...";
	}

	inline public function toString():String {
		return name + ": " + getDescription();
	}

	inline public function isEmpty():Bool {
		return properties.isEmpty();
	}

	function onPropertyChanged(prop:TsonProperty) {
		changed.emit(this, prop);
	}

	function onPropertyUpdated(prop:TsonProperty) {
		changed.emit(this, prop);
	}
}
