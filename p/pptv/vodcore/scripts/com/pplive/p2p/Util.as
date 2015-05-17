package com.pplive.p2p
{
	import com.pplive.p2p.struct.Constants;
	
	public class Util extends Object
	{
		
		public function Util()
		{
			super();
		}
		
		public static function useP2P(param1:uint) : Boolean
		{
			return !(param1 == Constants.BWTYPE_HTTP_ONLY);
		}
		
		public static function align(param1:uint, param2:uint) : uint
		{
			return uint(param1 / param2) * param2;
		}
		
		public static function upAlign(param1:uint, param2:uint) : uint
		{
			return uint((param1 + param2 - 1) / param2) * param2;
		}
		
		public static function min(param1:*, param2:*) : *
		{
			return param1 < param2?param1:param2;
		}
		
		public static function max(param1:*, param2:*) : *
		{
			return param1 < param2?param2:param1;
		}
		
		public static function removeFromArray(param1:*, param2:*) : int
		{
			var _loc3:int = param1.indexOf(param2);
			if(_loc3 >= 0)
			{
				param1.splice(_loc3,1);
			}
			return _loc3;
		}
		
		public static function shuffleArray(param1:*) : void
		{
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			var _loc4:* = undefined;
			if((param1) && param1.length > 1)
			{
				_loc2 = param1.length;
				while(_loc2 > 1)
				{
					_loc3 = Math.random() * _loc2;
					_loc4 = param1[_loc3];
					param1[_loc3] = param1[_loc2 - 1];
					param1[_loc2 - 1] = _loc4;
					_loc2--;
				}
			}
		}
		
		public static function isFlashIDValid(param1:String) : Boolean
		{
			var _loc3:String = null;
			if(!param1 || !(param1.length == 64))
			{
				return false;
			}
			var _loc2:uint = 0;
			while(_loc2 < 64)
			{
				_loc3 = param1.charAt(_loc2);
				if(!(_loc3 >= "0" && _loc3 <= "9") && !(_loc3 >= "a" && _loc3 <= "f"))
				{
					return false;
				}
				_loc2++;
			}
			return true;
		}
		
		public static function fixToRange(param1:*, param2:*, param3:*) : *
		{
			var _loc4:* = min(param2,param3);
			var _loc5:* = max(param2,param3);
			if(param1 < _loc4)
			{
				return _loc4;
			}
			if(param1 > _loc5)
			{
				return _loc5;
			}
			return param1;
		}
	}
}
