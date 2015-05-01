package com.qiyi.player.core.model.events {
	import flash.events.Event;
	
	public class MovieEvent extends Event {
		
		public function MovieEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public static const Evt_Ready:String = "ready";
		
		public static const Evt_Meta_Ready:String = "metaReady";
		
		public static const Evt_Failed:String = "failed";
		
		public static const Evt_Success:String = "success";
		
		public static const Evt_UpdateSkipPoint:String = "updateSkipPoint";
		
		public static const Evt_EnjoyableSubTypeChanged:String = "enjoyableSubTypeChanged";
		
		public static const Evt_EnjoyableSubTypeInited:String = "enjoyableSubTypeInited";
		
		private var _data:Object;
		
		public function get data() : Object {
			return this._data;
		}
	}
}
