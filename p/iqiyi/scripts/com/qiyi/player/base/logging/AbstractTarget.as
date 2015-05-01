package com.qiyi.player.base.logging {
	import com.qiyi.player.base.logging.errors.InvalidFilterError;
	
	public class AbstractTarget extends Object implements ILoggingTarget {
		
		public function AbstractTarget() {
			this._filters = ["*"];
			super();
		}
		
		private var _loggerCount:uint = 0;
		
		private var _filters:Array;
		
		public function get filters() : Array {
			return this._filters;
		}
		
		public function set filters(param1:Array) : void {
			var _loc2_:String = null;
			var _loc3_:* = 0;
			var _loc4_:String = null;
			var _loc5_:uint = 0;
			if((param1) && param1.length > 0) {
				_loc5_ = 0;
				while(_loc5_ < param1.length) {
					_loc2_ = param1[_loc5_];
					if(Log.hasIllegalCharacters(_loc2_)) {
						_loc4_ = "filters has invalide characters";
						throw new InvalidFilterError(_loc4_);
					} else {
						_loc3_ = _loc2_.indexOf("*");
						if(_loc3_ >= 0 && !(_loc3_ == _loc2_.length - 1)) {
							_loc4_ = "the \"*\" must be in the tail of filter";
							throw new InvalidFilterError(_loc4_);
						} else {
							_loc5_++;
							continue;
						}
					}
				}
			} else {
				var param1:Array = ["*"];
			}
			if(this._loggerCount > 0) {
				Log.removeTarget(this);
				this._filters = param1;
				Log.addTarget(this);
			} else {
				this._filters = param1;
			}
		}
		
		private var _level:int = 0;
		
		public function get level() : int {
			return this._level;
		}
		
		public function set level(param1:int) : void {
			this._level = param1;
		}
		
		public function addLogger(param1:ILogger) : void {
			if(param1) {
				this._loggerCount++;
				param1.addEventListener(LogEvent.LOG,this.logHandler);
			}
		}
		
		public function removeLogger(param1:ILogger) : void {
			if(param1) {
				this._loggerCount--;
				param1.removeEventListener(LogEvent.LOG,this.logHandler);
			}
		}
		
		public function initialized(param1:Object) : void {
			Log.addTarget(this);
		}
		
		public function logEvent(param1:LogEvent) : void {
		}
		
		private function logHandler(param1:LogEvent) : void {
			if(param1.level >= this.level) {
				this.logEvent(param1);
			}
		}
	}
}
