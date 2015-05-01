package com.qiyi.player.core.history.events {
	import flash.events.Event;
	
	public class HistoryEvent extends Event {
		
		public function HistoryEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public static const Evt_Ready:String = "ready";
		
		private var _data:Object;
		
		public function get data() : Object {
			return this._data;
		}
	}
}
