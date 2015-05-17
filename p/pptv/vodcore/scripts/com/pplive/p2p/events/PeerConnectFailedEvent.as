package com.pplive.p2p.events
{
	import flash.events.Event;
	import com.pplive.p2p.struct.PeerInfo;
	
	public class PeerConnectFailedEvent extends Event
	{
		
		public static const PEER_CONNECT_FAILED:String = "__PEER_CONNECT_FAILED__";
		
		public var peer:PeerInfo;
		
		public function PeerConnectFailedEvent(param1:PeerInfo)
		{
			super(PEER_CONNECT_FAILED);
			this.peer = param1;
		}
		
		override public function clone() : Event
		{
			return new PeerConnectFailedEvent(this.peer);
		}
	}
}
