package com.pplive.vod.events
{
	import flash.events.Event;
	
	public class PlayResultEvent extends Event
	{
		
		public static const PLAY_RESULT:String = "PLAY_RESULT_REPORT";
		
		private var _timeLoaded:uint;
		
		private var _bufferLength:uint;
		
		private var _m:int;
		
		private var _url:String;
		
		private var _interval:uint;
		
		private var _error:uint;
		
		private var _httpStatus:uint;
		
		public function PlayResultEvent(param1:int, param2:String, param3:uint, param4:uint = 0, param5:uint = 0)
		{
			super(PLAY_RESULT);
			this._m = param1;
			this._url = param2;
			this._interval = param3;
			this._error = param4;
			this._httpStatus = param5;
		}
		
		public function get m() : int
		{
			return this._m;
		}
		
		public function get url() : String
		{
			return this._url;
		}
		
		public function get interval() : uint
		{
			return this._interval;
		}
		
		public function get error() : uint
		{
			return this._error;
		}
		
		public function get httpStatus() : uint
		{
			return this._httpStatus;
		}
		
		override public function clone() : Event
		{
			return new PlayResultEvent(this._m,this._url,this._interval);
		}
	}
}
