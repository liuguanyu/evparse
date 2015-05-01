package com.qiyi.player.core.model.utils {
	import com.qiyi.player.base.logging.targets.LineFormattedTarget;
	import com.qiyi.player.base.logging.targets.TraceTarget;
	import com.qiyi.player.base.logging.LogEventLevel;
	import com.qiyi.player.base.logging.Log;
	import flash.system.Capabilities;
	import com.qiyi.player.base.logging.targets.DebugTarget;
	import com.qiyi.player.base.logging.targets.CookieTarget;
	import com.qiyi.player.core.Config;
	import com.qiyi.player.base.logging.ILoggingTarget;
	
	public class LogManager extends Object {
		
		public function LogManager() {
			super();
		}
		
		public static var _targets:Array = [];
		
		public static function initLog(param1:Boolean = true) : void {
			var _loc2_:LineFormattedTarget = null;
			_loc2_ = new TraceTarget();
			_loc2_.level = LogEventLevel.DEBUG;
			_loc2_.includeDate = true;
			_loc2_.includeTime = true;
			_loc2_.includeLevel = true;
			_targets.push(_loc2_);
			Log.addTarget(_loc2_);
			if(Capabilities.isDebugger) {
				_loc2_ = new DebugTarget();
				_loc2_.level = LogEventLevel.DEBUG;
				_loc2_.includeDate = true;
				_loc2_.includeTime = true;
				_loc2_.includeLevel = true;
				_targets.push(_loc2_);
				Log.addTarget(_loc2_);
			} else if(param1) {
				_loc2_ = new CookieTarget(Config.LOG_COOKIE,"logs",Config.MAX_LOG_COOKIE_SIZE,400);
				_loc2_.level = LogEventLevel.INFO;
				_loc2_.includeDate = true;
				_loc2_.includeTime = true;
				_targets.push(_loc2_);
				Log.addTarget(_loc2_);
			}
			
		}
		
		public static function getLifeLogs() : Array {
			var _loc1_:* = 0;
			while(_loc1_ < _targets.length) {
				if(_targets[_loc1_] is TraceTarget) {
					return TraceTarget(_targets[_loc1_]).getLifeLogs();
				}
				_loc1_++;
			}
			return [];
		}
		
		public static function setTargetFilters(param1:int, param2:Array) : void {
			var _loc4_:ILoggingTarget = null;
			var _loc3_:* = 0;
			while(_loc3_ < _targets.length) {
				_loc4_ = _targets[_loc3_];
				if(_loc4_.level == param1) {
					_loc4_.filters = param2.slice();
				}
				_loc3_++;
			}
		}
	}
}
