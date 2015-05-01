package com.qiyi.player.core.video.render {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.display.Stage;
	import com.qiyi.player.base.logging.ILogger;
	import flash.events.Event;
	import com.qiyi.player.base.logging.Log;
	
	public class StageVideoManager extends EventDispatcher {
		
		public function StageVideoManager(param1:SingletonClass) {
			this._activeStageVideoes = new Dictionary(true);
			this._log = Log.getLogger("com.qiyi.player.core.video.video.StageVideoManager");
			super();
		}
		
		public static const AVAILABILITY:String = "availability";
		
		public static const AVAILABLE:String = "available";
		
		public static const UNAVAILABLE:String = "unavailable";
		
		private static var _instance:StageVideoManager = null;
		
		public static var _curDepth:int = 1;
		
		public static function get instance() : StageVideoManager {
			if(_instance == null) {
				_instance = new StageVideoManager(new SingletonClass());
			}
			return _instance;
		}
		
		private var _activeStageVideoes:Dictionary;
		
		private var _stage:Stage;
		
		private var _stageVideoIsAvailable:Boolean = false;
		
		private var _log:ILogger;
		
		public function initialize(param1:Stage) : void {
			if(this._stage) {
				return;
			}
			this._stage = param1;
			if(this._stage.hasOwnProperty("stageVideos")) {
				this._stage.addEventListener("stageVideoAvailability",this.onStageVideoAvailability);
				this._stageVideoIsAvailable = this._stage["stageVideos"].length > 0;
			}
		}
		
		public function get stageVideoIsAvailable() : Boolean {
			return this._stageVideoIsAvailable;
		}
		
		public function getNewDepth() : int {
			return ++_curDepth;
		}
		
		private function onStageVideoAvailability(param1:Event) : void {
			this._log.info("the stagevideo is " + param1[AVAILABILITY]);
			var _loc2_:* = param1[AVAILABILITY] == AVAILABLE;
			if(_loc2_ != this._stageVideoIsAvailable) {
				this._stageVideoIsAvailable = _loc2_;
			}
			if(!_loc2_) {
				this._activeStageVideoes = new Dictionary(true);
			}
			dispatchEvent(new Event(AVAILABILITY));
		}
		
		public function get stageVideoCount() : int {
			return this._stage?this._stage["stageVideos"].length:0;
		}
		
		public function getStageVideo() : Object {
			var _loc3_:* = undefined;
			if(!this._stageVideoIsAvailable) {
				return null;
			}
			var _loc1_:Object = null;
			var _loc2_:* = 0;
			while(_loc2_ < this._stage["stageVideos"].length) {
				_loc1_ = this._stage["stageVideos"][_loc2_];
				for(_loc3_ in this._activeStageVideoes) {
					if(_loc1_ == _loc3_) {
						_loc1_ = null;
						break;
					}
				}
				if(_loc1_) {
					break;
				}
				_loc2_++;
			}
			if(_loc1_) {
				this._activeStageVideoes[_loc1_] = null;
			}
			return _loc1_;
		}
		
		public function release(param1:Object) : void {
			delete this._activeStageVideoes[param1];
			true;
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
