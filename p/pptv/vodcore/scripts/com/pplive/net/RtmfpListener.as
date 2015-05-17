package com.pplive.net
{
	import flash.events.EventDispatcher;
	import flash.net.NetStream;
	import com.pplive.events.RtmfpEvent;
	import flash.events.NetStatusEvent;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	
	public class RtmfpListener extends EventDispatcher
	{
		
		private var _rtmfp:RtmfpModule;
		
		private var _publishStream:NetStream;
		
		private var _isStarted:Boolean = false;
		
		private var _timeoutHandlerID:uint;
		
		private var _peerValidator:Function = null;
		
		public function RtmfpListener(param1:RtmfpModule)
		{
			super();
			this._rtmfp = param1;
		}
		
		public function get isStarted() : Boolean
		{
			return this._isStarted;
		}
		
		public function set peerValidator(param1:Function) : void
		{
			this._peerValidator = param1;
		}
		
		public function start(param1:String, param2:uint = 10000.0) : void
		{
			var media:String = param1;
			var timeout:uint = param2;
			if(this._publishStream)
			{
				return;
			}
			this._publishStream = this._rtmfp.createPublishNetStream();
			if(!this._publishStream)
			{
				dispatchEvent(new RtmfpEvent(RtmfpEvent.RTMFP_LISTENER_START_FAIL));
				return;
			}
			this._rtmfp.addEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStopped,false,0,true);
			this._publishStream.addEventListener(NetStatusEvent.NET_STATUS,this.publishStatusHandler,false,0,true);
			var o:Object = new Object();
			o.onPeerConnect = this.onPeerConnect;
			this._publishStream.client = o;
			this._timeoutHandlerID = setTimeout(this.doStop,timeout,new RtmfpEvent(RtmfpEvent.RTMFP_LISTENER_START_FAIL));
			try
			{
				this._publishStream.publish(media);
			}
			catch(e:*)
			{
				doStop(new RtmfpEvent(RtmfpEvent.RTMFP_LISTENER_START_FAIL));
			}
		}
		
		public function stop() : void
		{
			if(this._isStarted)
			{
				this.doStop(new RtmfpEvent(RtmfpEvent.RTMFP_LISTENER_STOP));
			}
			else if(this._publishStream)
			{
				this.doStop(new RtmfpEvent(RtmfpEvent.RTMFP_LISTENER_START_FAIL));
			}
			
		}
		
		private function doStop(param1:Event) : void
		{
			var event:Event = param1;
			if(this._publishStream)
			{
				clearTimeout(this._timeoutHandlerID);
				this._timeoutHandlerID = 0;
				this._rtmfp.removeEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStopped);
				this._publishStream.removeEventListener(NetStatusEvent.NET_STATUS,this.publishStatusHandler);
				try
				{
					this._publishStream.close();
				}
				catch(e:*)
				{
				}
				this._publishStream = null;
				this._isStarted = false;
				if(event)
				{
					dispatchEvent(event);
				}
			}
		}
		
		private function onPeerConnect(param1:NetStream) : Boolean
		{
			var pending:PendingIncomeStream = null;
			var accept:Boolean = false;
			var subscriber:NetStream = param1;
			if(subscriber.client == subscriber || !subscriber.client)
			{
				PendingIncomeStream.setupPending(this._rtmfp,subscriber);
			}
			pending = subscriber.client.pending;
			pending.addEventListener(RtmfpEvent.RTMFP_PEER_ACCEPTED,this.onPeerAccepted,false,0,true);
			accept = this._peerValidator == null || (this._peerValidator(subscriber));
			setTimeout(function():void
			{
				pending.isAccepted = accept;
			},50);
			return accept;
		}
		
		private function onPeerAccepted(param1:RtmfpEvent) : void
		{
			dispatchEvent(param1);
		}
		
		private function onRtmfpStopped(param1:RtmfpEvent) : void
		{
			this.stop();
		}
		
		private function publishStatusHandler(param1:NetStatusEvent) : void
		{
			switch(param1.info.code)
			{
				case "NetStream.Publish.Start":
					clearTimeout(this._timeoutHandlerID);
					this._timeoutHandlerID = 0;
					this._isStarted = true;
					dispatchEvent(new RtmfpEvent(RtmfpEvent.RTMFP_LISTENER_START_SUCCESS));
					break;
			}
		}
	}
}
