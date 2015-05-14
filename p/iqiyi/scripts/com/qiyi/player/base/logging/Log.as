package com.qiyi.player.base.logging
{
	import com.qiyi.player.base.logging.errors.InvalidCategoryError;
	
	public class Log extends Object
	{
		
		private static var NONE:int = int.MAX_VALUE;
		
		private static var _targetLevel:int = NONE;
		
		private static var _loggers:Array;
		
		private static var _targets:Array = [];
		
		public function Log()
		{
			super();
		}
		
		public static function isFatal() : Boolean
		{
			return _targetLevel <= LogEventLevel.FATAL?true:false;
		}
		
		public static function isError() : Boolean
		{
			return _targetLevel <= LogEventLevel.ERROR?true:false;
		}
		
		public static function isWarn() : Boolean
		{
			return _targetLevel <= LogEventLevel.WARN?true:false;
		}
		
		public static function isInfo() : Boolean
		{
			return _targetLevel <= LogEventLevel.INFO?true:false;
		}
		
		public static function isDebug() : Boolean
		{
			return _targetLevel <= LogEventLevel.DEBUG?true:false;
		}
		
		public static function addTarget(param1:ILoggingTarget) : void
		{
			var _loc2:Array = null;
			var _loc3:ILogger = null;
			var _loc4:String = null;
			var _loc5:String = null;
			if(param1)
			{
				_loc2 = param1.filters;
				for(_loc4 in _loggers)
				{
					if(categoryMatchInFilterList(_loc4,_loc2))
					{
						param1.addLogger(ILogger(_loggers[_loc4]));
					}
				}
				_targets.push(param1);
				if(_targetLevel == NONE)
				{
					_targetLevel = param1.level;
				}
				else if(param1.level < _targetLevel)
				{
					_targetLevel = param1.level;
				}
				
				return;
			}
			_loc5 = "Invalid Target!";
			throw new ArgumentError(_loc5);
		}
		
		public static function removeTarget(param1:ILoggingTarget) : void
		{
			var _loc2:Array = null;
			var _loc3:ILogger = null;
			var _loc4:String = null;
			var _loc5:* = 0;
			var _loc6:String = null;
			if(param1)
			{
				_loc2 = param1.filters;
				for(_loc4 in _loggers)
				{
					if(categoryMatchInFilterList(_loc4,_loc2))
					{
						param1.removeLogger(ILogger(_loggers[_loc4]));
					}
				}
				_loc5 = 0;
				while(_loc5 < _targets.length)
				{
					if(param1 == _targets[_loc5])
					{
						_targets.splice(_loc5,1);
						_loc5--;
					}
					_loc5++;
				}
				resetTargetLevel();
				return;
			}
			_loc6 = "Invalid target";
			throw new ArgumentError(_loc6);
		}
		
		public static function getLogger(param1:String) : ILogger
		{
			var _loc3:ILoggingTarget = null;
			checkCategory(param1);
			if(!_loggers)
			{
				_loggers = [];
			}
			var _loc2:ILogger = _loggers[param1];
			if(_loc2 == null)
			{
				_loc2 = new LogLogger(param1);
				_loggers[param1] = _loc2;
			}
			var _loc4:* = 0;
			while(_loc4 < _targets.length)
			{
				_loc3 = ILoggingTarget(_targets[_loc4]);
				if(categoryMatchInFilterList(param1,_loc3.filters))
				{
					_loc3.addLogger(_loc2);
				}
				_loc4++;
			}
			return _loc2;
		}
		
		public static function flush() : void
		{
			_loggers = [];
			_targets = [];
			_targetLevel = NONE;
		}
		
		public static function hasIllegalCharacters(param1:String) : Boolean
		{
			return !(param1.search(new RegExp("[\\[\\]\\~\\$\\^\\&\\\\(\\)\\{\\}\\+\\?\\/=`!@#%,:;\'\"<>\\s]")) == -1);
		}
		
		private static function categoryMatchInFilterList(param1:String, param2:Array) : Boolean
		{
			var _loc4:String = null;
			var _loc3:* = false;
			var _loc5:* = -1;
			var _loc6:uint = 0;
			while(_loc6 < param2.length)
			{
				_loc4 = param2[_loc6];
				_loc5 = _loc4.indexOf("*");
				if(_loc5 == 0)
				{
					return true;
				}
				_loc5 = _loc5 < 0?_loc5 = param1.length:_loc5 - 1;
				if(param1.substring(0,_loc5) == _loc4.substring(0,_loc5))
				{
					return true;
				}
				_loc6++;
			}
			return false;
		}
		
		private static function checkCategory(param1:String) : void
		{
			var _loc2:String = null;
			if(param1 == null || param1.length == 0)
			{
				_loc2 = "Invalid category length!";
				throw new InvalidCategoryError(_loc2);
			}
			else if((hasIllegalCharacters(param1)) || !(param1.indexOf("*") == -1))
			{
				_loc2 = "Invalid charactors";
				throw new InvalidCategoryError(_loc2);
			}
			else
			{
				return;
			}
			
		}
		
		private static function resetTargetLevel() : void
		{
			var _loc1:int = NONE;
			var _loc2:* = 0;
			while(_loc2 < _targets.length)
			{
				if(_loc1 == NONE || _targets[_loc2].level < _loc1)
				{
					_loc1 = _targets[_loc2].level;
				}
				_loc2++;
			}
			_targetLevel = _loc1;
		}
	}
}
