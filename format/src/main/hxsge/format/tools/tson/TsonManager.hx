package hxsge.format.tools.tson;

import hxsge.core.log.TraceLogger;
import hxsge.core.log.Log;
import hxsge.core.debug.Debug;

import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;

class TsonManager {
	public function new() {
	}

	public static function main() {
		Log.addLogger(new TraceLogger());
		Debug.trace("TSON manager launched");

//		var wnd:MainWnd = new MainWnd();

//		Macros.addStyleSheet("assets/styles/gradient/gradient.css");
//		Toolkit.init();
//		Toolkit.openFullscreen(function(root:Root) {
//			var button:Button = new Button();
//			button.text = "Click Me!";
//			button.x = 100;
//			button.y = 100;
//			button.onClick = function(e:UIEvent) {
//				e.component.text = "You clicked me!";
//			};
//			root.addChild(button);
//		});
	}
}
