package com.pplive.vod.events
{
	import flash.events.Event;
	
	public class PlayProgressEvent extends Event
	{
		
		public static const PLAY_PROGRESS:String = "PLAY_PROGRESS_REPORT";
		
		private var _timeLoaded:uint;
		
		private var _bufferLength:uint;
		
		private var _downloadSpeed:uint;
		
		private var _vipAccelerateSpeed:uint;
		
		public function PlayProgressEvent(param1:uint, param2:uint, param3:uint, param4:uint)
		{
			super(PLAY_PROGRESS);
			this._timeLoaded = param1;
			this._bufferLength = param2;
			this._downloadSpeed = param3;
			this._vipAccelerateSpeed = param4;
		}
		
		public function get timeLoaded() : uint
		{
			return this._timeLoaded;
		}
		
		public function get bufferLength() : uint
		{
			return this._bufferLength;
		}
		
		public function get downloadSpeed() : uint
		{
			return this._downloadSpeed;
		}
		
		public function get vipAccelerateSpeed() : uint
		{
			return this._vipAccelerateSpeed;
		}
		
		override public function clone() : Event
		{
			return new PlayProgressEvent(this._timeLoaded,this._bufferLength,this._downloadSpeed,this._vipAccelerateSpeed);
		}
	}
}
