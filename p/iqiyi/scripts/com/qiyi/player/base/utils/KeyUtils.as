package com.qiyi.player.base.utils {
	public class KeyUtils extends Object {
		
		public function KeyUtils() {
			super();
		}
		
		public static function getDispatchKey(param1:uint, param2:String) : String {
			var _loc3_:* = ")(*&^flash@#$%a";
			var _loc4_:uint = Math.floor(param1 / (10 * 60));
			return MD5.calculate(_loc4_ + _loc3_ + param2);
		}
		
		public static function getPassportKey(param1:uint) : String {
			var _loc2_:uint = param1;
			var _loc3_:uint = 2.391461978E9;
			var _loc4_:uint = _loc3_ % 17;
			_loc2_ = rotateRight(_loc2_,_loc4_);
			var _loc5_:uint = _loc2_ ^ _loc3_;
			return _loc5_.toString();
		}
		
		private static function rotateRight(param1:uint, param2:uint) : uint {
			var _loc3_:uint = 0;
			var _loc4_:uint = param1;
			var _loc5_:* = 0;
			while(_loc5_ < param2) {
				_loc3_ = _loc4_ & 1;
				_loc4_ = _loc4_ >>> 1;
				_loc3_ = _loc3_ << 31;
				_loc4_ = _loc4_ + _loc3_;
				_loc5_++;
			}
			return _loc4_;
		}
		
		public static function getVrsEncodeCode(param1:String) : String {
			var _loc6_:uint = 0;
			var _loc2_:* = "";
			var _loc3_:Array = param1.split("-");
			var _loc4_:int = _loc3_.length;
			var _loc5_:int = _loc4_ - 1;
			while(_loc5_ >= 0) {
				_loc6_ = getVRSXORCode(parseInt(_loc3_[_loc4_ - _loc5_ - 1],16),_loc5_);
				_loc2_ = String.fromCharCode(_loc6_) + _loc2_;
				_loc5_--;
			}
			return _loc2_;
		}
		
		private static function getVRSXORCode(param1:uint, param2:uint) : uint {
			var _loc3_:int = param2 % 3;
			if(_loc3_ == 1) {
				return param1 ^ 121;
			}
			if(_loc3_ == 2) {
				return param1 ^ 72;
			}
			return param1 ^ 103;
		}
	}
}
