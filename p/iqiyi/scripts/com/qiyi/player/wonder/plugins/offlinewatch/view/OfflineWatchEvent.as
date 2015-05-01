package com.qiyi.player.wonder.plugins.offlinewatch.view {
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class OfflineWatchEvent extends CommonEvent {
		
		public function OfflineWatchEvent(param1:String, param2:Object = null) {
			super(param1,param2);
		}
		
		public static const Evt_Open:String = "evtOfflineWatchOpen";
		
		public static const Evt_Close:String = "evtOfflineWatchClose";
	}
}
