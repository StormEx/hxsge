package hxsge.examples.format.tson.data;

@:enum abstract TsonPropertyType(String) from String to String {
	var NODE_NAME = "node_name";
	var NODE_TYPE = "node_type";
	var STRING_VALUE = "string_value";
	var BOOL_VALUE = "bool_value";
	var NUMBER_VALUE = "number_value";
	var BINARY_VALUE = "binary_value";
}
