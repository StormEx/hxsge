package hxsge.candyland.platforms.stage3d;

#if flash
import flash.Vector;
import flash.events.TimerEvent;
import flash.utils.Timer;
import hxsge.memory.Memory;
import hxsge.photon.Signal.Signal1;
import hxsge.core.debug.Debug;
import flash.errors.Error;
import flash.events.Event;
import flash.events.ErrorEvent;
import flash.Lib;
import flash.display3D.Context3D;
import flash.display.Stage3D;
import hxsge.candyland.common.IRender;

class Stage3dRender implements IRender {
	public var info(get, never):String;

	public var initialized(default, null):Signal1<Bool>;

	var _stage3D:Stage3D = null;
	var _context3D:Context3D = null;
	var _contextTypes:Array<String> = ["baselineExtended", "baseline", "baselineConstrained"];
	var _currentContextType:Int = 0;

	var _timer:Timer;

	public function new() {
		initialized = new Signal1();
	}

	public function dispose() {
		Memory.dispose(initialized);

		if(_context3D != null) {
			_context3D.dispose(false);
			_context3D = null;
		}
		_timer = null;
	}

	public function initialize() {
		_stage3D = Lib.current.stage.stage3Ds[0];
		_stage3D.addEventListener(ErrorEvent.ERROR, onError);
		_stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);

		try {
			_stage3D.requestContext3D(cast "auto", cast _contextTypes[_currentContextType]);
		}
		catch (e:Error) {
			Debug.trace("Can't request stage3d context " + _contextTypes[_currentContextType]);

			tryToInitializeNextContextType();
		}
	}

	public function begin() {
		if(_context3D == null) {
			return;
		}

		_context3D.clear(0, 0, 0, 1);
	}

	public function present() {
		_context3D.present();
	}

	public function resize(width:Int, height:Int) {
		if(_context3D == null) {
			return;
		}

		var stage = Lib.current.stage;

		if(width < 32) {
			width = 32;
			stage.stageWidth = 32;
		}
		if(height < 32) {
			height = 32;
			stage.stageHeight = 32;
		}

		try {
//			if(capabilities.hasDepthAndStencil) {
//				context.configureBackBuffer(width, height, 0, false);
//			}
//			else {
//				context.configureBackBuffer(width, height, 0);
//			}
			_context3D.configureBackBuffer(width, height, 0);
		}
		catch(e:Error) {
			Debug.trace("Can't resize stage3D backbuffer to: " + Std.string(width) + "x" + Std.string(height));
		}
	}

	function tryToInitializeNextContextType() {
		++_currentContextType;

		if(_contextTypes.length == _currentContextType) {
			performFail();
		}
		else {
			if(_stage3D != null && _stage3D.context3D != null) {
				_stage3D.context3D.dispose(false);
			}

			if(_timer == null) {
				_timer = new Timer(1000, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleted);
			}
			_timer.reset();
			_timer.start();
		}
	}

	inline function performSuccess() {
		_context3D = _stage3D.context3D;

		Debug.trace("Stage3D created successfuly with profile: " + _contextTypes[_currentContextType]);
		Debug.trace("Stage3D driver info: " + info);

		initialized.emit(true);
	}

	inline function performFail() {
		if(_timer != null) {
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerCompleted);
			_timer = null;
		}

		Debug.trace("Creation of stage3d context failed...");

		initialized.emit(false);
	}

	function onError(e:ErrorEvent) {
		Debug.trace("Can't create stage3d context " + _contextTypes[_currentContextType]);

		tryToInitializeNextContextType();
	}

	function onContextCreated(e:Event) {
		performSuccess();
		resize(Lib.current.stage.fullScreenWidth, Lib.current.stage.fullScreenHeight);
	}

	function onTimerCompleted(e:TimerEvent) {
		_timer.stop();
		initialize();
	}

	inline function get_info():String {
		return _context3D != null ? _context3D.driverInfo : "not initialized";
	}
}
#end