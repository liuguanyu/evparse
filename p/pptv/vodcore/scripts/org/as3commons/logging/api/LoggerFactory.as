package org.as3commons.logging.api
{
	public class LoggerFactory extends Object
	{
		
		private const _allLoggers:Array = [];
		
		private const _loggers:Object = {};
		
		private var _setup:ILogSetup;
		
		private var _duringSetup:Boolean;
		
		public function LoggerFactory(param1:ILogSetup = null)
		{
			super();
			this.setup = param1;
		}
		
		public function get setup() : ILogSetup
		{
			return this._setup;
		}
		
		public function set setup(param1:ILogSetup) : void
		{
			var _loc3:* = 0;
			this._setup = param1;
			var _loc2:int = this._allLoggers.length;
			_loc3 = 0;
			while(_loc3 < _loc2)
			{
				Logger(this._allLoggers[_loc3]).allTargets = null;
				_loc3++;
			}
			if(param1)
			{
				_loc3 = 0;
				this._duringSetup = true;
				while(_loc3 < _loc2)
				{
					while(_loc3 < _loc2)
					{
						param1.applyTo(Logger(this._allLoggers[_loc3]));
						_loc3++;
					}
					_loc2 = this._allLoggers.length;
				}
				this._duringSetup = false;
			}
		}
		
		public function getNamedLogger(param1:String = null, param2:String = null) : ILogger
		{
			var param1:String = param1 || "";
			var _loc3:Object = this._loggers[param1] = this._loggers[param1] || {};
			var _loc4:Logger = _loc3[param2];
			if(!_loc4)
			{
				_loc4 = new Logger(param1,param2);
				_loc3[param2] = _loc4;
				this._allLoggers[this._allLoggers.length] = _loc4;
				if((this._setup) && !this._duringSetup)
				{
					this._setup.applyTo(_loc4);
				}
			}
			return _loc4;
		}
	}
}
