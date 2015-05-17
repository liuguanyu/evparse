package com.pplive.p2p
{
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.utils.ByteArray;
	import com.pplive.p2p.struct.SubPiece;
	import flash.utils.Endian;
	
	public class DRMDecoder extends Object
	{
		
		private static var logger:ILogger = getLogger(DRMDecoder);
		
		private static const ENCRYPT_FLAG:uint = 286331153;
		
		private var _isEncrypted:Boolean;
		
		private var _version:uint;
		
		private var _encodedDataLength:uint = 0;
		
		private var _key:uint;
		
		public function DRMDecoder(param1:ByteArray)
		{
			var _loc2:uint = 0;
			super();
			if(!(param1 == null) && param1.length == 1024)
			{
				param1.endian = Endian.BIG_ENDIAN;
				param1.position = 0;
				_loc2 = param1.readUnsignedInt();
				if(_loc2 == ENCRYPT_FLAG)
				{
					this._isEncrypted = true;
					this._version = param1.readUnsignedInt();
					this._encodedDataLength = param1.readUnsignedInt();
					this._key = param1.readUnsignedByte();
					logger.info("encrypted: " + this._encodedDataLength + ", " + this._key);
				}
			}
			if(!this._isEncrypted)
			{
				logger.info("not encrypted");
			}
		}
		
		public function decode(param1:SubPiece, param2:ByteArray) : ByteArray
		{
			var _loc3:ByteArray = null;
			var _loc4:uint = 0;
			var _loc5:uint = 0;
			if(param1.offset < this._encodedDataLength)
			{
				_loc3 = new ByteArray();
				_loc3.length = param2.length;
				_loc4 = 0;
				_loc5 = param2.length;
				while(_loc4 < _loc5)
				{
					_loc3[_loc4] = param2[_loc4] ^ this._key;
					_loc4++;
				}
				return _loc3;
			}
			return param2;
		}
	}
}
