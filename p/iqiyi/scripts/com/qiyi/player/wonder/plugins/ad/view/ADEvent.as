package com.qiyi.player.wonder.plugins.ad.view {
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class ADEvent extends CommonEvent {
		
		public function ADEvent(param1:String, param2:Object = null) {
			super(param1,param2);
		}
		
		public static const Evt_Open:String = "evtADOpen";
		
		public static const Evt_Close:String = "evtADClose";
		
		public static const Evt_LoadSuccess:String = "evtADLoadSuccess";
		
		public static const Evt_LoadFailed:String = "evtADLoadFailed";
		
		public static const Evt_StartPlay:String = "evtADStartPlay";
		
		public static const Evt_AskVideoPause:String = "evtADAskVideoPause";
		
		public static const Evt_AskVideoResume:String = "evtADAskVideoResume";
		
		public static const Evt_AskVideoStartLoad:String = "evtADAskVideoStartLoad";
		
		public static const Evt_AskVideoStartPlay:String = "evtADAskVideoStartPlay";
		
		public static const Evt_AskVideoEnd:String = "evtADAskVideoEnd";
		
		public static const Evt_AdBlock:String = "evtADBlock";
		
		public static const Evt_AdUnloaded:String = "evtAdUnloaded";
	}
}
