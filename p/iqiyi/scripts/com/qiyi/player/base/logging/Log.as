package com.qiyi.player.base.logging {
	import com.qiyi.player.base.logging.errors.InvalidCategoryError;
	
	public class Log extends Object {
		
		public function Log() {
			super();
		}
		
		private static var NONE:int = int.MAX_VALUE;
		
		private static var _targetLevel:int = NONE;
		
		private static var _loggers:Array;
		
		private static var _targets:Array = [];
		
		public static function isFatal() : Boolean {
			return _targetLevel <= LogEventLevel.FATAL?true:false;
		}
		
		public static function isError() : Boolean {
			return _targetLevel <= LogEventLevel.ERROR?true:false;
		}
		
		public static function isWarn() : Boolean {
			return _targetLevel <= LogEventLevel.WARN?true:false;
		}
		
		public static function isInfo() : Boolean {
			return _targetLevel <= LogEventLevel.INFO?true:false;
		}
		
		public static function isDebug() : Boolean {
			return _targetLevel <= LogEventLevel.DEBUG?true:false;
		}
		
		public static function addTarget(param1:ILoggingTarget) : void {
			var _loc2_:Array = null;
			var _loc3_:ILogger = null;
			var _loc4_:String = null;
			var _loc5_:String = null;
			if(param1) {
				_loc2_ = param1.filters;
				for(_loc4_ in _loggers) {
					if(categoryMatchInFilterList(_loc4_,_loc2_)) {
						param1.addLogger(ILogger(_loggers[_loc4_]));
					}
				}
				_targets.push(param1);
				if(_targetLevel == NONE) {
					_targetLevel = param1.level;
				} else if(param1.level < _targetLevel) {
					_targetLevel = param1.level;
				}
				
				return;
			}
			_loc5_ = "Invalid Target!";
			throw new ArgumentError(_loc5_);
		}
		
		public static function removeTarget(param1:ILoggingTarget) : void {
			var _loc2_:Array = null;
			var _loc3_:ILogger = null;
			var _loc4_:String = null;
			var _loc5_:* = 0;
			var _loc6_:String = null;
			if(param1) {
				_loc2_ = param1.filters;
				for(_loc4_ in _loggers) {
					if(categoryMatchInFilterList(_loc4_,_loc2_)) {
						param1.removeLogger(ILogger(_loggers[_loc4_]));
					}
				}
				_loc5_ = 0;
				while(_loc5_ < _targets.length) {
					if(param1 == _targets[_loc5_]) {
						_targets.splice(_loc5_,1);
						_loc5_--;
					}
					_loc5_++;
				}
				resetTargetLevel();
				return;
			}
			_loc6_ = "Invalid target";
			throw new ArgumentError(_loc6_);
		}
		
		public static function getLogger(param1:String) : ILogger {
			var _loc3_:ILoggingTarget = null;
			checkCategory(param1);
			if(!_loggers) {
				_loggers = [];
			}
			var _loc2_:ILogger = _loggers[param1];
			if(_loc2_ == null) {
				_loc2_ = new LogLogger(param1);
				_loggers[param1] = _loc2_;
			}
			var _loc4_:* = 0;
			while(_loc4_ < _targets.length) {
				_loc3_ = ILoggingTarget(_targets[_loc4_]);
				if(categoryMatchInFilterList(param1,_loc3_.filters)) {
					_loc3_.addLogger(_loc2_);
				}
				_loc4_++;
			}
			return _loc2_;
		}
		
		public static function flush() : void {
			_loggers = [];
			_targets = [];
			_targetLevel = NONE;
		}
		
		public static function hasIllegalCharacters(param1:String) : Boolean {
			return !(param1.search(new RegExp("[\\[\\]\\~\\$\\^\\&\\\\(\\)\\{\\}\\+\\?\\/=`!@#%,:;\'\"<>\\s]")) == -1);
		}
		
		private static function categoryMatchInFilterList(param1:String, param2:Array) : Boolean {
			var _loc4_:String = null;
			var _loc3_:* = false;
			var _loc5_:* = -1;
			var _loc6_:uint = 0;
			while(_loc6_ < param2.length) {
				_loc4_ = param2[_loc6_];
				_loc5_ = _loc4_.indexOf("*");
				if(_loc5_ == 0) {
					return true;
				}
				_loc5_ = _loc5_ < 0?_loc5_ = param1.length:_loc5_ - 1;
				if(param1.substring(0,_loc5_) == _loc4_.substring(0,_loc5_)) {
					return true;
				}
				_loc6_++;
			}
			return false;
		}
		
		private static function checkCategory(param1:String) : void {
			var _loc2_:String = null;
			if(param1 == null || param1.length == 0) {
				_loc2_ = "Invalid category length!";
				throw new InvalidCategoryError(_loc2_);
			} else if((hasIllegalCharacters(param1)) || !(param1.indexOf("*") == -1)) {
				_loc2_ = "Invalid charactors";
				throw new InvalidCategoryError(_loc2_);
			} else {
				return;
			}
			
		}
		
		private static function resetTargetLevel() : void {
			var _loc1_:int = NONE;
			var _loc2_:* = 0;
			while(_loc2_ < _targets.length) {
				if(_loc1_ == NONE || _targets[_loc2_].level < _loc1_) {
					_loc1_ = _targets[_loc2_].level;
				}
				_loc2_++;
			}
			_targetLevel = _loc1_;
		}
	}
}
