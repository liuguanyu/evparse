package com.adobe.crypto {
	import com.adobe.utils.IntUtil;
	
	public class MD5 extends Object {
		
		public function MD5() {
			super();
		}
		
		public static function hash(param1:String) : String {
			var _loc6_:* = 0;
			var _loc7_:* = 0;
			var _loc8_:* = 0;
			var _loc9_:* = 0;
			var _loc2_:* = 1732584193;
			var _loc3_:* = -271733879;
			var _loc4_:* = -1732584194;
			var _loc5_:* = 271733878;
			var _loc10_:Array = K102552B3B5679BC23C499FA74729737142F831373515K(param1);
			var _loc11_:int = _loc10_.length;
			var _loc12_:* = 0;
			while(_loc12_ < _loc11_) {
				_loc6_ = _loc2_;
				_loc7_ = _loc3_;
				_loc8_ = _loc4_;
				_loc9_ = _loc5_;
				_loc2_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 0],7,-680876936);
				_loc5_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 1],12,-389564586);
				_loc4_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 2],17,606105819);
				_loc3_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 3],22,-1044525330);
				_loc2_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 4],7,-176418897);
				_loc5_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 5],12,1200080426);
				_loc4_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 6],17,-1473231341);
				_loc3_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 7],22,-45705983);
				_loc2_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 8],7,1770035416);
				_loc5_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 9],12,-1958414417);
				_loc4_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 10],17,-42063);
				_loc3_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 11],22,-1990404162);
				_loc2_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 12],7,1804603682);
				_loc5_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 13],12,-40341101);
				_loc4_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 14],17,-1502002290);
				_loc3_ = K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 15],22,1236535329);
				_loc2_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 1],5,-165796510);
				_loc5_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 6],9,-1069501632);
				_loc4_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 11],14,643717713);
				_loc3_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 0],20,-373897302);
				_loc2_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 5],5,-701558691);
				_loc5_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 10],9,38016083);
				_loc4_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 15],14,-660478335);
				_loc3_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 4],20,-405537848);
				_loc2_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 9],5,568446438);
				_loc5_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 14],9,-1019803690);
				_loc4_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 3],14,-187363961);
				_loc3_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 8],20,1163531501);
				_loc2_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 13],5,-1444681467);
				_loc5_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 2],9,-51403784);
				_loc4_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 7],14,1735328473);
				_loc3_ = K1025524A2B1ED83D874EB69C76814378933710373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 12],20,-1926607734);
				_loc2_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 5],4,-378558);
				_loc5_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 8],11,-2022574463);
				_loc4_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 11],16,1839030562);
				_loc3_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 14],23,-35309556);
				_loc2_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 1],4,-1530992060);
				_loc5_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 4],11,1272893353);
				_loc4_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 7],16,-155497632);
				_loc3_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 10],23,-1094730640);
				_loc2_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 13],4,681279174);
				_loc5_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 0],11,-358537222);
				_loc4_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 3],16,-722521979);
				_loc3_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 6],23,76029189);
				_loc2_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 9],4,-640364487);
				_loc5_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 12],11,-421815835);
				_loc4_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 15],16,530742520);
				_loc3_ = K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 2],23,-995338651);
				_loc2_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 0],6,-198630844);
				_loc5_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 7],10,1126891415);
				_loc4_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 14],15,-1416354905);
				_loc3_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 5],21,-57434055);
				_loc2_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 12],6,1700485571);
				_loc5_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 3],10,-1894986606);
				_loc4_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 10],15,-1051523);
				_loc3_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 1],21,-2054922799);
				_loc2_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 8],6,1873313359);
				_loc5_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 15],10,-30611744);
				_loc4_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 6],15,-1560198380);
				_loc3_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 13],21,1309151649);
				_loc2_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc2_,_loc3_,_loc4_,_loc5_,_loc10_[_loc12_ + 4],6,-145523070);
				_loc5_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc5_,_loc2_,_loc3_,_loc4_,_loc10_[_loc12_ + 11],10,-1120210379);
				_loc4_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc4_,_loc5_,_loc2_,_loc3_,_loc10_[_loc12_ + 2],15,718787259);
				_loc3_ = K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(_loc3_,_loc4_,_loc5_,_loc2_,_loc10_[_loc12_ + 9],21,-343485551);
				_loc2_ = _loc2_ + _loc6_;
				_loc3_ = _loc3_ + _loc7_;
				_loc4_ = _loc4_ + _loc8_;
				_loc5_ = _loc5_ + _loc9_;
				_loc12_ = _loc12_ + 16;
			}
			return IntUtil.toHex(_loc2_) + IntUtil.toHex(_loc3_) + IntUtil.toHex(_loc4_) + IntUtil.toHex(_loc5_);
		}
		
		private static function f(param1:int, param2:int, param3:int) : int {
			return param1 & param2 | ~param1 & param3;
		}
		
		private static function K1025527C9FC9B374DD4C20A5DCA9CA67268DBE373515K(param1:int, param2:int, param3:int) : int {
			return param1 & param3 | param2 & ~param3;
		}
		
		private static function h(param1:int, param2:int, param3:int) : int {
			return param1 ^ param2 ^ param3;
		}
		
		private static function i(param1:int, param2:int, param3:int) : int {
			return param2 ^ (param1 | ~param3);
		}
		
		private static function K1025520F0F2F6E1EA342D1B38A8B59C73D01CB373515K(param1:Function, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int) : int {
			var _loc9_:int = param2 + int(param1(param3,param4,param5)) + param6 + param8;
			return IntUtil.rol(_loc9_,param7) + param3;
		}
		
		private static function K102552F79773EFC3F04C35AE3D5620785ACE5B373515K(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int {
			return K1025520F0F2F6E1EA342D1B38A8B59C73D01CB373515K(f,param1,param2,param3,param4,param5,param6,param7);
		}
		
		private static function K1025524A2B1ED83D874EB69C76814378933710373515K(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int {
			return K1025520F0F2F6E1EA342D1B38A8B59C73D01CB373515K(K1025527C9FC9B374DD4C20A5DCA9CA67268DBE373515K,param1,param2,param3,param4,param5,param6,param7);
		}
		
		private static function K102552351DFDE068F744E7814D41B2FB1E7FDA373515K(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int {
			return K1025520F0F2F6E1EA342D1B38A8B59C73D01CB373515K(h,param1,param2,param3,param4,param5,param6,param7);
		}
		
		private static function K10255238D3D69072E44082AA7FC8E04AB36F0D373515K(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int {
			return K1025520F0F2F6E1EA342D1B38A8B59C73D01CB373515K(i,param1,param2,param3,param4,param5,param6,param7);
		}
		
		private static function K102552B3B5679BC23C499FA74729737142F831373515K(param1:String) : Array {
			var _loc2_:Array = new Array();
			var _loc3_:int = param1.length * 8;
			var _loc4_:* = 255;
			var _loc5_:* = 0;
			while(_loc5_ < _loc3_) {
				_loc2_[_loc5_ >> 5] = _loc2_[_loc5_ >> 5] | (param1.charCodeAt(_loc5_ / 8) & _loc4_) << _loc5_ % 32;
				_loc5_ = _loc5_ + 8;
			}
			_loc2_[_loc3_ >> 5] = _loc2_[_loc3_ >> 5] | 128 << _loc3_ % 32;
			_loc2_[(_loc3_ + 64 >>> 9 << 4) + 14] = _loc3_;
			return _loc2_;
		}
	}
}
