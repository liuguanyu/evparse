package com.pplive.events
{
	import flash.events.Event;
	
	public class RtmfpEvent extends Event
	{
		
		public static const RTMFP_START_SUCCESS:String = "_RTMFP_START_SUCCESS_";
		
		public static const RTMFP_START_FAIL:String = "_RTMFP_START_FAIL_";
		
		public static const RTMFP_STOP:String = "_RTMFP_STOP_";
		
		public static const RTMFP_CONNECT_PEER_SUCCESS:String = "_RTMFP_CONNECT_PEER_SUCCESS_";
		
		public static const RTMFP_CONNECT_PEER_FAIL:String = "_RTMFP_CONNECT_PEER_FAIL_";
		
		public static const RTMFP_STREAM_CLOSED:String = "_RTMFP_STREAM_CLOSED_";
		
		public static const RTMFP_LISTENER_START_SUCCESS:String = "_RTMFP_LISTENER_START_SUCCESS_";
		
		public static const RTMFP_LISTENER_START_FAIL:String = "_RTMFP_LISTENER_START_FAIL_";
		
		public static const RTMFP_LISTENER_STOP:String = "_RTMFP_LISTENER_STOP_";
		
		public static const RTMFP_PEER_ACCEPTED:String = "_RTMFP_PEER_ACCEPTED_";
		
		private var _info;
		
		public function RtmfpEvent(param1:String, param2:* = null, param3:Boolean = false, param4:Boolean = false)
		{
			super(param1,param3,param4);
			this._info = param2;
		}
		
		public function get info() : *
		{
			return this._info;
		}
		
		override public function clone() : Event
		{
			return new RtmfpEvent(this.type,this._info,this.bubbles,this.cancelable);
		}
	}
}
