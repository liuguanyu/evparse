package com.pplive.p2p.network.protocol
{
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.RID;
	
	public class ReportRestPlayTimePacket extends PeerRequestPacket
	{
		
		public static const ACTION:uint = 208;
		
		private var _restPlayTimeInSeconds:uint;
		
		public function ReportRestPlayTimePacket(param1:RID, param2:uint)
		{
			super(ACTION,Packet.NewTransactionID(),param1,Packet.PROTOCOL_VERSION);
			this._restPlayTimeInSeconds = param2;
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			_loc1.writeShort(this._restPlayTimeInSeconds);
			return _loc1;
		}
	}
}
