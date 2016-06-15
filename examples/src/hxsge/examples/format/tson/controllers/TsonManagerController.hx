package hxsge.examples.format.tson.controllers;

//#if nodejs
import haxe.io.BytesInput;
import hxsge.format.tson.data.TsonDataReader;
import hxsge.format.tson.data.TsonDataWriter;
import hxsge.format.tson.data.TsonData;
import hxsge.loaders.data.JsFileLoader;
import js.html.AnchorElement;
import js.html.LinkElement;
import js.html.Uint8Array;
import haxe.io.BytesData;
import hxsge.core.debug.Debug;
import haxe.io.Bytes;
import js.html.Blob;
import hxsge.loaders.data.JsDataLoader;
//import hxsge.format.tson.TsonEncoder;
import hxsge.format.tson.data.TsonValueType;
//import hxsge.format.tson.TsonDecoder;
import hxsge.format.tson.Tson;
import hxsge.loaders.base.ILoader;
import hxsge.loaders.data.DataLoader;
import js.JQuery.JqEvent;
import js.JQuery;
import hxsge.examples.format.tson.data.TsonManagerData;
import hxsge.examples.format.tson.models.TsonManagerModel;
import hxsge.core.debug.Debug;
//import hxsge.format.tson.parts.TsonBlock;
import angular.service.Scope;
import js.Browser;
import js.html.InputElement;

using hxsge.loaders.utils.LoaderTools;

class TsonManagerController {
	var _scope:Scope;
	var _data:TsonManagerData;
	var _fileName:String = "";
	var _tson:Bytes;

	public function new(scope:Scope, model:TsonManagerModel) {
		_data = new TsonManagerData();
		_data.changed.add(onDataChanged);

		_scope = scope;

		_scope.set("managerData", _data);
		_scope.set("treeOptions", {
			nodeChildren: "children"
		});
		_scope.set("newTsonFile", newTsonFile);
		_scope.set("loadTsonFile", loadTsonFile);
		_scope.set("saveTsonFile", saveTsonFile);

		newTsonFile();
	}

	function newTsonFile() {
		_data.tson = null;
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
			var sjl:JsFileLoader = new JsFileLoader(dialog.files[0]);
			sjl.finished.addOnce(onTsonLoaded);
			sjl.load();

			_data.loading = true;
			_scope.safeApply(function() {
				_scope.set("managerData", _data);
			});
		});
		q.click();
	}

	function saveTsonFile() {
#if nodejs
		var dialog:InputElement = Browser.document.createInputElement();
		dialog.type = 'file';
		dialog.multiple = false;
		dialog.accept = ".tson";
		untyped __js__('dialog.nwsaveas = "filename.tson"');

		var q = new JQuery(dialog);
		q.change(function(event:JqEvent) {
			_fileName = dialog.value;
			try {
				var d:TsonData = _data.getChanges();
				var b:Bytes = Tson.convertData(d);//TsonEncoder.fromBlock(_data.getChanges());
				var bbb:js.node.Buffer = new js.node.Buffer(b.length);
				var arr:Uint8Array = new Uint8Array(b.getData());
				for(i in 0...arr.length) {
					bbb[i] = arr[i];
				}
				js.node.Fs.writeFile(_fileName, bbb, "binary", onFileWriteFinished);
			}
			catch(e:Dynamic) {
				Debug.trace("save error: " + Std.string(e));
				return;
			}
		});
		q.click();
#else
		var elem:AnchorElement = Browser.document.createAnchorElement();
		elem.href = js.html.URL.createObjectURL(new Blob([TsonEncoder.fromBlock(_data.getChanges()).getData()]));
		elem.download = "temp.tson";
		elem.click();
#end
	}
	function onFileWriteFinished(e:Dynamic) {
		Debug.trace("file saved successfully...");
	}

	function onTsonLoaded(loader:ILoader) {
		if(loader.isSuccess()) {
			_tson = loader.content;
//			var decoder:TsonDecoder = new TsonDecoder(_tson);
			_data.tson = TsonDataReader.read(new BytesInput(_tson));//decoder.root;
			Debug.trace("tson file loaded successfully");
		}
		else {
			newTsonFile();
			Debug.trace("tson file loading failed");
		}

		_data.loading = false;
		_scope.safeApply(function() {
			_scope.set("managerData", _data);
		});
	}

	function onDataChanged() {
		_scope.safeApply(function() {
			_scope.set("managerData", _data);
		});
	}
}
//#end
