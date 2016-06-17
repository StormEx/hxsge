package hxsge.format.tools.bundle;

import hxsge.format.tools.bundle.controllers.BundleManagerController;
import angular.Angular;
import js.JQuery;
import angular.service.Scope;

class BundleManager {
	public function new() {
		Angular.module("bundlemanager", [])
		.controller("BundleManagerController", BundleManagerController.new);

		var jqBody = new JQuery("body");
		Angular.bootstrap(jqBody[0], ["bundlemanager"]);
	}
}
