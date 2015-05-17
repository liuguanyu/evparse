package com.pplive.p2p.network.protocol
{
	import com.pplive.p2p.struct.RID;
	import flash.utils.ByteArray;
	
	public class PeerRequestPacket extends Packet
	{
		
		public var rid:RID;
		
		public function PeerRequestPacket(param1:uint, param2:uint, param3:RID, param4:uint = 1)
		{
			super(param1,param2,param4);
			this.rid = param3;
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			_loc1.writeBytes(this.rid.bytes());
			return _loc1;
		}
		
		override public function fromByteArray(param1:ByteArray) : void
		{
			this.rid = new RID();
			super.fromByteArray(param1);
			this.rid.setBytes(param1);
		}
	}
}
