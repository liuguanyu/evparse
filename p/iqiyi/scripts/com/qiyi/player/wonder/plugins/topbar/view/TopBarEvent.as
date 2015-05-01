package com.qiyi.player.wonder.plugins.topbar.view {
	import com.qiyi.player.wonder.common.event.CommonEvent;
	
	public class TopBarEvent extends CommonEvent {
		
		public function TopBarEvent(param1:String, param2:Object = null) {
			super(param1,param2);
		}
		
		public static const Evt_Open:String = "evtTopBarOpen";
		
		public static const Evt_Close:String = "evtTopBarClose";
		
		public static const Evt_ScaleClick:String = "evtTopBarScaleClick";
	}
}
