package com.pplive.p2p.download
{
	import com.pplive.monitor.Monitable;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.struct.RID;
	import com.pplive.p2p.connection.PeerConnection;
	import flash.utils.ByteArray;
	import com.pplive.p2p.connection.ConnectManager;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import com.pplive.p2p.P2PServices;
	import com.pplive.p2p.events.PeerConnectedEvent;
	import com.pplive.p2p.events.PeerAcceptedEvent;
	import flash.events.TimerEvent;
	import com.pplive.p2p.struct.Constants;
	import com.pplive.util.Assert;
	import com.pplive.p2p.BootStrapConfig;
	import com.pplive.p2p.events.ConnectionStatusEvent;
	import com.pplive.p2p.events.ReceiveSubpieceEvent;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	class P2PDownloader extends Monitable implements IDownloader
	{
		
		private static var logger:ILogger = getLogger(P2PDownloader);
		
		private static const MARK_EMPTY:int = 0;
		
		private static const MARK_PENDING:int = 1;
		
		private static const MARK_DISPATCHED:int = 2;
		
		private var _rid:RID;
		
		private var _length:uint;
		
		private var _headLength:uint;
		
		private var _connections:Vector.<PeerConnection>;
		
		private var _backupConnections:Vector.<PeerConnection>;
		
		private var _marks:ByteArray;
		
		private var _offset:uint;
		
		private var _connectManager:ConnectManager;
		
		private var _restPlayTime:Number = 0;
		
		private var _timer:Timer;
		
		private var _p2pState:P2PState;
		
		private var _preAnnounceTime:uint = 0;
		
		private var _preAddConnectionTime:uint;
		
		private var _startTime:uint;
		
		private var _stat:Stat;
		
		function P2PDownloader(param1:RID, param2:uint, param3:uint)
		{
			this._connections = new Vector.<PeerConnection>();
			this._backupConnections = new Vector.<PeerConnection>();
			this._marks = new ByteArray();
			this._timer = new Timer(250);
			this._p2pState = new P2PState();
			this._stat = new Stat();
			super("P2PDownloader");
			this._rid = param1;
			this._length = param2;
			this._headLength = param3;
			this._connectManager = new ConnectManager(param1);
			monitor.addChild(this._connectManager.monitor);
		}
		
		public function set restPlayTime(param1:Number) : void
		{
			this._restPlayTime = param1;
			this._p2pState.update(param1);
		}
		
		public function get stat() : Stat
		{
			return this._stat;
		}
		
		public function get connectStat() : *
		{
			return this._connectManager.stat;
		}
		
		public function get connectionFullTime() : uint
		{
			return this._stat.connectionFullTime;
		}
		
		public function get connectionCount() : uint
		{
			return this._connections.length;
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
		
		public function start() : void
		{
			var _loc1:PeerConnection = null;
			this._startTime = getTimer();
			for each(_loc1 in P2PServices.instance.connectionCache.connections)
			{
				if(_loc1.isFree)
				{
					_loc1.rid = this._rid;
					if(this._connections.length < this._p2pState.connectionNeeded && ((_loc1.isRTMFP) || !this._p2pState.isGood))
					{
						this.addConnection(_loc1);
					}
					else
					{
						this._backupConnections.push(_loc1);
					}
				}
			}
			this._preAnnounceTime = getTimer();
			this._connectManager.addEventListener(PeerConnectedEvent.PEER_CONNECTED,this.onPeerConnected,false,0,true);
			this._connectManager.start();
			P2PServices.instance.connectionCache.addEventListener(PeerAcceptedEvent.PEER_ACCEPTED,this.onPeerAccepted,false,0,true);
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
			this._timer.start();
		}
		
		public function destroy() : void
		{
			var _loc1:PeerConnection = null;
			this._offset = 0;
			this._marks = new ByteArray();
			for each(_loc1 in this._connections)
			{
				_loc1.rid = null;
			}
			for each(_loc1 in this._backupConnections)
			{
				_loc1.rid = null;
			}
			while(this._connections.length > 0)
			{
				this.removeConnection(this._connections.length - 1);
			}
			this._backupConnections.length = 0;
			this._connectManager.removeEventListener(PeerConnectedEvent.PEER_CONNECTED,this.onPeerConnected);
			this._connectManager.stop();
			P2PServices.instance.connectionCache.removeEventListener(PeerAcceptedEvent.PEER_ACCEPTED,this.onPeerAccepted);
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.stop();
			this._stat.destroy();
		}
		
		public function requestHeader() : void
		{
			this.request(0,this._headLength);
		}
		
		public function request(param1:uint, param2:uint) : void
		{
			var _loc4:PeerConnection = null;
			var _loc5:PeerDispatchControl = null;
			if(param2 > this._length || param2 == 0)
			{
				var param2:uint = this._length;
			}
			if(param1 >= param2)
			{
				return;
			}
			var param1:uint = param1 / Constants.SUBPIECE_SIZE;
			param2 = (param2 - 1) / Constants.SUBPIECE_SIZE + 1;
			if(this._marks.length < param2)
			{
				this._marks.length = param2;
			}
			var _loc3:* = -1;
			while(param1 < param2)
			{
				if(this._marks[param1] == MARK_EMPTY)
				{
					this._marks[param1] = MARK_PENDING;
					if(_loc3 < 0)
					{
						_loc3 = param1;
					}
				}
				param1++;
			}
			if(_loc3 >= 0)
			{
				if(this._offset > _loc3)
				{
					this._offset = _loc3;
				}
				for each(_loc4 in this._connections)
				{
					_loc5 = _loc4.client;
					Assert.isTrue(!(_loc5 == null));
					if(_loc5.offset > _loc3)
					{
						_loc5.offset = _loc3;
						this.doRequest(_loc4);
					}
				}
			}
		}
		
		public function cancel() : void
		{
			var _loc1:PeerConnection = null;
			var _loc2:PeerDispatchControl = null;
			this._offset = 0;
			this._marks = new ByteArray();
			for each(_loc1 in this._connections)
			{
				_loc2 = _loc1.client;
				Assert.isTrue(!(_loc2 == null));
				_loc2.dropAllRequests();
				_loc2.offset = 0;
			}
		}
		
		private function checkBackupConnections() : void
		{
			var _loc4:PeerConnection = null;
			var _loc1:uint = 0;
			var _loc2:uint = 0;
			var _loc3:uint = this._backupConnections.length;
			while(_loc2 < _loc3)
			{
				_loc4 = this._backupConnections[_loc2];
				if((_loc4.isOpen) && ((_loc4.isRTMFP) || getTimer() < this._startTime + 10 * 1000 || _loc4.lifetime < 10 || !_loc4.isEmpty))
				{
					this._backupConnections[_loc1++] = _loc4;
				}
				else
				{
					_loc4.rid = null;
				}
				_loc2++;
			}
			this._backupConnections.length = _loc1;
		}
		
		private function get isRtmfpUsable() : Boolean
		{
			return (BootStrapConfig.IS_UPDATED) && (BootStrapConfig.RTMFP_DOWNLOAD_ENABLED);
		}
		
		private function removeTcpConnections() : void
		{
			var _loc1:uint = 0;
			while(_loc1 < this._connections.length)
			{
				if(this._connections[_loc1].isRTMFP)
				{
					_loc1++;
				}
				else
				{
					this._backupConnections.push(this._connections[_loc1]);
					this.removeConnection(_loc1);
				}
			}
		}
		
		private function adjustConnections() : void
		{
			var speedCmp:Function = null;
			speedCmp = function(param1:PeerConnection, param2:PeerConnection):int
			{
				return param1.stat.maxDownloadSpeed - param2.stat.maxDownloadSpeed;
			};
			if((this._p2pState.isGood) && (this.isRtmfpUsable))
			{
				this.removeTcpConnections();
			}
			this.checkBackupConnections();
			this.kickConnections();
			this._backupConnections.sort(speedCmp);
			var i:int = this._backupConnections.length - 1;
			while(i >= 0 && this._connections.length < this._p2pState.connectionNeeded)
			{
				if(!this._backupConnections[i].isEmpty)
				{
					if((this._backupConnections[i].isRTMFP) || !this._p2pState.isGood)
					{
						this.addConnection(this._backupConnections[i]);
						this._backupConnections.splice(i,1);
					}
				}
				i--;
			}
		}
		
		private function get usableRtmfpCount() : uint
		{
			var _loc2:PeerConnection = null;
			var _loc1:uint = 0;
			for each(_loc2 in this._connections)
			{
				if((_loc2.isRTMFP) && !this.isEmpty(_loc2))
				{
					_loc1++;
				}
			}
			for each(_loc2 in this._backupConnections)
			{
				if((_loc2.isRTMFP) && !this.isEmpty(_loc2))
				{
					_loc1++;
				}
			}
			return _loc1;
		}
		
		private function get usableTcpCount() : uint
		{
			var _loc2:PeerConnection = null;
			var _loc1:uint = 0;
			for each(_loc2 in this._connections)
			{
				if(!_loc2.isRTMFP && !this.isEmpty(_loc2))
				{
					_loc1++;
				}
			}
			for each(_loc2 in this._backupConnections)
			{
				if(!_loc2.isRTMFP && !this.isEmpty(_loc2))
				{
					_loc1++;
				}
			}
			return _loc1;
		}
		
		private function isEmpty(param1:PeerConnection) : Boolean
		{
			return param1.lifetime >= 10 && getTimer() >= this._startTime + 10000 && (param1.isEmpty);
		}
		
		private function get goodRtmfpCount() : uint
		{
			var _loc2:PeerConnection = null;
			var _loc1:uint = 0;
			for each(_loc2 in this._connections)
			{
				if((_loc2.isRTMFP) && !this.isEmpty(_loc2) && _loc2.stat.maxDownloadSpeed >= 20)
				{
					_loc1++;
				}
			}
			for each(_loc2 in this._backupConnections)
			{
				if((_loc2.isRTMFP) && !this.isEmpty(_loc2) && _loc2.stat.maxDownloadSpeed >= 20)
				{
					_loc1++;
				}
			}
			return _loc1;
		}
		
		private function get goodTcpCount() : uint
		{
			var _loc2:PeerConnection = null;
			var _loc1:uint = 0;
			for each(_loc2 in this._connections)
			{
				if(!_loc2.isRTMFP && !this.isEmpty(_loc2) && _loc2.stat.maxDownloadSpeed >= 20)
				{
					_loc1++;
				}
			}
			for each(_loc2 in this._backupConnections)
			{
				if(!_loc2.isRTMFP && !this.isEmpty(_loc2) && _loc2.stat.maxDownloadSpeed >= 20)
				{
					_loc1++;
				}
			}
			return _loc1;
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
			var _loc2:PeerConnection = null;
			var _loc3:PeerConnection = null;
			var _loc4:PeerDispatchControl = null;
			if(this._offset < this._marks.length)
			{
				this.adjustConnections();
				this.checkTimeout(this._restPlayTime > 60?10 * 1000:5 * 1000);
				if(this._preAnnounceTime + BootStrapConfig.ANNOUNCE_UPDATE_INTERVAL < getTimer())
				{
					this._preAnnounceTime = getTimer();
					for each(_loc3 in this._connections)
					{
						_loc3.requestAnnounce();
					}
					for each(_loc3 in this._backupConnections)
					{
						_loc3.requestAnnounce();
					}
				}
				for each(_loc2 in this._connections)
				{
					_loc4 = _loc2.client;
					Assert.isTrue(!(_loc4 == null));
					_loc4.onTimer();
				}
			}
			this._connectManager.enableRTMFP = (this.isRtmfpUsable) && (this.usableRtmfpCount < 5 || this._restPlayTime < P2PState.REST_PLAY_TIME_HIGH_BOUND && this.goodRtmfpCount < 3);
			this._connectManager.enableTCP = this._restPlayTime < P2PState.REST_PLAY_TIME_HIGH_BOUND && (this.goodTcpCount < 5 || this.usableTcpCount < 20);
		}
		
		private function onPeerConnected(param1:PeerConnectedEvent) : void
		{
			param1.connection.rid = this._rid;
			if(this._connections.length < this._p2pState.connectionNeeded)
			{
				this.addConnection(param1.connection);
			}
			else
			{
				this._backupConnections.push(param1.connection);
			}
		}
		
		private function onPeerAccepted(param1:PeerAcceptedEvent) : void
		{
			if(param1.connection.isFree)
			{
				param1.connection.rid = this._rid;
				if(this._connections.length < this._p2pState.connectionNeeded)
				{
					this.addConnection(param1.connection);
				}
				else
				{
					this._backupConnections.push(param1.connection);
				}
			}
		}
		
		private function onConnectionClosed(param1:ConnectionStatusEvent) : void
		{
			var _loc2:int = this._connections.indexOf(param1.target);
			if(_loc2 >= 0)
			{
				this.removeConnection(_loc2);
			}
			else
			{
				Assert.isTrue(false);
				logger.error("onConnectionClosed: connection not found");
			}
		}
		
		private function onAnnounceUpdated(param1:ConnectionStatusEvent) : void
		{
			var _loc2:int = this._connections.indexOf(param1.target);
			if(_loc2 < 0)
			{
				Assert.isTrue(false);
				logger.error("onAnounceUpdated: connection not found");
				return;
			}
			var _loc3:PeerDispatchControl = this._connections[_loc2].client;
			Assert.isTrue(!(_loc3 == null));
			_loc3.offset = this._offset;
			this.doRequest(this._connections[_loc2]);
		}
		
		private function onReceiveSubpiece(param1:ReceiveSubpieceEvent) : void
		{
			var _loc2:uint = param1.subpiece.subPieceIndexInResource;
			var _loc3:PeerConnection = param1.target as PeerConnection;
			var _loc4:PeerDispatchControl = _loc3.client;
			Assert.isTrue(!(_loc4 == null));
			if(_loc3.isRTMFP)
			{
				this._stat.rtmfpSpeedMeter.submitBytes(Constants.SUBPIECE_SIZE);
			}
			else
			{
				this._stat.tcpSpeedMeter.submitBytes(Constants.SUBPIECE_SIZE);
			}
			_loc4.onReceiveSubpiece(_loc2);
			if(_loc2 < this._marks.length)
			{
				this._marks[_loc2] = MARK_EMPTY;
				while(this._offset < this._marks.length && this._marks[this._offset] == MARK_EMPTY)
				{
					this._offset++;
				}
			}
			if(_loc4.offset < this._offset)
			{
				_loc4.offset = this._offset;
			}
			this.doRequest(_loc3);
			dispatchEvent(param1);
			if(this._offset >= this._marks.length)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function handleReleasedRequests(param1:Vector.<uint>) : void
		{
			var _loc4:uint = 0;
			var _loc5:PeerConnection = null;
			var _loc6:PeerDispatchControl = null;
			var _loc2:uint = 1000 * 1000;
			var _loc3:uint = this._marks.length;
			for each(_loc4 in param1)
			{
				if(_loc4 >= this._offset && _loc4 < _loc3 && this._marks[_loc4] == MARK_DISPATCHED)
				{
					this._marks[_loc4] = MARK_PENDING;
					if(_loc2 > _loc4)
					{
						_loc2 = _loc4;
					}
				}
			}
			if(this._offset > _loc2)
			{
				this._offset = _loc2;
			}
			for each(_loc5 in this._connections)
			{
				_loc6 = _loc5.client;
				Assert.isTrue(!(_loc6 == null));
				if(_loc6.offset > _loc2)
				{
					_loc6.offset = _loc2;
					this.doRequest(_loc5);
				}
			}
		}
		
		private function addConnection(param1:PeerConnection) : void
		{
			this._connections.push(param1);
			this._preAddConnectionTime = getTimer();
			if(this._connections.length >= this._p2pState.connectionNeeded && this._stat.connectionFullTime == 0)
			{
				this._stat.connectionFullTime = getTimer() - this._startTime + 1;
			}
			var _loc2:PeerDispatchControl = param1.isRTMFP?new RtmfpPeerDispatchControl(param1,this._p2pState,this._offset):new TcpPeerDispatchControl(param1,this._p2pState,this._offset);
			param1.client = _loc2;
			param1.requestAnnounce();
			monitor.addChild(_loc2.monitor);
			param1.addEventListener(ConnectionStatusEvent.ANNOUNCE_UPDATED,this.onAnnounceUpdated,false,0,true);
			param1.addEventListener(ConnectionStatusEvent.CLOSED,this.onConnectionClosed,false,0,true);
			param1.addEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece,false,0,true);
			this.doRequest(param1);
		}
		
		private function removeConnection(param1:uint) : void
		{
			var _loc2:PeerConnection = this._connections[param1];
			this._connections.splice(param1,1);
			_loc2.removeEventListener(ConnectionStatusEvent.ANNOUNCE_UPDATED,this.onAnnounceUpdated);
			_loc2.removeEventListener(ConnectionStatusEvent.CLOSED,this.onConnectionClosed);
			_loc2.removeEventListener(ReceiveSubpieceEvent.RECEIVE_SUBPIECE,this.onReceiveSubpiece);
			var _loc3:PeerDispatchControl = _loc2.client;
			_loc2.client = null;
			Assert.isTrue(!(_loc3 == null));
			monitor.removeChild(_loc3.monitor);
			var _loc4:Vector.<uint> = new Vector.<uint>();
			_loc3.dropAllRequests(_loc4);
			this.handleReleasedRequests(_loc4);
		}
		
		private function checkTimeout(param1:uint) : void
		{
			var _loc3:PeerConnection = null;
			var _loc4:PeerDispatchControl = null;
			var _loc2:Vector.<uint> = new Vector.<uint>();
			for each(_loc3 in this._connections)
			{
				_loc4 = _loc3.client;
				Assert.isTrue(!(_loc4 == null));
				_loc4.dropTimeoutedRequests(_loc2,param1);
			}
			this.handleReleasedRequests(_loc2);
		}
		
		private function kickConnections() : void
		{
			var _loc2:PeerConnection = null;
			var _loc3:KickHelper = null;
			var _loc4:* = 0;
			var _loc1:Vector.<KickHelper> = new Vector.<KickHelper>();
			for each(_loc2 in this._connections)
			{
				_loc1.push(new KickHelper(_loc2));
			}
			_loc1.sort(KickHelper.cmp);
			while(_loc1.length > 0)
			{
				_loc3 = _loc1.pop();
				if(_loc3.isFresh)
				{
					break;
				}
				_loc4 = this._connections.indexOf(_loc3.connection);
				Assert.isTrue(_loc4 >= 0);
				if(_loc3.isEmpty)
				{
					this.removeConnection(_loc4);
					if(_loc3.connection.isRTMFP)
					{
						this._backupConnections.push(_loc3.connection);
					}
					else
					{
						_loc3.connection.rid = null;
					}
				}
				else
				{
					if(this._connections.length <= this._p2pState.connectionNeeded && (_loc3.currentSpeed >= 5 || _loc3.recentSpeed >= 3))
					{
						break;
					}
					this.removeConnection(_loc4);
					if(_loc3.currentSpeed > 0 || _loc3.recentSpeed >= 3 || _loc3.connection.stat.maxDownloadSpeed >= 5 || (_loc3.connection.isRTMFP))
					{
						this._backupConnections.push(_loc3.connection);
					}
					else
					{
						_loc3.connection.rid = null;
					}
				}
			}
		}
		
		private function doRequest(param1:PeerConnection) : void
		{
			var _loc2:PeerDispatchControl = param1.client;
			Assert.isTrue(!(_loc2 == null));
			var _loc3:uint = this._marks.length;
			var _loc4:uint = getTimer();
			while(_loc2.offset < _loc3 && _loc2.pendingCount < _loc2.windowSize)
			{
				if(this._marks[_loc2.offset] == MARK_PENDING && (param1.hasSubpiece(_loc2.offset)))
				{
					param1.requestSubpiece(_loc2.offset);
					_loc2.addRequest(_loc2.offset,_loc4);
					this._marks[_loc2.offset] = MARK_DISPATCHED;
				}
				_loc2.offset++;
			}
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["tcp-speed"] = this._stat.tcpSpeedMeter.getRecentSpeedInKBPS(2);
			param1["tcp-bytes"] = this._stat.tcpSpeedMeter.totalBytes;
			param1["rtmfp-speed"] = this._stat.rtmfpSpeedMeter.getRecentSpeedInKBPS(2);
			param1["rtmfp-bytes"] = this._stat.rtmfpSpeedMeter.totalBytes;
		}
	}
}

import com.pplive.p2p.SpeedMeter;

class Stat extends Object
{
	
	public var tcpSpeedMeter:SpeedMeter;
	
	public var rtmfpSpeedMeter:SpeedMeter;
	
	public var connectionFullTime:uint;
	
	function Stat()
	{
		this.tcpSpeedMeter = new SpeedMeter();
		this.rtmfpSpeedMeter = new SpeedMeter();
		super();
		this.tcpSpeedMeter.resume();
		this.rtmfpSpeedMeter.resume();
	}
	
	public function get avgSpeedInK() : uint
	{
		return this.tcpSpeedMeter.getTotalAvarageSpeedInKBPS() + this.rtmfpSpeedMeter.getTotalAvarageSpeedInKBPS();
	}
	
	public function get tcpDownloadedBytes() : uint
	{
		return this.tcpSpeedMeter.totalBytes;
	}
	
	public function get rtmfpDownloadedBytes() : uint
	{
		return this.rtmfpSpeedMeter.totalBytes;
	}
	
	public function destroy() : void
	{
		this.tcpSpeedMeter.destory();
		this.rtmfpSpeedMeter.destory();
	}
}
