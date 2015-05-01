package com.qiyi.player.wonder.plugins.dock.view {
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class DockEvent extends CommonEvent {
		
		public function DockEvent(param1:String, param2:Object = null) {
			super(param1,param2);
		}
		
		public static const Evt_Open:String = "evtDockOpen";
		
		public static const Evt_Close:String = "evtDockClose";
	}
}
