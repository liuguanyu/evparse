package com.qiyi.player.wonder.common.utils {
	import flash.utils.ByteArray;
	
	public class StringUtils extends Object {
		
		public function StringUtils() {
			super();
		}
		
		public static function encodeGBK(param1:String) : String {
			var _loc4_:* = 0;
			var _loc2_:* = "";
			var _loc3_:ByteArray = new ByteArray();
			_loc3_.writeMultiByte(param1,"gbk");
			while(_loc4_ < _loc3_.length) {
				_loc2_ = _loc2_ + escape(String.fromCharCode(_loc3_[_loc4_]));
				_loc4_++;
			}
			return _loc2_;
		}
		
		public static function remainWord(param1:String, param2:uint, param3:String = "...") : String {
			var _loc4_:* = "";
			if(param1.length > param2) {
				_loc4_ = param1.substr(0,param2) + param3;
			} else {
				_loc4_ = param1;
			}
			return _loc4_;
		}
		
		public static function substitute(param1:String, ... rest) : String {
			if(param1 == null) {
				return "";
			}
			var _loc3_:uint = rest.length;
			var _loc4_:Array = null;
			if(_loc3_ == 1 && rest[0] is Array) {
				_loc4_ = rest[0] as Array;
				_loc3_ = _loc4_.length;
			} else {
				_loc4_ = rest;
			}
			var _loc5_:* = 0;
			while(_loc5_ < _loc3_) {
				var param1:String = param1.replace(new RegExp("\\{" + _loc5_ + "\\}","g"),_loc4_[_loc5_]);
				_loc5_++;
			}
			return param1;
		}
	}
}
