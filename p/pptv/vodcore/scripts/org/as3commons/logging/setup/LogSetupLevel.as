package org.as3commons.logging.setup
{
	import org.as3commons.logging.api.Logger;
	
	public final class LogSetupLevel extends Object
	{
		
		private static const _levels:Array = [];
		
		public static const NONE:LogSetupLevel = getLevelByValue(1);
		
		public static const FATAL_ONLY:LogSetupLevel = getLevelByValue(2);
		
		public static const FATAL:LogSetupLevel = NONE.or(FATAL_ONLY);
		
		public static const ERROR_ONLY:LogSetupLevel = getLevelByValue(4);
		
		public static const ERROR:LogSetupLevel = FATAL.or(ERROR_ONLY);
		
		public static const WARN_ONLY:LogSetupLevel = getLevelByValue(8);
		
		public static const WARN:LogSetupLevel = ERROR.or(WARN_ONLY);
		
		public static const INFO_ONLY:LogSetupLevel = getLevelByValue(16);
		
		public static const INFO:LogSetupLevel = WARN.or(INFO_ONLY);
		
		public static const DEBUG_ONLY:LogSetupLevel = getLevelByValue(32);
		
		public static const DEBUG:LogSetupLevel = INFO.or(DEBUG_ONLY);
		
		public static const ALL:LogSetupLevel = DEBUG;
		
		private var _value:int;
		
		public function LogSetupLevel(param1:int)
		{
			super();
			if(_levels[param1])
			{
				throw Error("LogTargetLevel exists already!");
			}
			else
			{
				_levels[param1] = this;
				this._value = param1;
				return;
			}
		}
		
		public static function getLevelByValue(param1:int) : LogSetupLevel
		{
			return _levels[param1] || (_levels[param1] = new LogSetupLevel(param1));
		}
		
		public function applyTo(param1:Logger, param2:ILogTarget) : void
		{
			if(this._value & DEBUG_ONLY._value)
			{
				param1.debugTarget = param2;
			}
			if(this._value & INFO_ONLY._value)
			{
				param1.infoTarget = param2;
			}
			if(this._value & WARN_ONLY._value)
			{
				param1.warnTarget = param2;
			}
			if(this._value & ERROR_ONLY._value)
			{
				param1.errorTarget = param2;
			}
			if(this._value & FATAL_ONLY._value)
			{
				param1.fatalTarget = param2;
			}
		}
		
		public function or(param1:LogSetupLevel) : LogSetupLevel
		{
			return getLevelByValue(this._value | param1._value);
		}
		
		public function valueOf() : int
		{
			return this._value;
		}
	}
}
