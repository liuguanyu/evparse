package com.pplive.p2p.struct
{
	import flash.utils.ByteArray;
	import com.pplive.util.StringConvert;
	
	public class BlockMap extends Object
	{
		
		public var blockCount:uint;
		
		public var bitset:ByteArray;
		
		public function BlockMap(param1:uint)
		{
			super();
			this.blockCount = param1;
			this.bitset = new ByteArray();
			this.bitset.length = (param1 + 7) / 8;
		}
		
		public function fromByteArray(param1:ByteArray) : void
		{
			this.bitset = new ByteArray();
			this.blockCount = param1.readUnsignedInt();
			param1.readBytes(this.bitset,0,uint((this.blockCount + 7) / 8));
		}
		
		public function toByteArray(param1:ByteArray) : void
		{
			param1.writeUnsignedInt(this.blockCount);
			param1.writeBytes(this.bitset);
		}
		
		public function get isFull() : Boolean
		{
			var _loc1:uint = 0;
			while(_loc1 < this.blockCount)
			{
				if(!this.hasBlock(_loc1))
				{
					return false;
				}
				_loc1++;
			}
			return true;
		}
		
		public function get isEmpty() : Boolean
		{
			var _loc1:uint = 0;
			while(_loc1 < this.blockCount)
			{
				if(this.hasBlock(_loc1))
				{
					return false;
				}
				_loc1++;
			}
			return true;
		}
		
		public function get validBlockCount() : uint
		{
			var _loc1:uint = 0;
			var _loc2:uint = 0;
			while(_loc2 < this.blockCount)
			{
				if(this.hasBlock(_loc2))
				{
					_loc1++;
				}
				_loc2++;
			}
			return _loc1;
		}
		
		public function setBlock(param1:uint) : void
		{
			if(param1 < this.blockCount)
			{
				this.bitset[uint(param1 / 8)] = this.bitset[uint(param1 / 8)] | 1 << param1 % 8;
			}
		}
		
		public function hasBlock(param1:uint) : Boolean
		{
			if(param1 >= this.blockCount)
			{
				return false;
			}
			return !((this.bitset[uint(param1 / 8)] & this.bitMask(param1 % 8)) == 0);
		}
		
		private function bitMask(param1:uint) : uint
		{
			return 1 << param1;
		}
		
		public function toString() : String
		{
			return "(" + this.blockCount + ")" + StringConvert.byteArray2HexString(this.bitset);
		}
	}
}
