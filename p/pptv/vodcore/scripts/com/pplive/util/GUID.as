package com.pplive.util
{
	import flash.display.Sprite;
	import flash.system.Capabilities;
	
	public class GUID extends Sprite
	{
		
		private static var counter:Number = 0;
		
		public function GUID()
		{
			super();
		}
		
		public static function create() : String
		{
			var _loc1:Date = new Date();
			var _loc2:Number = _loc1.getTime();
			var _loc3:Number = Math.random() * Number.MAX_VALUE;
			var _loc4:String = Capabilities.serverString;
			var _loc5:String = calculate(_loc2 + _loc4 + _loc3 + counter++).toUpperCase();
			var _loc6:String = _loc5.substring(0,8) + _loc5.substring(8,12) + _loc5.substring(12,16) + _loc5.substring(16,20) + _loc5.substring(20,32);
			return _loc6;
		}
		
		private static function calculate(param1:String) : String
		{
			return hex_sha1(param1);
		}
		
		private static function hex_sha1(param1:String) : String
		{
			return binb2hex(core_sha1(str2binb(param1),param1.length * 8));
		}
		
		private static function core_sha1(param1:Array, param2:Number) : Array
		{
			var _loc10:* = NaN;
			var _loc11:* = NaN;
			var _loc12:* = NaN;
			var _loc13:* = NaN;
			var _loc14:* = NaN;
			var _loc15:* = NaN;
			var _loc16:* = NaN;
			param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
			param1[(param2 + 64 >> 9 << 4) + 15] = param2;
			var _loc3:Array = new Array(80);
			var _loc4:Number = 1732584193;
			var _loc5:Number = -271733879;
			var _loc6:Number = -1732584194;
			var _loc7:Number = 271733878;
			var _loc8:Number = -1009589776;
			var _loc9:Number = 0;
			while(_loc9 < param1.length)
			{
				_loc10 = _loc4;
				_loc11 = _loc5;
				_loc12 = _loc6;
				_loc13 = _loc7;
				_loc14 = _loc8;
				_loc15 = 0;
				while(_loc15 < 80)
				{
					if(_loc15 < 16)
					{
						_loc3[_loc15] = param1[_loc9 + _loc15];
					}
					else
					{
						_loc3[_loc15] = rol(_loc3[_loc15 - 3] ^ _loc3[_loc15 - 8] ^ _loc3[_loc15 - 14] ^ _loc3[_loc15 - 16],1);
					}
					_loc16 = safe_add(safe_add(rol(_loc4,5),sha1_ft(_loc15,_loc5,_loc6,_loc7)),safe_add(safe_add(_loc8,_loc3[_loc15]),sha1_kt(_loc15)));
					_loc8 = _loc7;
					_loc7 = _loc6;
					_loc6 = rol(_loc5,30);
					_loc5 = _loc4;
					_loc4 = _loc16;
					_loc15++;
				}
				_loc4 = safe_add(_loc4,_loc10);
				_loc5 = safe_add(_loc5,_loc11);
				_loc6 = safe_add(_loc6,_loc12);
				_loc7 = safe_add(_loc7,_loc13);
				_loc8 = safe_add(_loc8,_loc14);
				_loc9 = _loc9 + 16;
			}
			return new Array(_loc4,_loc5,_loc6,_loc7,_loc8);
		}
		
		private static function sha1_ft(param1:Number, param2:Number, param3:Number, param4:Number) : Number
		{
			if(param1 < 20)
			{
				return param2 & param3 | ~param2 & param4;
			}
			if(param1 < 40)
			{
				return param2 ^ param3 ^ param4;
			}
			if(param1 < 60)
			{
				return param2 & param3 | param2 & param4 | param3 & param4;
			}
			return param2 ^ param3 ^ param4;
		}
		
		private static function sha1_kt(param1:Number) : Number
		{
			return param1 < 20?1518500249:param1 < 40?1859775393:param1 < 60?-1894007588:-899497514;
		}
		
		private static function safe_add(param1:Number, param2:Number) : Number
		{
			var _loc3:Number = (param1 & 65535) + (param2 & 65535);
			var _loc4:Number = (param1 >> 16) + (param2 >> 16) + (_loc3 >> 16);
			return _loc4 << 16 | _loc3 & 65535;
		}
		
		private static function rol(param1:Number, param2:Number) : Number
		{
			return param1 << param2 | param1 >>> 32 - param2;
		}
		
		private static function str2binb(param1:String) : Array
		{
			var _loc2:Array = new Array();
			var _loc3:Number = 1 << 8 - 1;
			var _loc4:Number = 0;
			while(_loc4 < param1.length * 8)
			{
				_loc2[_loc4 >> 5] = _loc2[_loc4 >> 5] | (param1.charCodeAt(_loc4 / 8) & _loc3) << 24 - _loc4 % 32;
				_loc4 = _loc4 + 8;
			}
			return _loc2;
		}
		
		private static function binb2hex(param1:Array) : String
		{
			var _loc2:String = new String("");
			var _loc3:String = new String("0123456789abcdef");
			var _loc4:Number = 0;
			while(_loc4 < param1.length * 4)
			{
				_loc2 = _loc2 + (_loc3.charAt(param1[_loc4 >> 2] >> (3 - _loc4 % 4) * 8 + 4 & 15) + _loc3.charAt(param1[_loc4 >> 2] >> (3 - _loc4 % 4) * 8 & 15));
				_loc4++;
			}
			return _loc2;
		}
	}
}
