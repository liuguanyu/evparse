package com.adobe.utils {
	public class IntUtil extends Object {
		
		public function IntUtil() {
			super();
		}
		
		public static function rol(param1:int, param2:int) : int {
			return param1 << param2 | param1 >>> 32 - param2;
		}
		
		public static function ror(param1:int, param2:int) : uint {
			var _loc3_:int = 32 - param2;
			return param1 << _loc3_ | param1 >>> 32 - _loc3_;
		}
		
		private static var K102554B08D5BA62728479E96B937F2D4DBA815373517K:String = "0123456789abcdef";
		
		public static function toHex(param1:int, param2:Boolean = false) : String {
			var _loc4_:* = 0;
			var _loc5_:* = 0;
			var _loc3_:* = "";
			if(param2) {
				_loc4_ = 0;
				while(_loc4_ < 4) {
					_loc3_ = _loc3_ + (K102554B08D5BA62728479E96B937F2D4DBA815373517K.charAt(param1 >> (3 - _loc4_) * 8 + 4 & 15) + K102554B08D5BA62728479E96B937F2D4DBA815373517K.charAt(param1 >> (3 - _loc4_) * 8 & 15));
					_loc4_++;
				}
			} else {
				_loc5_ = 0;
				while(_loc5_ < 4) {
					_loc3_ = _loc3_ + (K102554B08D5BA62728479E96B937F2D4DBA815373517K.charAt(param1 >> _loc5_ * 8 + 4 & 15) + K102554B08D5BA62728479E96B937F2D4DBA815373517K.charAt(param1 >> _loc5_ * 8 & 15));
					_loc5_++;
				}
			}
			return _loc3_;
		}
	}
}
