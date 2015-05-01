package com.qiyi.player.core.video.events {
	import flash.events.Event;
	
	public class ProviderEvent extends Event {
		
		public function ProviderEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public static const Evt_Connected:String = "connected";
		
		public static const Evt_LoadComplete:String = "load_complete";
		
		public static const Evt_Retry:String = "retry";
		
		public static const Evt_Stop:String = "stop";
		
		public static const Evt_WillLoad:String = "willLoad";
		
		public static const Evt_StartLoad:String = "startLoad";
		
		public static const Evt_StateChanged:String = "stateChanged";
		
		public static const Evt_Failed:String = "failed";
		
		private var _data:Object;
		
		public function get data() : Object {
			return this._data;
		}
	}
}
