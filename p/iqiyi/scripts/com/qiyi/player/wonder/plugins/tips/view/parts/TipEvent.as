package com.qiyi.player.wonder.plugins.tips.view.parts {
	import flash.events.Event;
	
	public class TipEvent extends Event {
		
		public function TipEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public static const LinkEvent:String = "LinkEvent";
		
		public static const ASEvent:String = "ASEvent";
		
		public static const JSEvent:String = "JSEvent";
		
		public static const Show:String = "TipShow";
		
		public static const Hide:String = "TipHide";
		
		public static const Close:String = "TipClose";
		
		public static const Error:String = "TipError";
		
		public static const All:String = "AllTipEvent";
		
		private var _data:Object;
		
		public function get url() : String {
			if((this._data) && (this._data.url)) {
				return this._data.url;
			}
			return null;
		}
		
		public function get eventName() : String {
			if((this._data) && (this._data.eventName)) {
				return this._data.eventName;
			}
			return null;
		}
		
		public function get eventParams() : String {
			if((this._data) && (this._data.eventParams)) {
				return this._data.eventParams;
			}
			return null;
		}
		
		private var _tipId:String;
		
		public function set tipId(param1:String) : void {
			this._tipId = param1;
		}
		
		public function get tipId() : String {
			return this._tipId;
		}
		
		private var _error;
		
		public function get error() : * {
			return this._error;
		}
		
		public function set error(param1:*) : void {
			this._error = param1;
		}
	}
}
