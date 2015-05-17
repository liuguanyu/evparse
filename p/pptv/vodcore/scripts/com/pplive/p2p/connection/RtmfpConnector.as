package com.pplive.p2p.connection
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.Dictionary;
	import com.pplive.p2p.BootStrapConfig;
	import flash.utils.getTimer;
	import com.pplive.p2p.struct.RtmfpPeerInfo;
	import com.pplive.p2p.P2PServices;
	import com.pplive.net.RtmfpStream;
	import com.pplive.events.RtmfpEvent;
	import com.pplive.p2p.events.PeerConnectedEvent;
	import com.pplive.p2p.events.PeerConnectFailedEvent;
	
	class RtmfpConnector extends Monitable
	{
		
		private static var logger:ILogger = getLogger(RtmfpConnector);
		
		private var _pendings:Dictionary;
		
		private var _pendingCount:uint;
		
		private var _preConnectTime:uint;
		
		function RtmfpConnector()
		{
			this._pendings = new Dictionary();
			super("RtmfpConnector");
		}
		
		public function get pendingCount() : uint
		{
			return this._pendingCount;
		}
		
		public function get canConnect() : Boolean
		{
			if(this._pendingCount >= BootStrapConfig.RTMFP_P2P_CONNECT_MAX_PENDING_COUNT)
			{
				return false;
			}
			var _loc1:Number = 1000 / BootStrapConfig.RTMFP_P2P_CONNECT_RATE;
			return this._preConnectTime + _loc1 < getTimer();
		}
		
		public function start() : void
		{
		}
		
		public function stop() : void
		{
			var _loc1:* = undefined;
			for(_loc1 in this._pendings)
			{
				this.dropPending(_loc1,true);
			}
		}
		
		public function connect(param1:RtmfpPeerInfo) : void
		{
			var _loc2:RtmfpStream = P2PServices.instance.rtmfp.createRtmfpStream();
			var _loc3:Pending = new Pending(param1,_loc2);
			this._pendings[_loc2] = _loc3;
			this._pendingCount++;
			this._preConnectTime = getTimer();
			monitor.addChild(_loc3.monitor);
			_loc2.addEventListener(RtmfpEvent.RTMFP_CONNECT_PEER_SUCCESS,this.onConnected,false,0,true);
			_loc2.addEventListener(RtmfpEvent.RTMFP_CONNECT_PEER_FAIL,this.onConnectFailed,false,0,true);
			_loc2.connect(param1.id,BootStrapConfig.RTMFP_MEDIA,BootStrapConfig.RTMFP_P2P_CONNECT_TIMEOUT * 1000);
		}
		
		private function dropPending(param1:RtmfpStream, param2:Boolean) : Pending
		{
			var _loc3:Pending = this._pendings[param1];
			delete this._pendings[param1];
			true;
			if(_loc3)
			{
				this._pendingCount--;
				monitor.removeChild(_loc3.monitor);
			}
			param1.removeEventListener(RtmfpEvent.RTMFP_CONNECT_PEER_SUCCESS,this.onConnected);
			param1.removeEventListener(RtmfpEvent.RTMFP_CONNECT_PEER_FAIL,this.onConnectFailed);
			if(param2)
			{
				param1.close();
			}
			return _loc3;
		}
		
		private function onConnected(param1:RtmfpEvent) : void
		{
			var _loc2:RtmfpStream = param1.target as RtmfpStream;
			var _loc3:Pending = this.dropPending(_loc2,false);
			if(_loc3)
			{
				dispatchEvent(new PeerConnectedEvent(new RtmfpPeerConnection(_loc3.peer,_loc2,false)));
			}
			else
			{
				logger.error("onConnected: stream not found");
				_loc2.close();
			}
		}
		
		private function onConnectFailed(param1:RtmfpEvent) : void
		{
			var _loc2:RtmfpStream = param1.target as RtmfpStream;
			var _loc3:Pending = this.dropPending(_loc2,true);
			if(_loc3)
			{
				dispatchEvent(new PeerConnectFailedEvent(_loc3.peer));
			}
			else
			{
				logger.error("onConnecFailed: stream not found");
				_loc2.close();
			}
		}
	}
}

import com.pplive.monitor.Monitable;
import com.pplive.p2p.struct.RtmfpPeerInfo;
import com.pplive.net.RtmfpStream;
import flash.utils.getTimer;

class Pending extends Monitable
{
	
	public var peer:RtmfpPeerInfo;
	
	public var stream:RtmfpStream;
	
	public var starttime:uint;
	
	function Pending(param1:RtmfpPeerInfo, param2:RtmfpStream)
	{
		this.starttime = getTimer();
		super("Pending");
		this.peer = param1;
		this.stream = param2;
	}
}
