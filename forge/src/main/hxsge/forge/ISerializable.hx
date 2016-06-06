package hxsge.forge;

import hxsge.io.object.IObjectInput;

#if !macro
@:autoBuild(hxsge.forge.macro.SerializerMacro.build())
#end

interface ISerializable {
//	public function serialize<T>(cls:Class<T>, ?type:String):T;
	public function serialize(type:String):Dynamic;
//	public function deserialize(data:Dynamic, ?type:String):Void;
	public function deserialize(data:Dynamic, objectInput:IObjectInput = null):Void;
}