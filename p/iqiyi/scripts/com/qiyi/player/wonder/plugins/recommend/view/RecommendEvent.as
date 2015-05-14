package com.qiyi.player.wonder.plugins.recommend.view
{
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class RecommendEvent extends CommonEvent
	{
		
		public static const Evt_Finish_Open:String = "evtFinishRecommendOpen";
		
		public static const Evt_Finish_Close:String = "evtFinishRecommendClose";
		
		public static const Evt_ReplayVideo:String = "evtRecommendReplayVideo";
		
		public static const Evt_OpenVideo:String = "evtRecommendOpenVideo";
		
		public static const Evt_CustomizeItemClick:String = "evtRecommendCustomizeItemClick";
		
		public static const Evt_PlayingItemClick:String = "evtPlayingItemClick";
		
		public static const Evt_PlayingClickCloseBtn:String = "evtPlayingClickCloseBtn";
		
		public function RecommendEvent(param1:String, param2:Object = null)
		{
			super(param1,param2);
		}
	}
}
