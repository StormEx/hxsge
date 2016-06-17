package hxsge.format.tools.bundle.controllers;

import hxsge.core.debug.Debug;
import js.JQuery.JqEvent;
import js.JQuery;
import angular.service.Scope;
import js.Browser;
import js.html.InputElement;

class BundleManagerController {
	var _scope:Scope;

	public function new(scope:Scope) {
		_scope = scope;

		Debug.trace("bundle controller");
	}
}
