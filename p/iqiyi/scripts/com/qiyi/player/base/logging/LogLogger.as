package com.qiyi.player.base.logging
{
	import flash.events.EventDispatcher;
	
	public class LogLogger extends EventDispatcher implements ILogger
	{
		
		private var _category:String;
		
		public function LogLogger(param1:String)
		{
			super();
			this._category = param1;
		}
		
		public function get category() : String
		{
			return this._category;
		}
		
		public function log(param1:int, param2:String, ... rest) : void
		{
			var _loc4:String = null;
			var _loc5:* = 0;
			if(param1 < LogEventLevel.DEBUG)
			{
				_loc4 = "Level limit!";
				throw new ArgumentError(_loc4);
			}
			else
			{
				if(hasEventListener(LogEvent.LOG))
				{
					_loc5 = 0;
					while(_loc5 < rest.length)
					{
						var param2:String = param2.replace(new RegExp("\\{" + _loc5 + "\\}","g"),rest[_loc5]);
						_loc5++;
					}
					dispatchEvent(new LogEvent(param2,param1));
				}
				return;
			}
		}
		
		public function debug(param1:String, ... rest) : void
		{
			var _loc3:* = 0;
			if(hasEventListener(LogEvent.LOG))
			{
				_loc3 = 0;
				while(_loc3 < rest.length)
				{
					var param1:String = param1.replace(new RegExp("\\{" + _loc3 + "\\}","g"),rest[_loc3]);
					_loc3++;
				}
				dispatchEvent(new LogEvent(param1,LogEventLevel.DEBUG));
			}
		}
		
		public function error(param1:String, ... rest) : void
		{
			var _loc3:* = 0;
			if(hasEventListener(LogEvent.LOG))
			{
				_loc3 = 0;
				while(_loc3 < rest.length)
				{
					var param1:String = param1.replace(new RegExp("\\{" + _loc3 + "\\}","g"),rest[_loc3]);
					_loc3++;
				}
				dispatchEvent(new LogEvent(param1,LogEventLevel.ERROR));
			}
		}
		
		public function fatal(param1:String, ... rest) : void
		{
			var _loc3:* = 0;
			if(hasEventListener(LogEvent.LOG))
			{
				_loc3 = 0;
				while(_loc3 < rest.length)
				{
					var param1:String = param1.replace(new RegExp("\\{" + _loc3 + "\\}","g"),rest[_loc3]);
					_loc3++;
				}
				dispatchEvent(new LogEvent(param1,LogEventLevel.FATAL));
			}
		}
		
		public function info(param1:String, ... rest) : void
		{
			var _loc3:* = 0;
			if(hasEventListener(LogEvent.LOG))
			{
				_loc3 = 0;
				while(_loc3 < rest.length)
				{
					var param1:String = param1.replace(new RegExp("\\{" + _loc3 + "\\}","g"),rest[_loc3]);
					_loc3++;
				}
				dispatchEvent(new LogEvent(param1,LogEventLevel.INFO));
			}
		}
		
		public function warn(param1:String, ... rest) : void
		{
			var _loc3:* = 0;
			if(hasEventListener(LogEvent.LOG))
			{
				_loc3 = 0;
				while(_loc3 < rest.length)
				{
					var param1:String = param1.replace(new RegExp("\\{" + _loc3 + "\\}","g"),rest[_loc3]);
					_loc3++;
				}
				dispatchEvent(new LogEvent(param1,LogEventLevel.WARN));
			}
		}
	}
}
