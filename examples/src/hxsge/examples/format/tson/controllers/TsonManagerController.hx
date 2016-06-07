package hxsge.examples.format.tson.controllers;

#if nodejs
import hxsge.format.tson.TsonEncoder;
import hxsge.format.tson.parts.TsonValueType;
import hxsge.format.tson.TsonDecoder;
import hxsge.format.tson.Tson;
import hxsge.loaders.base.ILoader;
import hxsge.loaders.data.DataLoader;
import js.JQuery;
import hxsge.examples.format.tson.data.TsonManagerData;
import hxsge.examples.format.tson.models.TsonManagerModel;
import hxsge.core.debug.Debug;
import hxsge.format.tson.parts.TsonBlock;
import angular.service.Scope;
import js.Browser;
import js.html.InputElement;

using hxsge.loaders.utils.LoaderTools;

class TsonManagerController {
	var _scope:Scope;
	var _data:TsonManagerData;
	var _fileName:String = "";

	public function new(scope:Scope, model:TsonManagerModel) {
		_data = new TsonManagerData();

		_scope = scope;

		_scope.set("managerData", _data);
		_scope.set("treeOptions", {
			nodeChildren: "children",
			dirSelectable: false
		});
		_scope.set("newTsonFile", newTsonFile);
		_scope.set("loadTsonFile", loadTsonFile);
		_scope.set("saveTsonFile", saveTsonFile);

		newTsonFile();
	}

	function newTsonFile() {
		_data.tson = new TsonBlock(TsonValueType.TSON_BT_MAP_UINT8, []);
		_scope.safeApply(function() {
			_scope.set("managerData", _data);
		});
	}

	function loadTsonFile() {
		var dialog:InputElement = Browser.document.createInputElement();
		dialog.type = 'file';
		dialog.multiple = false;
		dialog.accept = ".tson";

		var q = new JQuery(dialog);
		q.change(function(event:JqEvent) {
			var sjl:DataLoader = new DataLoader(dialog.value);
			sjl.finished.addOnce(onTsonLoaded);
			sjl.load();
		});
		q.click();
	}

	function saveTsonFile() {
		var dialog:InputElement = Browser.document.createInputElement();
		dialog.type = 'file';
		dialog.multiple = false;
		dialog.accept = ".tson";
		untyped __js__('dialog.nwsaveas = "filename.tson"');

		var q = new JQuery(dialog);
		q.change(function(event:JqEvent) {
			_fileName = dialog.value;
//			var bbb:js.node.Buffer = new js.node.Buffer(cast TsonEncoder.fromBlock(_data.tson.header, _data.tson.root).getData());
//			js.node.Fs.writeFile(_fileName, bbb, "binary", onFileWriteFinished);
		});
		q.click();
	}
	function onFileWriteFinished(e:Dynamic) {
	}

	function onTsonLoaded(loader:ILoader) {
		if(loader.isSuccess()) {
			var decoder:TsonDecoder = new TsonDecoder(loader.content);
			_data.tson = decoder.root;
			_scope.safeApply(function() {
				_scope.set("managerData", _data);
			});
			Debug.trace("tson file loaded successfully");
		}
		else {
			Debug.trace("tson file loading failed");
		}
	}
}
#end
