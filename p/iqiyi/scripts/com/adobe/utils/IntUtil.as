package com.adobe.utils
{
	public class IntUtil extends Object
	{
		
		private static var hexChars:String = "0123456789abcdef";
		
		public function IntUtil()
		{
			super();
		}
		
		public static function toHex(param1:int, param2:Boolean = false) : String
		{
			var _loc4:* = 0;
			var _loc5:* = 0;
			var _loc3:* = "";
			if(param2)
			{
				_loc4 = 0;
				while(_loc4 < 4)
				{
					_loc3 = _loc3 + (hexChars.charAt(param1 >> (3 - _loc4) * 8 + 4 & 15) + hexChars.charAt(param1 >> (3 - _loc4) * 8 & 15));
					_loc4++;
				}
			}
			else
			{
				_loc5 = 0;
				while(_loc5 < 4)
				{
					_loc3 = _loc3 + (hexChars.charAt(param1 >> _loc5 * 8 + 4 & 15) + hexChars.charAt(param1 >> _loc5 * 8 & 15));
					_loc5++;
				}
			}
			return _loc3;
		}
		
		public static function ror(param1:int, param2:int) : uint
		{
			var _loc3:int = 32 - param2;
			return param1 << _loc3 | param1 >>> 32 - _loc3;
		}
		
		public static function rol(param1:int, param2:int) : int
		{
			return param1 << param2 | param1 >>> 32 - param2;
		}
	}
}
