package com.pplive.p2p.network.protocol
{
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.RID;
	
	public class AnnounceRequestPacket extends PeerRequestPacket
	{
		
		public static const ACTION:uint = 176;
		
		public function AnnounceRequestPacket(param1:uint, param2:RID, param3:uint = 1)
		{
			super(ACTION,param1,param2,param3);
		}
		
		override public function ToByteArray() : ByteArray
		{
			return super.ToByteArray();
		}
		
		override public function fromByteArray(param1:ByteArray) : void
		{
			super.fromByteArray(param1);
		}
	}
}
