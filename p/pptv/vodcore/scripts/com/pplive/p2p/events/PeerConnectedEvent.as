package com.pplive.p2p.events
{
	import flash.events.Event;
	import com.pplive.p2p.connection.PeerConnection;
	
	public class PeerConnectedEvent extends Event
	{
		
		public static const PEER_CONNECTED:String = "__PEER_CONNECTED__";
		
		public var connection:PeerConnection;
		
		public function PeerConnectedEvent(param1:PeerConnection)
		{
			super(PEER_CONNECTED);
			this.connection = param1;
		}
		
		override public function clone() : Event
		{
			return new PeerConnectedEvent(this.connection);
		}
	}
}
