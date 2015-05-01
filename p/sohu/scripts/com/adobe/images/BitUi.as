package com.adobe.images {
	import flash.utils.ByteArray;
	import com.hurlant.crypto.symmetric.XTeaKey;
	import com.adobe.crypto.Base64;
	
	public class BitUi extends Object {
		
		public function BitUi() {
			super();
		}
		
		private static function K102553B9BF6692A27B4F72A7BF9DC30394C3AF373516K(param1:Array) : ByteArray {
			var _loc2_:ByteArray = new ByteArray();
			if(param1.length < 4) {
				param1.length = 4;
			}
			var _loc3_:uint = param1[0] != ""?param1[0]:0;
			var _loc4_:uint = param1[1] != ""?param1[1]:0;
			var _loc5_:uint = param1[2] != ""?param1[2]:0;
			var _loc6_:uint = param1[3] != ""?param1[3]:0;
			trace(_loc3_ + "," + _loc4_ + "," + _loc5_ + "," + _loc6_);
			_loc2_.writeInt(_loc3_);
			_loc2_.writeInt(_loc4_);
			_loc2_.writeInt(_loc5_);
			_loc2_.writeInt(_loc6_);
			return _loc2_;
		}
		
		public static function replaceAll(param1:String, param2:String, param3:String) : String {
			var _loc8_:String = null;
			var _loc4_:* = "";
			var _loc5_:Array = param1.split(param2);
			var _loc6_:int = _loc5_.length;
			var _loc7_:* = 0;
			for each(_loc8_ in _loc5_) {
				if(_loc7_ < _loc6_ - 1) {
					_loc4_ = _loc4_ + (_loc8_ + param3);
				} else {
					_loc4_ = _loc4_ + _loc8_;
				}
				_loc7_++;
			}
			return _loc4_;
		}
		
		private var xtea:XTeaKey;
		
		public function encryptBase64(param1:String, param2:Array) : String {
			var _loc3_:* = "";
			if(param1 == "") {
				return _loc3_;
			}
			var _loc4_:ByteArray = K102553B9BF6692A27B4F72A7BF9DC30394C3AF373516K(param2);
			this.xtea = new XTeaKey(_loc4_);
			var _loc5_:ByteArray = new ByteArray();
			_loc5_.writeUTFBytes(param1);
			_loc5_.position = 0;
			var _loc6_:int = 8 - _loc5_.length % 8;
			var _loc7_:ByteArray = new ByteArray();
			_loc7_.writeByte(_loc6_);
			_loc5_.readBytes(_loc7_,_loc6_);
			_loc7_.position = 0;
			while(_loc7_.bytesAvailable) {
				this.xtea.encrypt(_loc7_,_loc7_.position);
			}
			_loc7_.position = 0;
			_loc3_ = Base64.encodeByteArray(_loc7_);
			_loc3_ = replaceAll(_loc3_,"+","-");
			_loc3_ = replaceAll(_loc3_,"/","_");
			_loc3_ = replaceAll(_loc3_,"=",".");
			return _loc3_;
		}
		
		public function decryptBase64(param1:String, param2:Array) : String {
			var _loc3_:* = "";
			var _loc4_:String = param1;
			if(_loc4_ == "") {
				return _loc3_;
			}
			_loc4_ = replaceAll(_loc4_,"-","+");
			_loc4_ = replaceAll(_loc4_,"_","/");
			_loc4_ = replaceAll(_loc4_,".","=");
			var _loc5_:ByteArray = Base64.decodeToByteArray(_loc4_);
			var _loc6_:ByteArray = K102553B9BF6692A27B4F72A7BF9DC30394C3AF373516K(param2);
			this.xtea = new XTeaKey(_loc6_);
			while(_loc5_.bytesAvailable) {
				this.xtea.decrypt(_loc5_,_loc5_.position);
			}
			_loc5_.position = 0;
			var _loc7_:int = _loc5_.readByte();
			_loc5_.position = _loc7_;
			_loc3_ = _loc5_.readUTFBytes(_loc5_.bytesAvailable);
			return _loc3_;
		}
	}
}
