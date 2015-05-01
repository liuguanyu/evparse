package com.qiyi.player.base.utils {
	import flash.text.Font;
	
	public class FontUtils extends Object {
		
		public function FontUtils() {
			super();
		}
		
		public static function hasFont(param1:String) : Boolean {
			var _loc2_:Array = Font.enumerateFonts(true);
			var _loc3_:int = _loc2_.length;
			var _loc4_:* = 0;
			while(_loc4_ < _loc3_) {
				if(_loc2_[_loc4_].fontName == param1) {
					return true;
				}
				_loc4_++;
			}
			return false;
		}
	}
}
