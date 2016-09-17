package hxsge.memory;

#if !macro
@:autoBuild(hxsge.memory.macro.DisposableMacro.build())
#end

interface IDisposable {
	public function dispose():Void;
}


class DisposableStats {
	public static var instances:Map<IDisposable, Bool> = new Map();
}