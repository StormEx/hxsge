package hxsge.loaders.utils;

import hxsge.loaders.base.LoaderStateType;
import hxsge.loaders.base.ILoader;

class LoaderTools {
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
}
