package com.pplive.p2p.network.protocol
{
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.RID;
	
	public class KernelStatusPacket extends PeerResponsePacket
	{
		
		public static const ACTION:uint = 216;
		
		public var downloadSpeed:uint;
		
		public var vipAcceleratedSpeed:uint;
		
		public function KernelStatusPacket(param1:uint, param2:RID, param3:uint, param4:uint)
		{
			super(ACTION,param1,param2);
			this.downloadSpeed = param3;
			this.vipAcceleratedSpeed = param4;
		}
		
		override public function fromByteArray(param1:ByteArray) : void
		{
			super.fromByteArray(param1);
			this.downloadSpeed = param1.readUnsignedInt();
			this.vipAcceleratedSpeed = param1.readUnsignedInt();
		}
	}
}
