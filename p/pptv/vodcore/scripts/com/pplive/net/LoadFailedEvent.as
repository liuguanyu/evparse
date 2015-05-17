package com.pplive.net
{
	import flash.events.Event;
	
	public class LoadFailedEvent extends Event
	{
		
		public static const LOAD_FAILED:String = "LOAD_FAILED";
		
		public function LoadFailedEvent(param1:String = "LOAD_FAILED", param2:Boolean = false, param3:Boolean = false)
		{
			super(param1,param2,param3);
		}
	}
}
