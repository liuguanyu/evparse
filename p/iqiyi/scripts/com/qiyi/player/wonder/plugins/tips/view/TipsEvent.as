package com.qiyi.player.wonder.plugins.tips.view
{
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class TipsEvent extends CommonEvent
	{
		
		public static const Evt_Open:String = "evtTipsOpen";
		
		public static const Evt_Close:String = "evtTipsClose";
		
		public function TipsEvent(param1:String, param2:Object = null)
		{
			super(param1,param2);
		}
	}
}
