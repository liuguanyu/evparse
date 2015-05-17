package com.pplive.p2p.network.protocol
{
	import com.pplive.p2p.struct.SubPiece;
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.RID;
	
	public class SubPiecePacket extends PeerResponsePacket
	{
		
		public static const ACTION:uint = 179;
		
		public var subpiece:SubPiece;
		
		public var data:ByteArray;
		
		public function SubPiecePacket(param1:uint, param2:RID, param3:SubPiece, param4:ByteArray, param5:uint = 1)
		{
			super(ACTION,param1,param2,param5);
			this.subpiece = param3;
			this.data = param4;
		}
		
		public function fromByteArrayEx(param1:ByteArray, param2:ByteArray) : void
		{
			super.fromByteArray(param1);
			this.subpiece = new SubPiece();
			this.subpiece.blockIndex = param1.readUnsignedShort();
			this.subpiece.subPieceIndex = param1.readUnsignedShort();
			this.data = param2;
		}
		
		override public function fromByteArray(param1:ByteArray) : void
		{
			super.fromByteArray(param1);
			this.subpiece = new SubPiece(param1.readUnsignedShort(),param1.readUnsignedShort());
			var _loc2:uint = param1.readUnsignedShort();
			this.data = new ByteArray();
			param1.readBytes(this.data,0,_loc2);
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			_loc1.writeShort(this.subpiece.blockIndex);
			_loc1.writeShort(this.subpiece.subPieceIndex);
			_loc1.writeShort(this.data.length);
			_loc1.writeBytes(this.data);
			return _loc1;
		}
	}
}
