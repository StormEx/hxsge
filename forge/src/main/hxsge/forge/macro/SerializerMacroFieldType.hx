package hxsge.forge.macro;

@:enum abstract SerializerMacroFieldType(Int) from Int to Int {
	var UNKNOWN = -1;
	var SIMPLE = 0;
	var SERIALIZABLE = 1;
}
