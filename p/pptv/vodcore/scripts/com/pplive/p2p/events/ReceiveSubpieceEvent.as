package com.pplive.p2p.events
{
	import flash.events.Event;
	import com.pplive.p2p.struct.SubPiece;
	import flash.utils.ByteArray;
	
	public class ReceiveSubpieceEvent extends Event
	{
		
		public static const RECEIVE_SUBPIECE:String = "__RECEIVE_SUBPIECE__";
		
		public var subpiece:SubPiece;
		
		public var data:ByteArray;
		
		public function ReceiveSubpieceEvent(param1:SubPiece, param2:ByteArray)
		{
			super(RECEIVE_SUBPIECE);
			this.subpiece = param1;
			this.data = param2;
		}
		
		override public function clone() : Event
		{
			return new ReceiveSubpieceEvent(this.subpiece,this.data);
		}
	}
}
