package com.pplive.p2p.events
{
	import flash.events.Event;
	import com.pplive.p2p.struct.RID;
	import com.pplive.p2p.struct.PeerInfo;
	
	public class GetPeersEvent extends Event
	{
		
		public static const GET_PEERS:String = "_GET_PPERS_";
		
		public var rid:RID;
		
		public var peers:Vector.<PeerInfo>;
		
		public function GetPeersEvent(param1:RID, param2:Vector.<PeerInfo>)
		{
			super(GET_PEERS);
			this.rid = param1;
			this.peers = param2;
		}
		
		override public function clone() : Event
		{
			return new GetPeersEvent(this.rid,this.peers);
		}
	}
}
