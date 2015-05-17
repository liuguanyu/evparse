package com.pplive.p2p.events
{
	import flash.events.Event;
	
	public class GetSeekTimeEvent extends Event
	{
		
		public static const GET_SEEK_TIME:String = "__GET_SEEK_TIME__";
		
		public var seekTime:Number;
		
		public function GetSeekTimeEvent(param1:Number)
		{
			super(GET_SEEK_TIME);
			this.seekTime = param1;
		}
		
		override public function clone() : Event
		{
			return new GetSeekTimeEvent(this.seekTime);
		}
	}
}
