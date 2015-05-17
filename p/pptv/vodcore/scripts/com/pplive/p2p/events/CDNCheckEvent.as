package com.pplive.p2p.events
{
	import flash.events.Event;
	
	public class CDNCheckEvent extends Event
	{
		
		public static const OK:String = "_CDN_CHECK_OK_";
		
		public static const FAIL:String = "_CDN_CHECK_FAIL_";
		
		public var error:uint = 0;
		
		public function CDNCheckEvent(param1:String, param2:uint, param3:Boolean = false, param4:Boolean = false)
		{
			super(param1,param3,param4);
			this.error = param2;
		}
	}
}
