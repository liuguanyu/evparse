package com.pplive.p2p.network.protocol
{
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.RID;
	
	public class ReportStatusPacket extends PeerRequestPacket
	{
		
		public static const ACTION:uint = 216;
		
		public var isVip:Boolean;
		
		public function ReportStatusPacket(param1:RID, param2:Boolean)
		{
			super(ACTION,Packet.NewTransactionID(),param1);
			this.isVip = param2;
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			_loc1.writeBoolean(this.isVip);
			return _loc1;
		}
	}
}
