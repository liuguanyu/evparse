package com.pplive.p2p.network.protocol
{
	import flash.utils.ByteArray;
	
	public class ReportSpeedPacket extends Packet
	{
		
		public static const ACTION:uint = 180;
		
		public var speedInBytesPerSecond:uint;
		
		public function ReportSpeedPacket(param1:uint, param2:uint, param3:uint = 1)
		{
			super(ACTION,param1,param3);
			this.speedInBytesPerSecond = param2;
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			_loc1.writeUnsignedInt(this.speedInBytesPerSecond);
			return _loc1;
		}
	}
}
