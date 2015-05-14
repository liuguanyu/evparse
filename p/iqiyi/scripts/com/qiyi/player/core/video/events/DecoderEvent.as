package com.qiyi.player.core.video.events
{
	import flash.events.Event;
	
	public class DecoderEvent extends Event
	{
		
		public static const Evt_StatusChanged:String = "sc";
		
		public static const Evt_MetaData:String = "md";
		
		public function DecoderEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
		{
			super(param1,param2,param3);
		}
	}
}
