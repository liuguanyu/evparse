package com.qiyi.player.base.utils
{
	public class MD5 extends Object
	{
		
		public function MD5()
		{
			super();
		}
		
		public static function calculate(param1:String) : String
		{
			return hex_md5(param1);
		}
		
		private static function hex_md5(param1:String) : String
		{
			return binl2hex(core_md5(str2binl(param1),param1.length * 8));
		}
		
		private static function core_md5(param1:Array, param2:Number) : Array
		{
			var _loc8:* = NaN;
			var _loc9:* = NaN;
			var _loc10:* = NaN;
			var _loc11:* = NaN;
			param1[param2 >> 5] = param1[param2 >> 5] | 128 << param2 % 32;
			param1[(param2 + 64 >>> 9 << 4) + 14] = param2;
			var _loc3:Number = 1732584193;
			var _loc4:Number = -271733879;
			var _loc5:Number = -1732584194;
			var _loc6:Number = 271733878;
			var _loc7:Number = 0;
			while(_loc7 < param1.length)
			{
				_loc8 = _loc3;
				_loc9 = _loc4;
				_loc10 = _loc5;
				_loc11 = _loc6;
				_loc3 = md5_ff(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 0],7,-680876936);
				_loc6 = md5_ff(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 1],12,-389564586);
				_loc5 = md5_ff(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 2],17,606105819);
				_loc4 = md5_ff(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 3],22,-1044525330);
				_loc3 = md5_ff(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 4],7,-176418897);
				_loc6 = md5_ff(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 5],12,1200080426);
				_loc5 = md5_ff(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 6],17,-1473231341);
				_loc4 = md5_ff(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 7],22,-45705983);
				_loc3 = md5_ff(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 8],7,1770035416);
				_loc6 = md5_ff(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 9],12,-1958414417);
				_loc5 = md5_ff(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 10],17,-42063);
				_loc4 = md5_ff(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 11],22,-1990404162);
				_loc3 = md5_ff(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 12],7,1804603682);
				_loc6 = md5_ff(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 13],12,-40341101);
				_loc5 = md5_ff(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 14],17,-1502002290);
				_loc4 = md5_ff(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 15],22,1236535329);
				_loc3 = md5_gg(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 1],5,-165796510);
				_loc6 = md5_gg(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 6],9,-1069501632);
				_loc5 = md5_gg(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 11],14,643717713);
				_loc4 = md5_gg(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 0],20,-373897302);
				_loc3 = md5_gg(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 5],5,-701558691);
				_loc6 = md5_gg(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 10],9,38016083);
				_loc5 = md5_gg(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 15],14,-660478335);
				_loc4 = md5_gg(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 4],20,-405537848);
				_loc3 = md5_gg(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 9],5,568446438);
				_loc6 = md5_gg(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 14],9,-1019803690);
				_loc5 = md5_gg(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 3],14,-187363961);
				_loc4 = md5_gg(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 8],20,1163531501);
				_loc3 = md5_gg(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 13],5,-1444681467);
				_loc6 = md5_gg(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 2],9,-51403784);
				_loc5 = md5_gg(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 7],14,1735328473);
				_loc4 = md5_gg(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 12],20,-1926607734);
				_loc3 = md5_hh(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 5],4,-378558);
				_loc6 = md5_hh(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 8],11,-2022574463);
				_loc5 = md5_hh(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 11],16,1839030562);
				_loc4 = md5_hh(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 14],23,-35309556);
				_loc3 = md5_hh(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 1],4,-1530992060);
				_loc6 = md5_hh(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 4],11,1272893353);
				_loc5 = md5_hh(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 7],16,-155497632);
				_loc4 = md5_hh(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 10],23,-1094730640);
				_loc3 = md5_hh(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 13],4,681279174);
				_loc6 = md5_hh(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 0],11,-358537222);
				_loc5 = md5_hh(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 3],16,-722521979);
				_loc4 = md5_hh(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 6],23,76029189);
				_loc3 = md5_hh(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 9],4,-640364487);
				_loc6 = md5_hh(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 12],11,-421815835);
				_loc5 = md5_hh(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 15],16,530742520);
				_loc4 = md5_hh(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 2],23,-995338651);
				_loc3 = md5_ii(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 0],6,-198630844);
				_loc6 = md5_ii(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 7],10,1126891415);
				_loc5 = md5_ii(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 14],15,-1416354905);
				_loc4 = md5_ii(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 5],21,-57434055);
				_loc3 = md5_ii(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 12],6,1700485571);
				_loc6 = md5_ii(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 3],10,-1894986606);
				_loc5 = md5_ii(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 10],15,-1051523);
				_loc4 = md5_ii(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 1],21,-2054922799);
				_loc3 = md5_ii(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 8],6,1873313359);
				_loc6 = md5_ii(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 15],10,-30611744);
				_loc5 = md5_ii(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 6],15,-1560198380);
				_loc4 = md5_ii(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 13],21,1309151649);
				_loc3 = md5_ii(_loc3,_loc4,_loc5,_loc6,param1[_loc7 + 4],6,-145523070);
				_loc6 = md5_ii(_loc6,_loc3,_loc4,_loc5,param1[_loc7 + 11],10,-1120210379);
				_loc5 = md5_ii(_loc5,_loc6,_loc3,_loc4,param1[_loc7 + 2],15,718787259);
				_loc4 = md5_ii(_loc4,_loc5,_loc6,_loc3,param1[_loc7 + 9],21,-343485551);
				_loc3 = safe_add(_loc3,_loc8);
				_loc4 = safe_add(_loc4,_loc9);
				_loc5 = safe_add(_loc5,_loc10);
				_loc6 = safe_add(_loc6,_loc11);
				_loc7 = _loc7 + 16;
			}
			return new Array(_loc3,_loc4,_loc5,_loc6);
		}
		
		private static function md5_cmn(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
		{
			return safe_add(bit_rol(safe_add(safe_add(param2,param1),safe_add(param4,param6)),param5),param3);
		}
		
		private static function md5_ff(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
		{
			return md5_cmn(param2 & param3 | ~param2 & param4,param1,param2,param5,param6,param7);
		}
		
		private static function md5_gg(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
		{
			return md5_cmn(param2 & param4 | param3 & ~param4,param1,param2,param5,param6,param7);
		}
		
		private static function md5_hh(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
		{
			return md5_cmn(param2 ^ param3 ^ param4,param1,param2,param5,param6,param7);
		}
		
		private static function md5_ii(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
		{
			return md5_cmn(param3 ^ (param2 | ~param4),param1,param2,param5,param6,param7);
		}
		
		private static function bit_rol(param1:Number, param2:Number) : Number
		{
			return param1 << param2 | param1 >>> 32 - param2;
		}
		
		private static function safe_add(param1:Number, param2:Number) : Number
		{
			var _loc3:Number = (param1 & 65535) + (param2 & 65535);
			var _loc4:Number = (param1 >> 16) + (param2 >> 16) + (_loc3 >> 16);
			return _loc4 << 16 | _loc3 & 65535;
		}
		
		private static function str2binl(param1:String) : Array
		{
			var _loc2:Array = new Array();
			var _loc3:Number = 1 << 8 - 1;
			var _loc4:Number = 0;
			while(_loc4 < param1.length * 8)
			{
				_loc2[_loc4 >> 5] = _loc2[_loc4 >> 5] | (param1.charCodeAt(_loc4 / 8) & _loc3) << _loc4 % 32;
				_loc4 = _loc4 + 8;
			}
			return _loc2;
		}
		
		private static function binl2hex(param1:Array) : String
		{
			var _loc2:String = new String("");
			var _loc3:String = new String("0123456789abcdef");
			var _loc4:Number = 0;
			while(_loc4 < param1.length * 4)
			{
				_loc2 = _loc2 + (_loc3.charAt(param1[_loc4 >> 2] >> _loc4 % 4 * 8 + 4 & 15) + _loc3.charAt(param1[_loc4 >> 2] >> _loc4 % 4 * 8 & 15));
				_loc4++;
			}
			return _loc2;
		}
	}
}
