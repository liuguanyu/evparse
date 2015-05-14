package com.qiyi.player.base.logging.targets
{
	public class TraceTarget extends LineFormattedTarget
	{
		
		private var _flag:String;
		
		private var _logs:Array;
		
		public function TraceTarget(param1:String = "")
		{
			this._logs = [];
			super();
			this._flag = param1;
		}
		
		override protected function internalLog(param1:int, param2:String) : void
		{
			trace(param2);
			this._logs.push(param2);
			if(this._logs.length > 3000)
			{
				this._logs.shift();
			}
		}
		
		public function getLifeLogs() : Array
		{
			return this._logs;
		}
	}
}
