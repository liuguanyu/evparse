package com.qiyi.cupid.adplayer.events {
	import flash.events.Event;
	
	public class AdBlockedBlackScreenEvent extends Event {
		
		public function AdBlockedBlackScreenEvent(param1:String, param2:Boolean = false, param3:Boolean = false) {
			super(param1,param2,param3);
		}
		
		public static const BLACK_SCREEN_COMPLETE:String = "black_screen_complete";
	}
}
