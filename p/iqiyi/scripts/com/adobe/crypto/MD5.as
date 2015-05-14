package com.adobe.crypto
{
	import flash.utils.ByteArray;
	import com.adobe.utils.IntUtil;
	
	public class MD5 extends Object
	{
		
		public static var digest:ByteArray;
		
		public function MD5()
		{
			super();
		}
		
		private static function ff(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int
		{
			return transform(f,param1,param2,param3,param4,param5,param6,param7);
		}
		
		private static function f(param1:int, param2:int, param3:int) : int
		{
			return param1 & param2 | ~param1 & param3;
		}
		
		private static function g(param1:int, param2:int, param3:int) : int
		{
			return param1 & param3 | param2 & ~param3;
		}
		
		private static function h(param1:int, param2:int, param3:int) : int
		{
			return param1 ^ param2 ^ param3;
		}
		
		private static function i(param1:int, param2:int, param3:int) : int
		{
			return param2 ^ (param1 | ~param3);
		}
		
		private static function transform(param1:Function, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int) : int
		{
			var _loc9:int = param2 + int(param1(param3,param4,param5)) + param6 + param8;
			return IntUtil.rol(_loc9,param7) + param3;
		}
		
		private static function hh(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int
		{
			return transform(h,param1,param2,param3,param4,param5,param6,param7);
		}
		
		public static function hash(param1:String) : String
		{
			var _loc2:ByteArray = new ByteArray();
			_loc2.writeUTFBytes(param1);
			return hashBinary(_loc2);
		}
		
		private static function createBlocks(param1:ByteArray) : Array
		{
			var _loc2:Array = new Array();
			var _loc3:int = param1.length * 8;
			var _loc4:* = 255;
			var _loc5:* = 0;
			while(_loc5 < _loc3)
			{
				_loc2[int(_loc5 >> 5)] = _loc2[int(_loc5 >> 5)] | (param1[_loc5 / 8] & _loc4) << _loc5 % 32;
				_loc5 = _loc5 + 8;
			}
			_loc2[int(_loc3 >> 5)] = _loc2[int(_loc3 >> 5)] | 128 << _loc3 % 32;
			_loc2[int((_loc3 + 64 >>> 9 << 4) + 14)] = _loc3;
			return _loc2;
		}
		
		public static function hashBinary(param1:ByteArray) : String
		{
			var _loc6:* = 0;
			var _loc7:* = 0;
			var _loc8:* = 0;
			var _loc9:* = 0;
			var _loc2:* = 1732584193;
			var _loc3:* = -271733879;
			var _loc4:* = -1732584194;
			var _loc5:* = 271733878;
			var _loc10:Array = createBlocks(param1);
			var _loc11:int = _loc10.length;
			var _loc12:* = 0;
			while(_loc12 < _loc11)
			{
				_loc6 = _loc2;
				_loc7 = _loc3;
				_loc8 = _loc4;
				_loc9 = _loc5;
				_loc2 = ff(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 0)],7,-680876936);
				_loc5 = ff(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 1)],12,-389564586);
				_loc4 = ff(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 2)],17,606105819);
				_loc3 = ff(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 3)],22,-1044525330);
				_loc2 = ff(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 4)],7,-176418897);
				_loc5 = ff(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 5)],12,1200080426);
				_loc4 = ff(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 6)],17,-1473231341);
				_loc3 = ff(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 7)],22,-45705983);
				_loc2 = ff(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 8)],7,1770035416);
				_loc5 = ff(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 9)],12,-1958414417);
				_loc4 = ff(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 10)],17,-42063);
				_loc3 = ff(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 11)],22,-1990404162);
				_loc2 = ff(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 12)],7,1804603682);
				_loc5 = ff(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 13)],12,-40341101);
				_loc4 = ff(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 14)],17,-1502002290);
				_loc3 = ff(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 15)],22,1236535329);
				_loc2 = gg(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 1)],5,-165796510);
				_loc5 = gg(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 6)],9,-1069501632);
				_loc4 = gg(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 11)],14,643717713);
				_loc3 = gg(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 0)],20,-373897302);
				_loc2 = gg(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 5)],5,-701558691);
				_loc5 = gg(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 10)],9,38016083);
				_loc4 = gg(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 15)],14,-660478335);
				_loc3 = gg(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 4)],20,-405537848);
				_loc2 = gg(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 9)],5,568446438);
				_loc5 = gg(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 14)],9,-1019803690);
				_loc4 = gg(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 3)],14,-187363961);
				_loc3 = gg(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 8)],20,1163531501);
				_loc2 = gg(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 13)],5,-1444681467);
				_loc5 = gg(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 2)],9,-51403784);
				_loc4 = gg(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 7)],14,1735328473);
				_loc3 = gg(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 12)],20,-1926607734);
				_loc2 = hh(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 5)],4,-378558);
				_loc5 = hh(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 8)],11,-2022574463);
				_loc4 = hh(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 11)],16,1839030562);
				_loc3 = hh(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 14)],23,-35309556);
				_loc2 = hh(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 1)],4,-1530992060);
				_loc5 = hh(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 4)],11,1272893353);
				_loc4 = hh(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 7)],16,-155497632);
				_loc3 = hh(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 10)],23,-1094730640);
				_loc2 = hh(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 13)],4,681279174);
				_loc5 = hh(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 0)],11,-358537222);
				_loc4 = hh(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 3)],16,-722521979);
				_loc3 = hh(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 6)],23,76029189);
				_loc2 = hh(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 9)],4,-640364487);
				_loc5 = hh(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 12)],11,-421815835);
				_loc4 = hh(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 15)],16,530742520);
				_loc3 = hh(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 2)],23,-995338651);
				_loc2 = ii(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 0)],6,-198630844);
				_loc5 = ii(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 7)],10,1126891415);
				_loc4 = ii(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 14)],15,-1416354905);
				_loc3 = ii(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 5)],21,-57434055);
				_loc2 = ii(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 12)],6,1700485571);
				_loc5 = ii(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 3)],10,-1894986606);
				_loc4 = ii(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 10)],15,-1051523);
				_loc3 = ii(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 1)],21,-2054922799);
				_loc2 = ii(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 8)],6,1873313359);
				_loc5 = ii(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 15)],10,-30611744);
				_loc4 = ii(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 6)],15,-1560198380);
				_loc3 = ii(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 13)],21,1309151649);
				_loc2 = ii(_loc2,_loc3,_loc4,_loc5,_loc10[int(_loc12 + 4)],6,-145523070);
				_loc5 = ii(_loc5,_loc2,_loc3,_loc4,_loc10[int(_loc12 + 11)],10,-1120210379);
				_loc4 = ii(_loc4,_loc5,_loc2,_loc3,_loc10[int(_loc12 + 2)],15,718787259);
				_loc3 = ii(_loc3,_loc4,_loc5,_loc2,_loc10[int(_loc12 + 9)],21,-343485551);
				_loc2 = _loc2 + _loc6;
				_loc3 = _loc3 + _loc7;
				_loc4 = _loc4 + _loc8;
				_loc5 = _loc5 + _loc9;
				_loc12 = _loc12 + 16;
			}
			digest = new ByteArray();
			digest.writeInt(_loc2);
			digest.writeInt(_loc3);
			digest.writeInt(_loc4);
			digest.writeInt(_loc5);
			digest.position = 0;
			return IntUtil.toHex(_loc2) + IntUtil.toHex(_loc3) + IntUtil.toHex(_loc4) + IntUtil.toHex(_loc5);
		}
		
		private static function gg(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int
		{
			return transform(g,param1,param2,param3,param4,param5,param6,param7);
		}
		
		private static function ii(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int
		{
			return transform(i,param1,param2,param3,param4,param5,param6,param7);
		}
		
		public static function hashBytes(param1:ByteArray) : String
		{
			return hashBinary(param1);
		}
	}
}
