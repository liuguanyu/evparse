package com.pplive.p2p.download
{
	import com.pplive.monitor.Monitable;
	import com.pplive.p2p.connection.PeerConnection;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import com.pplive.p2p.struct.Constants;
	
	class PeerDispatchControl extends Monitable
	{
		
		protected var _connection:PeerConnection;
		
		protected var _p2pState:P2PState;
		
		protected var _createTime:uint;
		
		protected var _rtt:int = 3000;
		
		protected var _windowSize:uint = 10;
		
		protected var _pendingRequests:Dictionary;
		
		protected var _pendingCount:uint;
		
		protected var _timeoutCount:uint;
		
		protected var _totalBytes:uint;
		
		public var offset:uint;
		
		function PeerDispatchControl(param1:PeerConnection, param2:P2PState, param3:uint)
		{
			this._createTime = getTimer();
			this._pendingRequests = new Dictionary();
			super("PeerDispatchControl");
			this._connection = param1;
			this._p2pState = param2;
			this.offset = param3;
		}
		
		public function get createTime() : uint
		{
			return this._createTime;
		}
		
		public function get pendingCount() : uint
		{
			return this._pendingCount;
		}
		
		public function get windowSize() : uint
		{
			return this._windowSize;
		}
		
		public function onTimer() : void
		{
		}
		
		public function addRequest(param1:uint, param2:uint) : void
		{
			if(this._pendingRequests[param1] == undefined)
			{
				this._pendingCount++;
			}
			this._pendingRequests[param1] = param2;
		}
		
		public function dropRequest(param1:uint) : void
		{
			if(this._pendingRequests[param1] != undefined)
			{
				delete this._pendingRequests[param1];
				true;
				this._pendingCount--;
			}
		}
		
		public function dropAllRequests(param1:Vector.<uint> = null) : void
		{
			var _loc2:* = undefined;
			if(param1)
			{
				for(_loc2 in this._pendingRequests)
				{
					param1.push(_loc2);
				}
			}
			this._pendingRequests = new Dictionary();
			this._pendingCount = 0;
		}
		
		public function dropTimeoutedRequests(param1:Vector.<uint>, param2:uint) : void
		{
			var _loc4:* = undefined;
			var _loc5:uint = 0;
			var _loc6:uint = 0;
			var _loc3:uint = getTimer();
			for(_loc5 in this._pendingRequests)
			{
				_loc6 = _loc3 - this._pendingRequests[_loc5];
				if(_loc6 >= param2)
				{
					param1.push(_loc5);
					delete this._pendingRequests[_loc5];
					true;
					this._pendingCount--;
					this._timeoutCount++;
				}
			}
		}
		
		public function onReceiveSubpiece(param1:uint) : void
		{
			var _loc2:uint = 0;
			this._connection.stat.downloadSpeedMeter.submitBytes(Constants.SUBPIECE_SIZE);
			this._totalBytes = this._totalBytes + Constants.SUBPIECE_SIZE;
			if(this._pendingRequests[param1] != undefined)
			{
				_loc2 = getTimer() - this._pendingRequests[param1];
				delete this._pendingRequests[param1];
				true;
				this._pendingCount--;
				this.updateRTT(_loc2);
			}
		}
		
		protected function updateRTT(param1:uint) : void
		{
		}
		
		override public function updateMonitedAttributes(param1:Dictionary) : void
		{
			param1["type"] = this._connection.isRTMFP?"RTMFP":"TCP";
			param1["id"] = this._connection.peer.id;
			param1["speed"] = this._connection.stat.downloadSpeedMeter.getRecentSpeedInKBPS(2) + "|" + this._connection.stat.maxDownloadSpeed;
			param1["amount"] = this._totalBytes >> 10;
			param1["rtt"] = this._rtt;
			param1["announce-update-time"] = this._connection.blockMap?-int((getTimer() - this._connection.announceUpdateTime) / 1000) + "|" + this._connection.blockMap.validBlockCount:"--|--";
			param1["timeout"] = this._timeoutCount;
			param1["window-size"] = this._windowSize;
			param1["pending-count"] = this._pendingCount;
		}
	}
}
