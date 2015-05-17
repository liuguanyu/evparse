package com.pplive.net
{
	import flash.events.EventDispatcher;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import com.pplive.events.RtmfpEvent;
	
	class PendingIncomeStream extends EventDispatcher
	{
		
		private var _rtmfp:RtmfpModule;
		
		private var _stream:NetStream;
		
		private var _isAccepted:Boolean = false;
		
		private var _isNetStreamConnected:Boolean = false;
		
		function PendingIncomeStream(param1:RtmfpModule, param2:NetStream)
		{
			super();
			this._rtmfp = param1;
			this._stream = param2;
			this._rtmfp.addEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStopped,false,0,true);
			this._stream.addEventListener(NetStatusEvent.NET_STATUS,this.streamStatusHandler,false,0,true);
		}
		
		public static function setupPending(param1:RtmfpModule, param2:NetStream) : PendingIncomeStream
		{
			var rtmfp:RtmfpModule = param1;
			var stream:NetStream = param2;
			stream.client = new Object();
			stream.client.onRtmfpData = function(param1:*):void
			{
			};
			return stream.client.pending = new PendingIncomeStream(rtmfp,stream);
		}
		
		public function set isAccepted(param1:Boolean) : void
		{
			this._isAccepted = param1;
			if(this._isAccepted)
			{
				this.checkEndPending();
			}
			else
			{
				this.clear();
			}
		}
		
		public function clear() : void
		{
			if(this._stream)
			{
				this._stream.removeEventListener(NetStatusEvent.NET_STATUS,this.streamStatusHandler);
				this._stream = null;
			}
			if(this._rtmfp)
			{
				this._rtmfp.removeEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStopped);
				this._rtmfp = null;
			}
		}
		
		private function checkEndPending() : void
		{
			var _loc1:RtmfpEvent = null;
			if((this._stream) && (this._isAccepted) && (this._isNetStreamConnected))
			{
				_loc1 = new RtmfpEvent(RtmfpEvent.RTMFP_PEER_ACCEPTED,new RtmfpStream(this._rtmfp,this._stream));
				this.clear();
				dispatchEvent(_loc1);
			}
		}
		
		private function onRtmfpStopped(param1:RtmfpEvent) : void
		{
			this.clear();
		}
		
		private function streamStatusHandler(param1:NetStatusEvent) : void
		{
			switch(param1.info.code)
			{
				case "NetStream.Connect.Success":
					this._isNetStreamConnected = true;
					this.checkEndPending();
					break;
				case "NetStream.Connect.Closed":
					this.clear();
					break;
			}
		}
	}
}
