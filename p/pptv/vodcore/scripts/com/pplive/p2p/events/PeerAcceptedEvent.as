package com.pplive.p2p.events
{
	import flash.events.Event;
	import com.pplive.p2p.connection.PeerConnection;
	
	public class PeerAcceptedEvent extends Event
	{
		
		public static const PEER_ACCEPTED:String = "__PEER_ACCEPTED__";
		
		public var connection:PeerConnection;
		
		public function PeerAcceptedEvent(param1:PeerConnection)
		{
			super(PEER_ACCEPTED);
			this.connection = param1;
		}
		
		override public function clone() : Event
		{
			return new PeerAcceptedEvent(this.connection);
		}
	}
}
