package hxsge.loaders.extensions;

import hxsge.loaders.base.ILoader;
import hxsge.core.debug.Debug;
import hxsge.loaders.base.LoaderStateType;

class LoaderExtension {
	inline public static function isLoading(l:ILoader):Bool {
		return l != null && l.state == LoaderStateType.LOADING;
	}

	inline public static function isSuccess(l:ILoader):Bool {
		return l != null && l.state == LoaderStateType.SUCCESS;
	}

	inline public static function isStated(l:ILoader):Bool {
		return l != null && l.state != LoaderStateType.NONE;
	}

	inline public static function isFinished(l:ILoader):Bool {
		return l != null && l.state != LoaderStateType.NONE && l.state != LoaderStateType.LOADING;
	}

	inline public static function getContent<T>(l:ILoader, type:Class<T>):T {
		if(l == null) {
			return null;
		}

		if(!Std.is(l.content, type)) {
			Debug.trace('Loader with url="${l.url}" has ${Type.getClass(l.content)}, but $type requested.');

			return null;
		}

		return cast l.content;
	}
}
