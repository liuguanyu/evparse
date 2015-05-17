package com.pplive.p2p.connection
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.pplive.p2p.P2PServices;
	import com.pplive.events.RtmfpEvent;
	import com.pplive.p2p.events.ConnectionStatusEvent;
	import com.pplive.p2p.Util;
	import com.pplive.net.RtmfpStream;
	import com.pplive.p2p.struct.RtmfpPeerInfo;
	import com.pplive.p2p.events.PeerAcceptedEvent;
	
	public class ConnectionCache extends Monitable
	{
		
		private static var logger:ILogger = getLogger(ConnectionCache);
		
		private var _connections:Vector.<PeerConnection>;
		
		private var _timer:Timer;
		
		private var _maxTcpCount:uint = 30;
		
		private var _maxRtmfpCount:uint = 15;
		
		public function ConnectionCache()
		{
			this._connections = new Vector.<PeerConnection>();
			this._timer = new Timer(250);
			super("ConnectionCache");
		}
		
		public function start() : void
		{
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
			this._timer.start();
			P2PServices.instance.rtmfpListener.addEventListener(RtmfpEvent.RTMFP_PEER_ACCEPTED,this.onRtmfpPeerAccepted,false,0,true);
		}
		
		public function close() : void
		{
			var _loc1:PeerConnection = null;
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.stop();
			P2PServices.instance.rtmfpListener.removeEventListener(RtmfpEvent.RTMFP_PEER_ACCEPTED,this.onRtmfpPeerAccepted);
			for each(_loc1 in this._connections)
			{
				_loc1.removeEventListener(ConnectionStatusEvent.CLOSED,this.onConnectionClosed);
				_loc1.close();
			}
			this._connections.length = 0;
		}
		
		public function set maxTcpCount(param1:uint) : void
		{
			this._maxTcpCount = param1;
		}
		
		public function set maxRtmfpCount(param1:uint) : void
		{
			this._maxRtmfpCount = param1;
		}
		
		public function get tcpCount() : uint
		{
			return this._connections.length - this.rtmfpCount;
		}
		
		public function get rtmfpCount() : uint
		{
			var _loc2:PeerConnection = null;
			var _loc1:uint = 0;
			for each(_loc2 in this._connections)
			{
				if(_loc2.isRTMFP)
				{
					_loc1++;
				}
			}
			return _loc1;
		}
		
		public function get connections() : Vector.<PeerConnection>
		{
			return this._connections;
		}
		
		public function addConnection(param1:PeerConnection) : void
		{
			this._connections.push(param1);
			param1.addEventListener(ConnectionStatusEvent.CLOSED,this.onConnectionClosed,false,0,true);
			monitor.addChild(param1.monitor);
		}
		
		public function dropConnection(param1:PeerConnection) : void
		{
			Util.removeFromArray(this._connections,param1);
			param1.removeEventListener(ConnectionStatusEvent.CLOSED,this.onConnectionClosed);
			monitor.removeChild(param1.monitor);
		}
		
		private function onConnectionClosed(param1:ConnectionStatusEvent) : void
		{
			this.dropConnection(param1.target as PeerConnection);
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			var _loc2:PeerConnection = null;
			for each(_loc2 in this._connections)
			{
				_loc2.onTimer();
			}
			this.kickConnections();
		}
		
		private function onRtmfpPeerAccepted(param1:RtmfpEvent) : void
		{
			var _loc2:RtmfpStream = param1.info;
			var _loc3:RtmfpPeerInfo = new RtmfpPeerInfo(0,_loc2.peerID,255 * Math.random(),255 * Math.random());
			var _loc4:RtmfpPeerConnection = new RtmfpPeerConnection(_loc3,_loc2,true);
			this.addConnection(_loc4);
			dispatchEvent(new PeerAcceptedEvent(_loc4));
		}
		
		private function kickConnections() : void
		{
			var _loc3:PeerConnection = null;
			var _loc4:* = 0;
			var _loc5:* = 0;
			var _loc6:SortInfo = null;
			var _loc1:Vector.<SortInfo> = new Vector.<SortInfo>();
			var _loc2:Vector.<SortInfo> = new Vector.<SortInfo>();
			for each(_loc3 in this._connections)
			{
				if(_loc3.freetime >= 10)
				{
					if(_loc3.isRTMFP)
					{
						_loc2.push(new SortInfo(_loc3));
					}
					else
					{
						_loc1.push(new SortInfo(_loc3));
					}
				}
			}
			_loc1.sort(SortInfo.cmp);
			_loc2.sort(SortInfo.cmp);
			_loc4 = int(this.tcpCount) - int(this._maxTcpCount);
			_loc5 = int(this.rtmfpCount) - int(this._maxRtmfpCount);
			while(_loc4-- >= 0 && _loc1.length > 0)
			{
				_loc6 = _loc1.pop();
				this.dropConnection(_loc6.connection);
				_loc6.connection.close();
			}
			while(_loc5-- >= 0 && _loc2.length > 0)
			{
				_loc6 = _loc2.pop();
				this.dropConnection(_loc6.connection);
				_loc6.connection.close();
			}
		}
	}
}

import com.pplive.p2p.connection.PeerConnection;

class SortInfo extends Object
{
	
	public var connection:PeerConnection;
	
	public var currentSpeed:int;
	
	public var recentSpeed:int;
	
	function SortInfo(param1:PeerConnection)
	{
		super();
		this.connection = param1;
		this.currentSpeed = param1.stat.uploadSpeedMeter.getRecentSpeedInKBPS(5);
		this.recentSpeed = param1.stat.uploadSpeedMeter.getRecentSpeedInKBPS(30);
	}
	
	public static function cmp(param1:SortInfo, param2:SortInfo) : int
	{
		if(param1.currentSpeed >= 20 || param2.currentSpeed >= 20)
		{
			return param2.currentSpeed - param1.currentSpeed;
		}
		return param2.recentSpeed - param1.recentSpeed;
	}
}
