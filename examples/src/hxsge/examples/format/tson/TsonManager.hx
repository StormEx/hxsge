package hxsge.examples.format.tson;

#if nodejs
import angular.Angular;
import js.JQuery;
import js.Browser;
import angular.service.Scope;

import hxsge.core.debug.Debug;
import hxsge.examples.format.tson.models.TsonManagerModel;
import hxsge.examples.format.tson.controllers.TsonManagerController;

class TsonManager {
	public function new() {
#if nodejs
//		Angular.module("tson_manager", ['treeControl'])
//		.controller("TsonManagerController", TsonManagerController.new)
//		.factory(TsonManagerModel.new);

		Angular.module("tsonmanager", ['treeControl'])
		.factory(TsonManagerModel.new)
		.controller("TsonManagerController", TsonManagerController.new);

		var jqBody = new JQuery("body");
		Angular.bootstrap(jqBody[0], ["tsonmanager"]);
#end
	}
}
#end