package com.pplive.p2p
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.tracker.TrackerLister;
	import com.pplive.p2p.tracker.TrackerReporter;
	import com.pplive.p2p.struct.TrackerInfo;
	import com.pplive.p2p.struct.RID;
	import com.pplive.p2p.events.GetPeersEvent;
	import com.pplive.p2p.events.SimpleEvent;
	import com.pplive.util.GUID;
	
	public class P2PModule extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(P2PModule);
		
		private var _guid:String;
		
		private var _lister:TrackerLister;
		
		private var _reporter:TrackerReporter;
		
		public function P2PModule()
		{
			this._guid = GUID.create();
			this._lister = new TrackerLister();
			this._reporter = new TrackerReporter();
			super();
			this._lister.addEventListener(GetPeersEvent.GET_PEERS,this.onGetPeers,false,0,true);
			this._lister.addEventListener(SimpleEvent.TRACKER_LIST_FAIL,this.onListPeerFailed,false,0,true);
		}
		
		public function get guid() : String
		{
			return this._guid;
		}
		
		public function get canList() : Boolean
		{
			return this._lister.canList;
		}
		
		public function enableList(param1:Vector.<TrackerInfo>) : void
		{
			this._lister.start(param1);
		}
		
		public function enableReport(param1:Vector.<TrackerInfo>) : void
		{
			this._reporter.start(param1);
		}
		
		public function stopList() : void
		{
			this._lister.stop();
		}
		
		public function stopReport() : void
		{
			this._reporter.stop();
		}
		
		public function get trackerCount() : uint
		{
			return this._lister.trackerCount;
		}
		
		public function list(param1:RID, param2:uint, param3:uint) : void
		{
			this._lister.list(param1,param2,param3);
		}
		
		public function doReport() : void
		{
			if(this._reporter.isRunning)
			{
				this._reporter.report();
			}
		}
		
		private function onGetPeers(param1:GetPeersEvent) : void
		{
			dispatchEvent(param1);
		}
		
		private function onListPeerFailed(param1:SimpleEvent) : void
		{
			dispatchEvent(param1);
		}
	}
}
