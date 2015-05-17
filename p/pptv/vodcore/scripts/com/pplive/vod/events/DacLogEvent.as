package com.pplive.vod.events
{
	import flash.events.Event;
	
	public class DacLogEvent extends Event
	{
		
		public static const P2P_DAC_LOG:String = "P2P_DAC_LOG";
		
		public static const DETECT_KERNEL_LOG:String = "DETECT_KERNEL_LOG";
		
		private var _logObject:Object;
		
		public function DacLogEvent(param1:Object, param2:String = "P2P_DAC_LOG")
		{
			super(param2);
			this._logObject = param1;
		}
		
		public function get logObject() : Object
		{
			return this._logObject;
		}
		
		override public function toString() : String
		{
			var _loc3:String = null;
			var _loc1:String = super.toString();
			var _loc2:Vector.<String> = new Vector.<String>();
			for(_loc3 in this.logObject)
			{
				_loc2.push(_loc3 + ":" + this.logObject[_loc3]);
			}
			_loc1 = _loc1 + (", " + _loc2.join());
			return _loc1;
		}
		
		override public function clone() : Event
		{
			return new DacLogEvent(this._logObject,type);
		}
	}
}
