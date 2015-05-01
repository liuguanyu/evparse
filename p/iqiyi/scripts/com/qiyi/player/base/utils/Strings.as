package com.qiyi.player.base.utils {
	public class Strings extends Object {
		
		public function Strings() {
			super();
		}
		
		public static function parseTime(param1:String) : Number {
			var _loc4_:* = 0;
			var _loc2_:Number = 0;
			var _loc3_:Array = param1.split(":");
			if(_loc3_.length > 1) {
				_loc2_ = _loc3_[0] * 3600;
				_loc2_ = _loc2_ + _loc3_[1] * 60;
				_loc2_ = _loc2_ + Number(_loc3_[2]);
			} else {
				_loc4_ = 0;
				switch(param1.charAt(param1.length - 1)) {
					case "h":
						_loc4_ = 3600;
						break;
					case "m":
						_loc4_ = 60;
						break;
					case "s":
						_loc4_ = 1;
						break;
				}
				if(_loc4_) {
					_loc2_ = Number(param1.substr(0,param1.length - 1)) * _loc4_;
				} else {
					_loc2_ = Number(param1);
				}
			}
			return _loc2_;
		}
		
		public static function formatAsTimeCode(param1:Number, param2:Boolean = true) : String {
			var _loc3_:Number = Math.floor(param1 / 3600);
			_loc3_ = isNaN(_loc3_)?0:_loc3_;
			var _loc4_:Number = Math.floor(param1 % 3600 / 60);
			_loc4_ = isNaN(_loc4_)?0:_loc4_;
			var _loc5_:Number = Math.floor(param1 % 3600 % 60);
			_loc5_ = isNaN(_loc5_)?0:_loc5_;
			return (_loc3_ == 0?param2?"00:":"":_loc3_ < 10?"0" + _loc3_.toString() + ":":_loc3_.toString() + ":") + (_loc4_ < 10?"0" + _loc4_.toString():_loc4_.toString()) + ":" + (_loc5_ < 10?"0" + _loc5_.toString():_loc5_.toString());
		}
		
		public static function trim(param1:String) : String {
			var _loc4_:* = 0;
			var _loc2_:String = param1;
			var _loc3_:* = 0;
			while(_loc3_ != param1.length) {
				_loc4_ = param1.charCodeAt(_loc3_);
				if(_loc4_ > 32) {
					break;
				}
				_loc3_++;
			}
			_loc2_ = param1.substr(_loc3_);
			_loc3_ = _loc2_.length;
			while(_loc3_ >= 0) {
				_loc4_ = param1.charCodeAt(_loc3_);
				if(_loc4_ > 32) {
					break;
				}
				_loc3_--;
			}
			_loc2_ = _loc2_.substr(0,_loc3_);
			return _loc2_;
		}
		
		public static function getFileExtension(param1:String) : String {
			var _loc2_:int = param1.lastIndexOf(".");
			if(_loc2_ == -1) {
				return "";
			}
			return param1.substr(_loc2_ + 1);
		}
		
		public static function getFileName(param1:String) : String {
			var _loc2_:int = param1.lastIndexOf("/");
			if(_loc2_ == -1) {
				_loc2_ = param1.lastIndexOf("\\");
				if(_loc2_ == -1) {
					return param1;
				}
			}
			return param1.substr(_loc2_ + 1);
		}
	}
}
