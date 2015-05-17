package com.pplive.net
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.net.NetStream;
	import com.pplive.events.RtmfpEvent;
	import flash.events.IOErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	
	public class RtmfpStream extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(RtmfpStream);
		
		private var _rtmfp:RtmfpModule;
		
		private var _stream:NetStream;
		
		private var _isConnected:Boolean = false;
		
		private var _peerID:String;
		
		private var _timeoutHandlerID:uint;
		
		private var _dataReliable:Boolean = false;
		
		private var _dataHandler;
		
		public function RtmfpStream(param1:RtmfpModule, param2:NetStream = null)
		{
			super();
			this._rtmfp = param1;
			this._stream = param2;
			if(this._stream)
			{
				this._rtmfp.stat.connectionSetupCount++;
				this._isConnected = true;
				this._peerID = this._stream.farID;
				this._stream.videoReliable = false;
				this._stream.audioReliable = false;
				this._stream.dataReliable = this._dataReliable;
				this._rtmfp.addEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStopped,false,0,true);
				this._stream.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
				this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError,false,0,true);
				this._stream.addEventListener(NetStatusEvent.NET_STATUS,this.netStreamHandler,false,0,true);
				this._stream.client = new Object();
				this._stream.client.onRtmfpData = this.onRtmfpData;
			}
		}
		
		public function connect(param1:String, param2:String, param3:uint) : void
		{
			var peer:String = param1;
			var media:String = param2;
			var timeout:uint = param3;
			if(this._stream)
			{
				return;
			}
			this._stream = this._rtmfp.createPeerNetStream(peer);
			if(!this._stream)
			{
				dispatchEvent(new RtmfpEvent(RtmfpEvent.RTMFP_CONNECT_PEER_FAIL,{
					"peer":peer,
					"code":"rtmfp-not-started"
				}));
				return;
			}
			this._peerID = peer;
			this._rtmfp.addEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStopped,false,0,true);
			this._stream.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
			this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError,false,0,true);
			this._stream.addEventListener(NetStatusEvent.NET_STATUS,this.netStreamHandler,false,0,true);
			this._stream.client = new Object();
			this._stream.client.onRtmfpData = this.onRtmfpData;
			this._timeoutHandlerID = setTimeout(this.doClose,timeout,new RtmfpEvent(RtmfpEvent.RTMFP_CONNECT_PEER_FAIL,{
				"peer":peer,
				"code":"timeout"
			}));
			this._rtmfp.stat.connectCount++;
			try
			{
				this._stream.play(media);
			}
			catch(e:Error)
			{
				doClose(new RtmfpEvent(RtmfpEvent.RTMFP_CONNECT_PEER_FAIL,{
					"peer":peer,
					"code":e.message
				}));
			}
		}
		
		public function close() : void
		{
			var _loc1:RtmfpEvent = null;
			if(this.isConnected)
			{
				_loc1 = new RtmfpEvent(RtmfpEvent.RTMFP_STREAM_CLOSED);
			}
			else if(this.isConnecting)
			{
				_loc1 = new RtmfpEvent(RtmfpEvent.RTMFP_CONNECT_PEER_FAIL,{
					"peer":this._peerID,
					"code":"canceled"
				});
			}
			
			this.doClose(_loc1);
		}
		
		public function get isConnected() : Boolean
		{
			return this._isConnected;
		}
		
		public function get isConnecting() : Boolean
		{
			return !(this._stream == null) && !this._isConnected;
		}
		
		public function get peerID() : String
		{
			return this._peerID;
		}
		
		public function set dataHandler(param1:*) : void
		{
			this._dataHandler = param1;
		}
		
		public function set dataReliable(param1:Boolean) : void
		{
			this._dataReliable = param1;
			if(this.isConnected)
			{
				this._stream.dataReliable = param1;
			}
		}
		
		public function send(param1:Object) : void
		{
			if(this.isConnected)
			{
				this._stream.send("onRtmfpData",param1);
			}
		}
		
		private function onRtmfpData(param1:Object) : void
		{
			if((this.isConnected) && (this._dataHandler))
			{
				this._dataHandler(param1);
			}
		}
		
		private function doClose(param1:Event) : void
		{
			var event:Event = param1;
			if(this._stream)
			{
				clearTimeout(this._timeoutHandlerID);
				this._timeoutHandlerID = 0;
				this._rtmfp.removeEventListener(RtmfpEvent.RTMFP_STOP,this.onRtmfpStopped);
				this._stream.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
				this._stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
				this._stream.removeEventListener(NetStatusEvent.NET_STATUS,this.netStreamHandler);
				try
				{
					this._stream.close();
				}
				catch(e:*)
				{
				}
				this._stream = null;
				this._peerID = null;
				this._isConnected = false;
				if(event)
				{
					dispatchEvent(event);
				}
			}
		}
		
		private function onIOError(param1:IOErrorEvent) : void
		{
		}
		
		private function onAsyncError(param1:AsyncErrorEvent) : void
		{
		}
		
		private function onRtmfpStopped(param1:RtmfpEvent) : void
		{
			if(this.isConnecting)
			{
				this.doClose(new RtmfpEvent(RtmfpEvent.RTMFP_CONNECT_PEER_FAIL,{
					"peer":this._peerID,
					"code":"rtmfp-stopped"
				}));
			}
			else
			{
				this.doClose(new RtmfpEvent(RtmfpEvent.RTMFP_STREAM_CLOSED));
			}
		}
		
		private function netStreamHandler(param1:NetStatusEvent) : void
		{
			logger.debug("Rtmfp connect: " + param1.info.code);
			switch(param1.info.code)
			{
				case "NetStream.Play.Start":
					clearTimeout(this._timeoutHandlerID);
					this._timeoutHandlerID = 0;
					this._peerID = this._stream.farID;
					this._isConnected = true;
					this._stream.dataReliable = this._dataReliable;
					this._stream.audioReliable = false;
					this._stream.audioReliable = false;
					this._rtmfp.stat.connectionSetupCount++;
					dispatchEvent(new RtmfpEvent(RtmfpEvent.RTMFP_CONNECT_PEER_SUCCESS));
					break;
				case "NetStream.Play.Stop":
				case "NetStream.Play.Failed":
				case "NetStream.Play.StreamNotFound":
				case "NetStream.Connect.Closed":
					if(this.isConnecting)
					{
						this.doClose(new RtmfpEvent(RtmfpEvent.RTMFP_CONNECT_PEER_FAIL,{
							"peer":this._peerID,
							"code":"connect-fail"
						}));
					}
					else
					{
						this.doClose(new RtmfpEvent(RtmfpEvent.RTMFP_STREAM_CLOSED));
					}
					break;
			}
		}
	}
}
