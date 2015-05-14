package com.qiyi.player.base.logging.targets
{
	import com.qiyi.player.base.logging.AbstractTarget;
	import com.qiyi.player.base.logging.LogEvent;
	import com.qiyi.player.base.logging.ILogger;
	
	public class LineFormattedTarget extends AbstractTarget
	{
		
		public var fieldSeparator:String = " ";
		
		public var includeCategory:Boolean;
		
		public var includeDate:Boolean;
		
		public var includeLevel:Boolean;
		
		public var includeTime:Boolean;
		
		public function LineFormattedTarget()
		{
			super();
			this.includeTime = false;
			this.includeDate = false;
			this.includeCategory = false;
			this.includeLevel = false;
		}
		
		override public function logEvent(param1:LogEvent) : void
		{
			var _loc5:Date = null;
			var _loc2:* = "";
			if((this.includeDate) || (this.includeTime))
			{
				_loc5 = new Date();
				if(this.includeDate)
				{
					_loc2 = Number(_loc5.getMonth() + 1).toString() + "/" + _loc5.getDate().toString() + "/" + _loc5.getFullYear() + this.fieldSeparator;
				}
				if(this.includeTime)
				{
					_loc2 = _loc2 + (this.padTime(_loc5.getHours()) + ":" + this.padTime(_loc5.getMinutes()) + ":" + this.padTime(_loc5.getSeconds()) + "." + this.padTime(_loc5.getMilliseconds(),true) + this.fieldSeparator);
				}
			}
			var _loc3:* = "";
			if(this.includeLevel)
			{
				_loc3 = "[" + LogEvent.getLevelString(param1.level) + "]" + this.fieldSeparator;
			}
			var _loc4:String = this.includeCategory?ILogger(param1.target).category + this.fieldSeparator:"";
			this.internalLog(param1.level,_loc2 + _loc3 + _loc4 + param1.message);
		}
		
		private function padTime(param1:Number, param2:Boolean = false) : String
		{
			if(param2)
			{
				if(param1 < 10)
				{
					return "00" + param1.toString();
				}
				if(param1 < 100)
				{
					return "0" + param1.toString();
				}
				return param1.toString();
			}
			return param1 > 9?param1.toString():"0" + param1.toString();
		}
		
		protected function internalLog(param1:int, param2:String) : void
		{
		}
	}
}
