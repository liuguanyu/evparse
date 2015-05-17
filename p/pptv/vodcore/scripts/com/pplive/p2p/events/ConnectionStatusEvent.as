package com.pplive.p2p.events
{
	import flash.events.Event;
	
	public class ConnectionStatusEvent extends Event
	{
		
		public static const ANNOUNCE_UPDATED:String = "__ANNOUNCE_UPDATED__";
		
		public static const CLOSED:String = "__CLOSED__";
		
		public function ConnectionStatusEvent(param1:String)
		{
			super(param1);
		}
	}
}
