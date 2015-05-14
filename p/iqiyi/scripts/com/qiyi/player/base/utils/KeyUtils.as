package com.qiyi.player.base.utils
{
	public class KeyUtils extends Object
	{
		
		public function KeyUtils()
		{
			super();
		}
		
		public static function getDispatchKey(param1:uint, param2:String) : String
		{
			var _loc3:* = ")(*&^flash@#$%a";
			var _loc4:uint = Math.floor(param1 / (10 * 60));
			return MD5.calculate(_loc4 + _loc3 + param2);
		}
		
		public static function getPassportKey(param1:uint) : String
		{
			var _loc2:uint = param1;
			var _loc3:uint = 2.391461978E9;
			var _loc4:uint = _loc3 % 17;
			_loc2 = rotateRight(_loc2,_loc4);
			var _loc5:uint = _loc2 ^ _loc3;
			return _loc5.toString();
		}
		
		private static function rotateRight(param1:uint, param2:uint) : uint
		{
			var _loc3:uint = 0;
			var _loc4:uint = param1;
			var _loc5:* = 0;
			while(_loc5 < param2)
			{
				_loc3 = _loc4 & 1;
				_loc4 = _loc4 >>> 1;
				_loc3 = _loc3 << 31;
				_loc4 = _loc4 + _loc3;
				_loc5++;
			}
			return _loc4;
		}
		
		public static function getVrsEncodeCode(param1:String) : String
		{
			var _loc6:uint = 0;
			var _loc2:* = "";
			var _loc3:Array = param1.split("-");
			var _loc4:int = _loc3.length;
			var _loc5:int = _loc4 - 1;
			while(_loc5 >= 0)
			{
				_loc6 = getVRSXORCode(parseInt(_loc3[_loc4 - _loc5 - 1],16),_loc5);
				_loc2 = String.fromCharCode(_loc6) + _loc2;
				_loc5--;
			}
			return _loc2;
		}
		
		private static function getVRSXORCode(param1:uint, param2:uint) : uint
		{
			var _loc3:int = param2 % 3;
			if(_loc3 == 1)
			{
				return param1 ^ 121;
			}
			if(_loc3 == 2)
			{
				return param1 ^ 72;
			}
			return param1 ^ 103;
		}
	}
}
