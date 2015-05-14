package com.qiyi.player.core.video.events
{
	import flash.events.Event;
	
	public class DispatcherEvent extends Event
	{
		
		public static const Evt_Success:String = "success";
		
		public static const Evt_Failed:String = "failed";
		
		private var _data:Object;
		
		public function DispatcherEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
		{
			super(param1,param3,param4);
			this._data = param2;
		}
		
		public function get data() : Object
		{
			return this._data;
		}
	}
}
