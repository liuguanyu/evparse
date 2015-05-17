package com.pplive.p2p.network.protocol
{
	import com.pplive.p2p.struct.SubPiece;
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.RID;
	
	public class SubPieceRequestPacket extends PeerRequestPacket
	{
		
		public static const ACTION:uint = 178;
		
		public var subpieces:Vector.<SubPiece>;
		
		public var priority:uint;
		
		public function SubPieceRequestPacket(param1:uint, param2:RID, param3:Vector.<SubPiece>, param4:uint, param5:uint = 1)
		{
			super(ACTION,param1,param2,param5);
			this.subpieces = param3;
			this.priority = param4;
		}
		
		override public function ToByteArray() : ByteArray
		{
			var _loc1:ByteArray = super.ToByteArray();
			_loc1.writeShort(this.subpieces.length);
			var _loc2:* = 0;
			while(_loc2 < this.subpieces.length)
			{
				_loc1.writeShort(this.subpieces[_loc2].blockIndex);
				_loc1.writeShort(this.subpieces[_loc2].subPieceIndex);
				_loc2++;
			}
			_loc1.writeShort(this.priority);
			return _loc1;
		}
		
		override public function fromByteArray(param1:ByteArray) : void
		{
			super.fromByteArray(param1);
			this.subpieces = new Vector.<SubPiece>();
			var _loc2:uint = param1.readUnsignedShort();
			while(_loc2--)
			{
				this.subpieces.push(new SubPiece(param1.readUnsignedShort(),param1.readUnsignedShort()));
			}
			this.priority = param1.readUnsignedShort();
		}
	}
}
