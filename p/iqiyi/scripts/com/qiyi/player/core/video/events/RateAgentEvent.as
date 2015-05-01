package com.qiyi.player.core.video.events {
	import flash.events.Event;
	
	public class RateAgentEvent extends Event {
		
		public function RateAgentEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public static const Evt_DefinitionChanged:String = "dc";
		
		public static const Evt_AudioTrackChanged:String = "atc";
		
		public static const Evt_AutoAdjustRate:String = "autoAdjustRate";
		
		private var _data:Object;
		
		public function get data() : Object {
			return this._data;
		}
	}
}
