package com.pplive.net
{
	import flash.events.EventDispatcher;
	import com.pplive.monitor.IMonitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.net.NetConnection;
	import com.pplive.monitor.Monitor;
	import com.pplive.events.RtmfpEvent;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class RtmfpModule extends EventDispatcher implements IMonitable
	{
		
		private static var logger:ILogger = getLogger(RtmfpModule);
		
		private var _serverConnection:NetConnection;
		
		private var _peerID:String;
		
		private var _maxPeerConnections:uint = 8;
		
		private var _rtmfpServer:String;
		
		private var _timeoutMS:uint;
		
		private var _tryCount:uint;
		
		private var _error:String;
		
		private var _pendingErrorHandlerId:uint;
		
		private var _monitor:Monitor;
		
		private var _stat:Stat;
		
		public function RtmfpModule()
		{
			this._stat = new Stat();
			super();
			this._monitor = new Monitor("RtmfpModule",this);
		}
		
		public function start(param1:String, param2:uint, param3:int) : void
		{
			if(this._serverConnection)
			{
				return;
			}
			this._serverConnection = new NetConnection();
			this._rtmfpServer = param1;
			this._timeoutMS = param2;
			this._tryCount = param3;
			this.connectServer();
		}
		
		public function stop() : void
		{
			if(this.isStarted)
			{
				this.doStop(new RtmfpEvent(RtmfpEvent.RTMFP_STOP));
			}
			else if(this._serverConnection)
			{
				this.doStop(new RtmfpEvent(RtmfpEvent.RTMFP_START_FAIL,"canceled"));
			}
			
		}
		
		public function get stat() : Stat
		{
			return this._stat;
		}
		
		public function get isStarted() : Boolean
		{
			return (this._serverConnection) && (this._serverConnection.connected);
		}
		
		public function get isStarting() : Boolean
		{
			return (this._serverConnection) && !this._serverConnection.connected;
		}
		
		public function get peerID() : String
		{
			return this._peerID;
		}
		
		public function set maxPeerConnections(param1:uint) : void
		{
			this._maxPeerConnections = param1;
			if(this.isStarted)
			{
				this._serverConnection.maxPeerConnections = param1;
			}
		}
		
		public function createRtmfpStream(param1:NetStream = null) : RtmfpStream
		{
			return new RtmfpStream(this,param1);
		}
		
		public function createPeerNetStream(param1:String) : NetStream
		{
			return this.isStarted?new NetStream(this._serverConnection,param1):null;
		}
		
		public function createPublishNetStream() : NetStream
		{
			return this.isStarted?new NetStream(this._serverConnection,NetStream.DIRECT_CONNECTIONS):null;
		}
		
		public function createListener() : RtmfpListener
		{
			return new RtmfpListener(this);
		}
		
		private function connectServer() : void
		{
			this._serverConnection.removeEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
			try
			{
				this._serverConnection.close();
			}
			catch(e:*)
			{
			}
			this._serverConnection.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler,false,0,true);
			clearTimeout(this._pendingErrorHandlerId);
			this._pendingErrorHandlerId = setTimeout(function():void
			{
				if(_tryCount > 0)
				{
					_tryCount--;
					connectServer();
				}
				else
				{
					doStop(new RtmfpEvent(RtmfpEvent.RTMFP_START_FAIL,"timeout"));
				}
			},this._timeoutMS);
			try
			{
				this._serverConnection.connect(this._rtmfpServer);
			}
			catch(e:Error)
			{
				doStop(new RtmfpEvent(RtmfpEvent.RTMFP_START_FAIL,e.message));
			}
		}
		
		private function doStop(param1:Event) : void
		{
			var event:Event = param1;
			if(this._serverConnection)
			{
				clearTimeout(this._pendingErrorHandlerId);
				this._pendingErrorHandlerId = 0;
				this._serverConnection.removeEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
				try
				{
					this._serverConnection.close();
				}
				catch(e:*)
				{
				}
				this._serverConnection = null;
				this._peerID = null;
				if(event)
				{
					dispatchEvent(event);
				}
			}
		}
		
		private function netStatusHandler(param1:NetStatusEvent) : void
		{
			switch(param1.info.code)
			{
				case "NetConnection.Connect.Closed":
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.Rejected":
					clearTimeout(this._pendingErrorHandlerId);
					this._pendingErrorHandlerId = setTimeout(this.handleNetStatusEvent,10,param1);
					break;
				default:
					this.handleNetStatusEvent(param1);
			}
		}
		
		private function handleNetStatusEvent(param1:NetStatusEvent) : void
		{
			var _loc2:NetStream = null;
			if(param1.info.hasOwnProperty("stream"))
			{
				_loc2 = param1.info.stream;
				if(_loc2.client == _loc2 || !_loc2.client)
				{
					PendingIncomeStream.setupPending(this,_loc2);
				}
				_loc2.dispatchEvent(param1);
				return;
			}
			switch(param1.info.code)
			{
				case "NetConnection.Connect.Success":
					this._peerID = this._serverConnection.nearID;
					logger.info("rtmfp started: " + this._peerID);
					clearTimeout(this._pendingErrorHandlerId);
					this._pendingErrorHandlerId = 0;
					this._serverConnection.maxPeerConnections = this._maxPeerConnections;
					dispatchEvent(new RtmfpEvent(RtmfpEvent.RTMFP_START_SUCCESS));
					break;
				case "NetConnection.Connect.Closed":
					this.doStop(new RtmfpEvent(RtmfpEvent.RTMFP_STOP));
					break;
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.Rejected":
					logger.error("fail to start rtmfp: " + param1.info.code);
					this._error = param1.info.code;
					if(this._tryCount > 0)
					{
						this._tryCount--;
						this.connectServer();
					}
					else
					{
						this.doStop(new RtmfpEvent(RtmfpEvent.RTMFP_START_FAIL,this._error));
					}
					break;
				default:
					logger.info("rtmfp server connecton net-status: " + param1.info.code);
			}
		}
		
		public function get monitor() : Monitor
		{
			return this._monitor;
		}
		
		public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["connected"] = this.isStarted;
			if(this.isStarted)
			{
				param1["flashid"] = this.peerID;
			}
			else if(this._error)
			{
				param1["error"] = this._error;
			}
			
		}
	}
}

class Stat extends Object
{
	
	public var connectionSetupCount:uint;
	
	public var connectCount:uint;
	
	function Stat()
	{
		super();
	}
	
	public function reset() : void
	{
		this.connectionSetupCount = 0;
		this.connectCount = 0;
	}
}
