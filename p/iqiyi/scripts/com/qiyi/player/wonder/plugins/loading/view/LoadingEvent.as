package com.qiyi.player.wonder.plugins.loading.view {
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class LoadingEvent extends CommonEvent {
		
		public function LoadingEvent(param1:String, param2:Object = null) {
			super(param1,param2);
		}
		
		public static const Evt_Open:String = "evtLoadingOpen";
		
		public static const Evt_Close:String = "evtLoadingClose";
	}
}
