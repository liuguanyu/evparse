package com.pplive.vod.events
{
	import flash.events.Event;
	
	public class PlayStatusEvent extends Event
	{
		
		public static const PLAY_START:String = "PLAY_STATUS_START";
		
		public static const PLAY_FAILED:String = "PLAY_STATUS_FAILED";
		
		public static const PLAY_COMPLETE:String = "PLAY_STATUS_COMPLETE";
		
		public static const PLAY_SEEK_NOTIFY:String = "PLAY_STATUS_SEEK_NOTIFY";
		
		public static const PLAY_PAUSED:String = "PLAY_STATUS_PAUSED";
		
		public static const BUFFER_EMPTY:String = "PLAY_STATUS_BUFFER_EMPTY";
		
		public static const SWITCH_FT:String = "SWITCH_FT";
		
		public static const BUFFER_FULL:String = "PLAY_STATUS_BUFFER_FULL";
		
		public static const KERNEL_DETECTED:String = "PLAY_STATUS_KERNEL_DECTECTED";
		
		private var _info:Object;
		
		public function PlayStatusEvent(param1:String, param2:Object = null)
		{
			super(param1);
			this._info = param2;
		}
		
		public function get info() : Object
		{
			return this._info;
		}
		
		override public function clone() : Event
		{
			return new PlayStatusEvent(type,this._info);
		}
	}
}
