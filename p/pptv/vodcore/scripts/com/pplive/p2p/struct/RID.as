package com.pplive.p2p.struct
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import com.pplive.util.StringConvert;
	
	public class RID extends Object
	{
		
		public static const RID_LENGTH:uint = 16;
		
		private static const RID_HEX_STRING_LENGTH:uint = 32;
		
		private var data1:uint;
		
		private var data2:uint;
		
		private var data3:uint;
		
		private var data4:ByteArray;
		
		private var _isVaild:Boolean = false;
		
		public function RID(param1:String = null)
		{
			var _loc2:ByteArray = null;
			this.data4 = new ByteArray();
			super();
			if(!(param1 == null) && param1.length == RID_HEX_STRING_LENGTH)
			{
				_loc2 = new ByteArray();
				_loc2.endian = Endian.BIG_ENDIAN;
				_loc2.writeBytes(StringConvert.hexString2ByteArray(param1));
				_loc2.position = 0;
				this.setBytes(_loc2);
			}
		}
		
		public function setBytes(param1:ByteArray) : void
		{
			if(param1.bytesAvailable >= RID_LENGTH)
			{
				this.data1 = param1.readUnsignedInt();
				this.data2 = param1.readUnsignedShort();
				this.data3 = param1.readUnsignedShort();
				param1.readBytes(this.data4,0,8);
				this._isVaild = true;
			}
		}
		
		public function isValid() : Boolean
		{
			return this._isVaild;
		}
		
		public function bytes() : ByteArray
		{
			var _loc1:ByteArray = new ByteArray();
			_loc1.endian = Endian.LITTLE_ENDIAN;
			this.getBytes(_loc1);
			return _loc1;
		}
		
		private function getBytes(param1:ByteArray) : void
		{
			param1.writeUnsignedInt(this.data1);
			param1.writeShort(this.data2);
			param1.writeShort(this.data3);
			param1.writeBytes(this.data4);
		}
		
		public function isEqual(param1:RID) : Boolean
		{
			if(!(this.data1 == param1.data1) || !(this.data2 == param1.data2) || !(this.data3 == param1.data3))
			{
				return false;
			}
			var _loc2:uint = 0;
			while(_loc2 < 8)
			{
				if(this.data4[_loc2] != param1.data4[_loc2])
				{
					return false;
				}
				_loc2++;
			}
			return true;
		}
		
		public function toString() : String
		{
			var _loc1:ByteArray = new ByteArray();
			_loc1.endian = Endian.BIG_ENDIAN;
			this.getBytes(_loc1);
			return StringConvert.byteArray2HexString(_loc1);
		}
	}
}
