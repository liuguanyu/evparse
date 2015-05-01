package com.qiyi.player.base.utils {
	public class UGCUtils extends Object {
		
		public function UGCUtils() {
			super();
		}
		
		public static function isUGC(param1:String) : Boolean {
			var _loc2_:* = NaN;
			if((param1 && param1.length > 2) && (param1.charAt(param1.length - 1) == "9") && param1.charAt(param1.length - 2) == "0") {
				_loc2_ = Number(param1);
				if(_loc2_ > 0 && _loc2_ > 90000000) {
					return true;
				}
			}
			return false;
		}
	}
}
