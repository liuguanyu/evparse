package com.pplive.p2p.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class FlvDataEvent extends Event
	{
		
		public static const FLV_DATA:String = "__FLV_DATA__";
		
		public var data:ByteArray;
		
		public function FlvDataEvent(param1:ByteArray)
		{
			super(FLV_DATA);
			this.data = param1;
		}
		
		override public function clone() : Event
		{
			return new FlvDataEvent(this.data);
		}
	}
}
