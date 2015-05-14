package com.qiyi.player.wonder.common.event
{
	import flash.events.Event;
	
	public class CommonEvent extends Event
	{
		
		private var _data:Object;
		
		public function CommonEvent(param1:String, param2:Object = null)
		{
			super(param1,false,false);
			this._data = param2;
		}
		
		public function set data(param1:Object) : void
		{
			this._data = param1;
		}
		
		public function get data() : Object
		{
			return this._data;
		}
	}
}
