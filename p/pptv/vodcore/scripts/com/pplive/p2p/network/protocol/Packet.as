package com.pplive.p2p.network.protocol
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class Packet extends Object
	{
		
		public static const PROTOCOL_VERSION_V0:uint = 0;
		
		public static const PROTOCOL_VERSION_V1:uint = 1;
		
		public static const PROTOCOL_VERSION:uint = PROTOCOL_VERSION_V1;
		
		private static var globalTransactionID:uint = 0;
		
		public var action:uint;
		
		public var transactionId:uint;
		
		public var protocolVersion:uint;
		
		public function Packet(param1:uint, param2:uint, param3:uint = 1)
		{
			super();
			this.action = param1;
			this.transactionId = param2;
			this.protocolVersion = param3;
		}
		
		public static function NewTransactionID() : uint
		{
			return globalTransactionID++;
		}
		
		public function fromByteArray(param1:ByteArray) : void
		{
			this.action = param1.readUnsignedByte();
			this.transactionId = param1.readUnsignedInt();
			this.protocolVersion = param1.readUnsignedShort();
		}
		
		public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = new ByteArray();
			_loc1.endian = Endian.LITTLE_ENDIAN;
			_loc1.writeByte(this.action);
			_loc1.writeUnsignedInt(this.transactionId);
			_loc1.writeShort(this.protocolVersion);
			return _loc1;
		}
	}
}
