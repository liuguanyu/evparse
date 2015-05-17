package com.pplive.util
{
	import flash.utils.ByteArray;
	
	public class StringConvert extends Object
	{
		
		public function StringConvert()
		{
			super();
		}
		
		public static function byteArray2HexString(param1:ByteArray) : String
		{
			var _loc2:String = new String();
			var _loc3:uint = 0;
			while(_loc3 < param1.length)
			{
				_loc2 = _loc2 + byte2hex(param1[_loc3]);
				_loc3++;
			}
			return _loc2;
		}
		
		private static function byte2hex(param1:uint) : String
		{
			var _loc2:* = "";
			var _loc3:* = "FEDCBA";
			var _loc4:uint = 0;
			while(_loc4 < 2)
			{
				if((param1 & 240 >> _loc4 * 4) >> 4 - _loc4 * 4 > 9)
				{
					_loc2 = _loc2 + _loc3.charAt(15 - ((param1 & 240 >> _loc4 * 4) >> 4 - _loc4 * 4));
				}
				else
				{
					_loc2 = _loc2 + String((param1 & 240 >> _loc4 * 4) >> 4 - _loc4 * 4);
				}
				_loc4++;
			}
			return _loc2;
		}
		
		public static function hexString2ByteArray(param1:String) : ByteArray
		{
			if(param1.length % 2 != 0)
			{
				return null;
			}
			var _loc2:ByteArray = new ByteArray();
			var _loc3:uint = 0;
			while(_loc3 < param1.length / 2)
			{
				_loc2.writeByte(hex2byte(param1.substr(2 * _loc3,2)));
				_loc3++;
			}
			return _loc2;
		}
		
		private static function hex2byte(param1:String) : uint
		{
			var _loc4:String = null;
			if(param1.length != 2)
			{
				return 0;
			}
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			while(_loc3 < param1.length)
			{
				_loc4 = param1.charAt(_loc3);
				if(_loc4 >= "0" && _loc4 <= "9")
				{
					_loc2 = 16 * _loc2 + (uint(_loc4) - uint("0"));
				}
				else if(_loc4 >= "a" && _loc4 <= "f")
				{
					_loc2 = 16 * _loc2 + (hexChar2Uint(_loc4) - hexChar2Uint("a") + 10);
				}
				else if(_loc4 >= "A" && _loc4 <= "F")
				{
					_loc2 = 16 * _loc2 + (hexChar2Uint(_loc4) - hexChar2Uint("A") + 10);
				}
				else
				{
					return 0;
				}
				
				
				_loc3++;
			}
			return _loc2;
		}
		
		private static function hexChar2Uint(param1:String) : uint
		{
			if(param1 == "a" || param1 == "A")
			{
				return 10;
			}
			if(param1 == "b" || param1 == "B")
			{
				return 11;
			}
			if(param1 == "c" || param1 == "C")
			{
				return 12;
			}
			if(param1 == "d" || param1 == "D")
			{
				return 13;
			}
			if(param1 == "e" || param1 == "E")
			{
				return 14;
			}
			if(param1 == "f" || param1 == "F")
			{
				return 15;
			}
			return 0;
		}
		
		public static function urldecodeGB2312(param1:String) : String
		{
			var _loc4:* = 0;
			var _loc2:* = "";
			var _loc3:ByteArray = new ByteArray();
			var param1:String = unescape(param1);
			while(_loc4 < param1.length)
			{
				_loc3[_loc4] = param1.charCodeAt(_loc4);
				_loc4++;
			}
			_loc2 = _loc3.readMultiByte(_loc3.length,"gb2312");
			return _loc2;
		}
	}
}
