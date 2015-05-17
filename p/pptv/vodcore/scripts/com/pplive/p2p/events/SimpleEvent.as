package com.pplive.p2p.events
{
	import flash.events.Event;
	
	public class SimpleEvent extends Event
	{
		
		public static const BS_CONFIG_SUCCESS:String = "__BS_CONFIG_SUCCESS__";
		
		public static const BS_CONFIG_FAIL:String = "__BS_CONFIG_FAIL__";
		
		public static const TRACKER_LIST_FAIL:String = "__TRACKER_LIST_FAIL__";
		
		public var info;
		
		public function SimpleEvent(param1:String, param2:* = null)
		{
			super(param1);
			this.info = param2;
		}
		
		override public function clone() : Event
		{
			return new SimpleEvent(type,this.info);
		}
	}
}
