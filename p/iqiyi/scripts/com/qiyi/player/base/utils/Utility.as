package com.qiyi.player.base.utils {
	import flash.system.Capabilities;
	import com.qiyi.player.base.pub.EnumItem;
	
	public class Utility extends Object {
		
		public function Utility() {
			super();
		}
		
		public static function getFlashVersion() : Object {
			var _loc1_:Object = {};
			var _loc2_:String = Capabilities.version;
			var _loc3_:int = _loc2_.indexOf(" ");
			_loc1_.platform = _loc2_.substr(0,_loc3_);
			_loc2_ = _loc2_.substr(_loc3_ + 1);
			var _loc4_:Array = _loc2_.split(",");
			_loc1_.ver1 = int(_loc4_[0]);
			_loc1_.ver2 = int(_loc4_[1]);
			_loc1_.ver3 = int(_loc4_[2]);
			_loc1_.ver4 = int(_loc4_[3]);
			return _loc1_;
		}
		
		public static function runtimeSupportsStageVideo() : Boolean {
			var _loc1_:String = Capabilities.version;
			if(_loc1_ == null) {
				return false;
			}
			var _loc2_:Array = _loc1_.split(" ");
			if(_loc2_.length < 2) {
				return false;
			}
			var _loc3_:String = _loc2_[0];
			var _loc4_:Array = _loc2_[1].split(",");
			if(_loc4_.length < 2) {
				return false;
			}
			var _loc5_:Number = parseInt(_loc4_[0]);
			var _loc6_:Number = parseInt(_loc4_[1]);
			return _loc5_ > 10 || _loc5_ == 10 && _loc6_ >= 2;
		}
		
		public static function runtimeSupportsDataMode() : Boolean {
			var _loc1_:String = Capabilities.version;
			if(_loc1_ == null) {
				return false;
			}
			var _loc2_:Array = _loc1_.split(" ");
			if(_loc2_.length < 2) {
				return false;
			}
			var _loc3_:String = _loc2_[0];
			var _loc4_:Array = _loc2_[1].split(",");
			if(_loc4_.length < 2) {
				return false;
			}
			var _loc5_:Number = parseInt(_loc4_[0]);
			var _loc6_:Number = parseInt(_loc4_[1]);
			return _loc5_ > 10 || _loc5_ == 10 && _loc6_ >= 1;
		}
		
		public static function getUrl(param1:String, param2:String) : String {
			var _loc3_:String = null;
			var _loc4_:* = 0;
			var _loc5_:* = 0;
			while(_loc5_ < param1.length) {
				if(param1.substr(_loc5_,1) == "/") {
					_loc4_++;
				}
				if(_loc4_ == 3) {
					break;
				}
				_loc5_++;
			}
			_loc3_ = param1.substr(0,_loc5_ + 1) + param2 + param1.substr(_loc5_);
			return _loc3_;
		}
		
		public static function getItemById(param1:Array, param2:int) : EnumItem {
			var _loc3_:* = undefined;
			for each(_loc3_ in param1) {
				if(_loc3_.id == param2) {
					return _loc3_;
				}
			}
			return null;
		}
		
		public static function getItemByName(param1:Array, param2:String) : EnumItem {
			var _loc3_:* = undefined;
			for each(_loc3_ in param1) {
				if(_loc3_.name == param2) {
					return _loc3_;
				}
			}
			return null;
		}
	}
}
