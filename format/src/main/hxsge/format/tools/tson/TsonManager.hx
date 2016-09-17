package hxsge.format.tools.tson;

import angular.Angular;
import js.JQuery;
import angular.service.Scope;

import hxsge.format.tools.tson.controllers.TsonManagerController;

class TsonManager {
	public function new() {
		Angular.module("tsonmanager", ['treeControl'])
		.controller("TsonManagerController", TsonManagerController.new);

		var jqBody = new JQuery("body");
		Angular.bootstrap(jqBody[0], ["tsonmanager"]);
	}
}
