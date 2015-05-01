package com.qiyi.cupid.adplayer.utils {
	public class StringUtils extends Object {
		
		public function StringUtils() {
			super();
		}
		
		public static function trim(param1:String) : String {
			var _loc2_:* = "";
			var _loc3_:* = 0;
			while(_loc3_ < param1.length) {
				if(param1.charAt(_loc3_) != " ") {
					_loc2_ = _loc2_ + param1.charAt(_loc3_);
				}
				_loc3_++;
			}
			return _loc2_;
		}
		
		public static function isEmpty(param1:String) : Boolean {
			if(param1 == null) {
				return true;
			}
			return StringUtils.trim(param1).length == 0;
		}
		
		public static function removeControlChars(param1:String) : String {
			var _loc2_:String = null;
			var _loc3_:Array = null;
			if(param1 != null) {
				_loc2_ = param1;
				_loc2_ = _loc2_.split("\t").join(" ");
				_loc2_ = _loc2_.split("\r").join(" ");
				_loc2_ = _loc2_.split("\n").join(" ");
				return _loc2_;
			}
			return param1;
		}
		
		public static function compressWhitespace(param1:String) : String {
			var _loc3_:Array = null;
			var _loc2_:String = param1;
			_loc3_ = _loc2_.split(" ");
			var _loc4_:uint = 0;
			while(_loc4_ < _loc3_.length) {
				if(_loc3_[_loc4_] == "") {
					_loc3_.splice(_loc4_,1);
					_loc4_--;
				}
				_loc4_++;
			}
			_loc2_ = _loc3_.join(" ");
			return _loc2_;
		}
		
		public static function concatEnsuringSeparator(param1:String, param2:String, param3:String) : String {
			if((StringUtils.endsWith(param1,param3)) || (StringUtils.beginsWith(param2,param3))) {
				return param1 + param2;
			}
			return param1 + param3 + param2;
		}
		
		public static function beginsWith(param1:String, param2:String) : Boolean {
			if(param1 == null) {
				return false;
			}
			return StringUtils.trim(param1).indexOf(param2) == 0;
		}
		
		public static function endsWith(param1:String, param2:String) : Boolean {
			if(param1 == null) {
				return false;
			}
			return param1.lastIndexOf(param2) == param1.length - param2.length;
		}
		
		public static function revertSingleQuotes(param1:String, param2:String) : String {
			var _loc3_:RegExp = new RegExp("{quote}","g");
			return param1.replace(_loc3_,param2);
		}
		
		public static function replaceSingleWithDoubleQuotes(param1:String) : String {
			var _loc2_:RegExp = new RegExp("\'","g");
			return param1.replace(_loc2_,"\"");
		}
		
		public static function escapeString(param1:String) : String {
			var _loc2_:RegExp = new RegExp("([\'\\\"\\\\])","g");
			return param1.replace(_loc2_,"\\$1");
		}
		
		public static function getQuery(param1:String, param2:String) : String {
			var _loc3_:RegExp = new RegExp("(^|&|\\?|#)" + param2 + "=([^&]*)(&|$)");
			var _loc4_:Array = param1.match(_loc3_);
			if(_loc4_) {
				return _loc4_[2];
			}
			return "";
		}
	}
}
