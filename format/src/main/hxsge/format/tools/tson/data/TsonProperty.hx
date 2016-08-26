package hxsge.format.tools.tson.data;

import hxsge.memory.Memory;
import hxsge.photon.Signal;

using hxsge.core.utils.ArrayTools;
using hxsge.core.math.MathFloatTools;

class TsonProperty {
	public var type:TsonPropertyType;
	public var dataType:TsonPropertyDataType;
	public var name:String;
	public var info:String;
	public var readOnly:Bool;
	public var data:Dynamic;

	public var options:Array<TsonPropertyDataType> = [];
	public var optionsMap:Map<TsonPropertyDataType, String>;

	public var number:Float = 0;

	public var changed(default, null):Signal1<TsonProperty>;
	public var updated(default, null):Signal1<TsonProperty>;
	public var loadSpawned(default, null):Signal1<TsonProperty>;

	public function new(type:TsonPropertyType, name:String = "", data:Dynamic = null, readOnly:Bool = false) {
		this.name = name;
		this.type = type;
		this.data = data;
		this.readOnly = readOnly;

		prepareData();

		changed = new Signal1();
		updated = new Signal1();
		loadSpawned = new Signal1();
	}

	public function dispose() {
		Memory.dispose(changed);
		Memory.dispose(updated);
		Memory.dispose(loadSpawned);
	}

	public function update() {
		updated.emit(this);
	}

	public function changeOption(option:String) {
		if(option == info) {
			return;
		}

		info = option;
		switch(type) {
			case TsonPropertyType.NODE_TYPE:
				data = option;
			case TsonPropertyType.BOOL_VALUE:
				data = (option == "true" ? true : false);
			default:
		}

		prepareData();

		changed.emit(this);
	}

	public function setOptions(values:Map<String, String>) {
		options = [];
		for(v in values.keys()) {
			options.push(v);
		}
		optionsMap = values;
	}

	public function loadFile() {
		loadSpawned.emit(this);
	}

	function prepareData() {
		switch(type) {
			case TsonPropertyType.NODE_NAME:
				dataType = TsonPropertyDataType.STRING;
				info = data;
			case TsonPropertyType.NODE_TYPE:
				dataType = TsonPropertyDataType.OPTIONS;
				info = data;
			case TsonPropertyType.BOOL_VALUE:
				dataType = TsonPropertyDataType.OPTIONS;
				info = Std.string(data);
			case TsonPropertyType.NUMBER_VALUE:
				dataType = TsonPropertyDataType.NUMBER;
				number = data;
				info = Std.string(data);
			case TsonPropertyType.BINARY_VALUE:
				dataType = TsonPropertyDataType.BINARY;
				info = "[binary - " + (data == null ? "empty" : (data.length == 0 ? "empty" : ((data.length / 1024.0).format(2) + " kB"))) + "]";
			default:
				dataType = TsonPropertyDataType.STRING;
				info = data;
		}
	}
}
