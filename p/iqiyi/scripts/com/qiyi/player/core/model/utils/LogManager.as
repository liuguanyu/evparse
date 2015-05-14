package com.qiyi.player.core.model.utils
{
	import com.qiyi.player.base.logging.targets.LineFormattedTarget;
	import com.qiyi.player.base.logging.targets.TraceTarget;
	import com.qiyi.player.base.logging.LogEventLevel;
	import com.qiyi.player.base.logging.Log;
	import flash.system.Capabilities;
	import com.qiyi.player.base.logging.targets.DebugTarget;
	import com.qiyi.player.base.logging.targets.CookieTarget;
	import com.qiyi.player.core.Config;
	import com.qiyi.player.base.logging.ILoggingTarget;
	
	public class LogManager extends Object
	{
		
		public static var _targets:Array = [];
		
		public function LogManager()
		{
			super();
		}
		
		public static function initLog(param1:Boolean = true) : void
		{
			var _loc2:LineFormattedTarget = null;
			_loc2 = new TraceTarget();
			_loc2.level = LogEventLevel.DEBUG;
			_loc2.includeDate = true;
			_loc2.includeTime = true;
			_loc2.includeLevel = true;
			_targets.push(_loc2);
			Log.addTarget(_loc2);
			if(Capabilities.isDebugger)
			{
				_loc2 = new DebugTarget();
				_loc2.level = LogEventLevel.DEBUG;
				_loc2.includeDate = true;
				_loc2.includeTime = true;
				_loc2.includeLevel = true;
				_targets.push(_loc2);
				Log.addTarget(_loc2);
			}
			else if(param1)
			{
				_loc2 = new CookieTarget(Config.LOG_COOKIE,"logs",Config.MAX_LOG_COOKIE_SIZE,400);
				_loc2.level = LogEventLevel.INFO;
				_loc2.includeDate = true;
				_loc2.includeTime = true;
				_targets.push(_loc2);
				Log.addTarget(_loc2);
			}
			
		}
		
		public static function getLifeLogs() : Array
		{
			var _loc1:* = 0;
			while(_loc1 < _targets.length)
			{
				if(_targets[_loc1] is TraceTarget)
				{
					return TraceTarget(_targets[_loc1]).getLifeLogs();
				}
				_loc1++;
			}
			return [];
		}
		
		public static function setTargetFilters(param1:int, param2:Array) : void
		{
			var _loc4:ILoggingTarget = null;
			var _loc3:* = 0;
			while(_loc3 < _targets.length)
			{
				_loc4 = _targets[_loc3];
				if(_loc4.level == param1)
				{
					_loc4.filters = param2.slice();
				}
				_loc3++;
			}
		}
	}
}
