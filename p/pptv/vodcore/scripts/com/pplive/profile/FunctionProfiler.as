package com.pplive.profile
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.getTimer;
	
	public class FunctionProfiler extends Object
	{
		
		private static var defaultLogger:ILogger = getLogger(FunctionProfiler);
		
		private var _begin:int;
		
		private var _update:int;
		
		private var _section:int;
		
		private var _logger:ILogger;
		
		public function FunctionProfiler(param1:ILogger = null, param2:String = null)
		{
			super();
			this._begin = getTimer();
			this._update = this._begin;
			this._section = 0;
			this._logger = param1;
			if(param2)
			{
				this.logger.debug(param2);
			}
		}
		
		public function makeSection() : void
		{
			var _loc1:int = getTimer();
			this.logger.debug("Section" + this._section++ + " duration=" + (_loc1 - this._update));
			this._update = _loc1;
		}
		
		public function end() : void
		{
			var _loc1:int = getTimer();
			if(this._section != 0)
			{
				this.logger.debug("Section" + this._section++ + " duration=" + (_loc1 - this._update));
			}
			this.logger.debug("End duration=" + (_loc1 - this._begin));
		}
		
		private function get logger() : ILogger
		{
			if(this._logger)
			{
				return this._logger;
			}
			return defaultLogger;
		}
	}
}
