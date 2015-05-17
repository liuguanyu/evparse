package com.pplive.p2p.connection
{
	import com.pplive.monitor.Monitable;
	import com.pplive.p2p.struct.RID;
	import com.pplive.p2p.struct.TcpPeerInfo;
	import com.pplive.p2p.struct.RtmfpPeerInfo;
	import flash.utils.Timer;
	import com.pplive.p2p.P2PServices;
	import com.pplive.p2p.events.GetPeersEvent;
	import com.pplive.p2p.events.PeerConnectedEvent;
	import com.pplive.p2p.events.PeerConnectFailedEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import com.pplive.p2p.Util;
	import flash.utils.Dictionary;
	import com.pplive.p2p.struct.PeerInfo;
	
	public class ConnectManager extends Monitable
	{
		
		private var _rid:RID;
		
		private var _tcpConnector:TcpConnector;
		
		private var _rtmfpConnector:RtmfpConnector;
		
		private var _enableTCP:Boolean = false;
		
		private var _enableRTMFP:Boolean = false;
		
		private var _tcpPeers:Vector.<TcpPeerInfo>;
		
		private var _rtmfpPeers:Vector.<RtmfpPeerInfo>;
		
		private var _timer:Timer;
		
		private var _listInterval:uint = 15000.0;
		
		private var _nextListTime:uint;
		
		private var _stat:Stat;
		
		public function ConnectManager(param1:RID)
		{
			this._tcpConnector = new TcpConnector();
			this._rtmfpConnector = new RtmfpConnector();
			this._tcpPeers = new Vector.<TcpPeerInfo>();
			this._rtmfpPeers = new Vector.<RtmfpPeerInfo>();
			this._timer = new Timer(250);
			this._stat = new Stat();
			super("ConnectManager");
			this._rid = param1;
		}
		
		public function get stat() : Stat
		{
			return this._stat;
		}
		
		public function set enableTCP(param1:Boolean) : void
		{
			this._enableTCP = param1;
		}
		
		public function set enableRTMFP(param1:Boolean) : void
		{
			this._enableRTMFP = param1;
		}
		
		public function start() : void
		{
			P2PServices.instance.p2p.addEventListener(GetPeersEvent.GET_PEERS,this.onGetPeers,false,0,true);
			P2PServices.instance.p2p.list(this._rid,100,100);
			this._stat.listCount++;
			this._tcpConnector.addEventListener(PeerConnectedEvent.PEER_CONNECTED,this.onPeerConnected,false,0,true);
			this._tcpConnector.addEventListener(PeerConnectFailedEvent.PEER_CONNECT_FAILED,this.onConnectFailed,false,0,true);
			this._tcpConnector.start();
			this._rtmfpConnector.addEventListener(PeerConnectedEvent.PEER_CONNECTED,this.onPeerConnected,false,0,true);
			this._rtmfpConnector.addEventListener(PeerConnectFailedEvent.PEER_CONNECT_FAILED,this.onConnectFailed,false,0,true);
			this._rtmfpConnector.start();
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
			this._timer.start();
		}
		
		public function stop() : void
		{
			P2PServices.instance.p2p.removeEventListener(GetPeersEvent.GET_PEERS,this.onGetPeers);
			this._tcpConnector.removeEventListener(PeerConnectedEvent.PEER_CONNECTED,this.onPeerConnected);
			this._tcpConnector.removeEventListener(PeerConnectFailedEvent.PEER_CONNECT_FAILED,this.onConnectFailed);
			this._tcpConnector.stop();
			this._rtmfpConnector.removeEventListener(PeerConnectedEvent.PEER_CONNECTED,this.onPeerConnected);
			this._rtmfpConnector.removeEventListener(PeerConnectFailedEvent.PEER_CONNECT_FAILED,this.onConnectFailed);
			this._rtmfpConnector.stop();
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.stop();
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			if((this._enableTCP) && this._tcpPeers.length > 0 && (this._tcpConnector.canConnect))
			{
				this._tcpConnector.connect(this._tcpPeers.pop());
				this._stat.tcpConnectCount++;
			}
			if((this._enableRTMFP) && (this._rtmfpConnector.canConnect))
			{
				if(P2PServices.instance.resetedRtmfpPeers.length > 0)
				{
					this._rtmfpConnector.connect(P2PServices.instance.resetedRtmfpPeers.pop());
					this._stat.rtmfpConnectCount++;
				}
				else if(this._rtmfpPeers.length > 0)
				{
					this._rtmfpConnector.connect(this._rtmfpPeers.pop());
					this._stat.rtmfpConnectCount++;
				}
				
			}
			if((this._enableTCP) && this._tcpPeers.length == 0 || (this._enableRTMFP) && this._rtmfpPeers.length == 0)
			{
				if(this._nextListTime < getTimer() && (P2PServices.instance.p2p.canList))
				{
					P2PServices.instance.p2p.list(this._rid,this._tcpPeers.length < 50?100:0,this._rtmfpPeers.length < 50?100:0);
					this._stat.listCount++;
					if(this._stat.listCount >= P2PServices.instance.p2p.trackerCount)
					{
						this._listInterval = Util.min(this._listInterval * 2,2 * 60 * 1000);
					}
					this._nextListTime = getTimer() + this._listInterval;
				}
			}
		}
		
		private function onGetPeers(param1:GetPeersEvent) : void
		{
			var peer:PeerInfo = null;
			var connection:PeerConnection = null;
			var cmp:Function = null;
			var e:GetPeersEvent = param1;
			cmp = function(param1:PeerInfo, param2:PeerInfo):int
			{
				return int(param1.trackerPriority) - int(param2.trackerPriority);
			};
			if(!this._rid.isEqual(e.rid) || e.peers.length == 0)
			{
				return;
			}
			var peerids:Dictionary = new Dictionary();
			for each(connection in P2PServices.instance.connectionCache.connections)
			{
				peerids[connection.peer.id] = true;
			}
			for each(peer in this._tcpPeers)
			{
				peerids[peer.id] = true;
			}
			for each(peer in this._rtmfpPeers)
			{
				peerids[peer.id] = true;
			}
			for each(peer in e.peers)
			{
				if(peerids[peer.id] == undefined)
				{
					peerids[peer.id] = true;
					if(peer is TcpPeerInfo)
					{
						this._tcpPeers.push(peer);
						this._stat.tcpPeers++;
					}
					else if(peer is RtmfpPeerInfo)
					{
						this._rtmfpPeers.push(peer);
						this._stat.rtmfpPeers++;
					}
					
				}
			}
			this._tcpPeers.sort(cmp);
			this._rtmfpPeers.sort(cmp);
		}
		
		private function onPeerConnected(param1:PeerConnectedEvent) : void
		{
			if(param1.connection.isRTMFP)
			{
				this._stat.rtmfpSuccessCount++;
			}
			else
			{
				this._stat.tcpSuccessCount++;
			}
			P2PServices.instance.connectionCache.addConnection(param1.connection);
			dispatchEvent(param1);
		}
		
		private function onConnectFailed(param1:PeerConnectFailedEvent) : void
		{
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["tcp-peers"] = this._tcpPeers.length + "|" + this._tcpConnector.pendingCount;
			param1["tcp-connect-count"] = this._stat.tcpConnectCount;
			param1["tcp-success-count"] = this._stat.tcpSuccessCount;
			param1["rtmfp-peers"] = this._rtmfpPeers.length + "|" + this._rtmfpConnector.pendingCount;
			param1["rtmfp-connect-count"] = this._stat.rtmfpConnectCount;
			param1["rtmfp-success-count"] = this._stat.rtmfpSuccessCount;
		}
	}
}

class Stat extends Object
{
	
	public var listCount:uint;
	
	public var tcpPeers:uint;
	
	public var tcpConnectCount:uint;
	
	public var tcpSuccessCount:uint;
	
	public var rtmfpPeers:uint;
	
	public var rtmfpConnectCount:uint;
	
	public var rtmfpSuccessCount:uint;
	
	function Stat()
	{
		super();
	}
	
	public function get queriedPeersCount() : uint
	{
		return this.tcpPeers + this.rtmfpPeers;
	}
}
