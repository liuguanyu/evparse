package com.qiyi.player.wonder.plugins.share.view
{
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class ShareEvent extends CommonEvent
	{
		
		public static const Evt_Open:String = "evtShareOpen";
		
		public static const Evt_Close:String = "evtShareClose";
		
		public static const Evt_ShareBtnClick:String = "evtShareBtnClick";
		
		public function ShareEvent(param1:String, param2:Object = null)
		{
			super(param1,param2);
		}
	}
}
