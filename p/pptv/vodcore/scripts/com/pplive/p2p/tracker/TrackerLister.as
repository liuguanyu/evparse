package com.pplive.p2p.tracker
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.struct.TrackerInfo;
	import flash.utils.getTimer;
	import com.pplive.p2p.struct.RID;
	import com.pplive.p2p.events.GetPeersEvent;
	import com.pplive.p2p.events.SimpleEvent;
	import com.pplive.p2p.Util;
	
	public class TrackerLister extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(TrackerLister);
		
		private static const MIN_LIST_DELAY:uint = 120 * 1000;
		
		private var _trackers:Vector.<TrackerInfo>;
		
		private var _preListTime:Vector.<uint>;
		
		private var _index:uint;
		
		private var _connections:Vector.<TrackerListConnection>;
		
		public function TrackerLister()
		{
			this._preListTime = new Vector.<uint>();
			this._connections = new Vector.<TrackerListConnection>();
			super();
		}
		
		public function start(param1:Vector.<TrackerInfo>) : void
		{
			if((this._trackers == null) && (param1) && param1.length > 0)
			{
				this._trackers = param1;
				this._index = 0;
				this._preListTime.length = this._trackers.length;
			}
		}
		
		public function stop() : void
		{
			while(this._connections.length > 0)
			{
				this.dropConnection(this._connections[0]);
			}
		}
		
		public function get canList() : Boolean
		{
			return (this._trackers) && this._trackers.length > 0 && (this._preListTime[this._index] == 0 || this._preListTime[this._index] + MIN_LIST_DELAY < getTimer());
		}
		
		public function get trackerCount() : uint
		{
			return this._trackers?this._trackers.length:0;
		}
		
		public function list(param1:RID, param2:uint, param3:uint) : void
		{
			var _loc4:TrackerInfo = null;
			var _loc5:TrackerListConnection = null;
			if(this._trackers != null)
			{
				_loc4 = this._trackers[this._index];
				this._preListTime[_loc6] = getTimer();
				if(this._index == this._trackers.length)
				{
					this._index = 0;
				}
				_loc5 = new TrackerListConnection(_loc4,param1,param2,param3);
				this._connections.push(_loc5);
				_loc5.addEventListener(GetPeersEvent.GET_PEERS,this.onGetPeers,false,0,true);
				_loc5.addEventListener(SimpleEvent.TRACKER_LIST_FAIL,this.onListFailed,false,0,true);
				_loc5.start();
			}
		}
		
		private function dropConnection(param1:TrackerListConnection) : void
		{
			Util.removeFromArray(this._connections,param1);
			param1.removeEventListener(GetPeersEvent.GET_PEERS,this.onGetPeers);
			param1.removeEventListener(SimpleEvent.TRACKER_LIST_FAIL,this.onListFailed);
			param1.close();
		}
		
		private function onGetPeers(param1:GetPeersEvent) : void
		{
			this.dropConnection(param1.target as TrackerListConnection);
			dispatchEvent(param1);
		}
		
		private function onListFailed(param1:SimpleEvent) : void
		{
			var _loc2:TrackerListConnection = param1.target as TrackerListConnection;
			logger.error("tracker list failed: " + _loc2.trackerInfo.ip);
			this.dropConnection(_loc2);
			dispatchEvent(new SimpleEvent(SimpleEvent.TRACKER_LIST_FAIL,_loc2.rid));
		}
	}
}
