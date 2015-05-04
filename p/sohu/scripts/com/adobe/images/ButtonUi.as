package com.adobe.images {
	import flash.utils.ByteArray;
	import com.adobe.crypto.Base64;
	
	public class ButtonUi extends Object {
		
		public function ButtonUi() {
			super();
		}
		
		private static const _Sbox:Array = [99,124,119,123,242,107,111,197,48,1,103,43,254,215,171,118,202,130,201,125,250,89,71,240,173,212,162,175,156,164,114,192,183,253,147,38,54,63,247,204,52,165,229,241,113,216,49,21,4,199,35,195,24,150,5,154,7,18,128,226,235,39,178,117,9,131,44,26,27,110,90,160,82,59,214,179,41,227,47,132,83,209,0,237,32,252,177,91,106,203,190,57,74,76,88,207,208,239,170,251,67,77,51,133,69,249,2,127,80,60,159,168,81,163,64,143,146,157,56,245,188,182,218,33,16,255,243,210,205,12,19,236,95,151,68,23,196,167,126,61,100,93,25,115,96,129,79,220,34,42,144,136,70,238,184,20,222,94,11,219,224,50,58,10,73,6,36,92,194,211,172,98,145,149,228,121,231,200,55,109,141,213,78,169,108,86,244,234,101,122,174,8,186,120,37,46,28,166,180,198,232,221,116,31,75,189,139,138,112,62,181,102,72,3,246,14,97,53,87,185,134,193,29,158,225,248,152,17,105,217,142,148,155,30,135,233,206,85,40,223,140,161,137,13,191,230,66,104,65,153,45,15,176,84,187,22];
		
		private static const _Xtime_Sbox_AD:Array = [97,100,53,99,51,48,48,100,48,54,48,57,50,97,56,120];
		
		private static const _Xtime1Sbox:Array = [173,9,106,213,48,54,165,56,191,64,163,158,129,243,215,251,124,227,57,130,155,47,255,135,52,142,67,68,196,222,233,203,84,123,148,50,166,194,35,61,238,76,149,11,66,250,195,78,8,46,161,102,40,217,36,178,118,91,162,73,109,139,209,37,114,248,246,100,134,104,152,22,212,164,92,204,93,101,182,146,108,112,72,80,253,237,185,218,94,21,70,87,167,141,157,132,144,216,171,0,140,188,211,10,247,228,88,5,184,179,69,6,208,44,30,143,202,63,15,2,193,175,189,3,1,19,138,107,58,145,17,65,79,103,220,234,151,242,207,206,240,180,230,115,150,172,116,34,231,173,53,133,226,249,55,232,28,117,223,110,71,241,26,113,29,41,197,137,111,183,98,14,170,24,190,27,252,86,62,75,198,210,121,32,154,219,192,254,120,205,90,244,31,221,168,51,136,7,199,49,177,18,16,89,39,128,236,95,96,81,127,169,25,181,74,13,45,229,122,159,147,201,156,239,160,224,59,77,174,42,245,176,200,235,187,60,131,83,153,97,23,43,4,126,186,119,214,38,225,105,20,99,85,33,12,125];
		
		private static const _Xtime2Sbox:Array = [198,173,238,246,255,214,222,145,96,2,206,86,231,181,77,236,143,31,137,250,239,178,142,251,65,179,95,69,35,83,228,155,117,225,61,76,108,126,245,131,104,81,209,249,226,171,98,42,8,149,70,157,48,55,10,47,14,36,27,223,205,78,127,234,18,29,88,52,54,220,180,91,164,118,183,125,82,221,94,19,166,185,0,193,64,227,121,182,212,141,103,114,148,152,176,133,187,197,79,237,134,154,102,17,138,233,4,254,160,120,37,75,162,93,128,5,63,33,112,241,99,119,175,66,32,229,253,191,129,24,38,195,190,53,136,46,147,85,252,122,200,186,50,230,192,25,158,163,68,84,59,11,140,199,107,40,167,188,22,173,219,100,116,20,146,12,72,184,159,189,67,196,57,49,211,242,213,139,110,218,1,177,156,73,216,172,243,207,202,244,71,16,111,240,74,92,56,87,115,151,203,161,232,62,150,97,13,15,224,124,113,204,144,6,247,28,194,106,174,105,23,153,58,39,217,235,43,34,210,169,7,51,45,60,21,201,135,170,80,165,3,89,9,26,101,215,132,208,130,41,90,30,123,168,109,44];
		
		private static const _Xtime_Sbox_CDN:Array = [99,100,110,48,49,48,49,48,53,48,48,48,51,52,98,97];
		
		private static const _Xtime3Sbox:Array = [165,132,202,141,13,189,177,84,80,3,169,125,25,98,230,154,69,157,64,135,21,235,201,11,236,103,253,234,191,247,150,91,194,28,174,106,90,65,2,79,92,244,52,8,147,115,83,63,12,82,101,94,40,161,15,181,9,54,155,61,38,105,205,159,27,158,116,46,45,178,238,251,246,77,97,206,123,62,113,151,245,104,0,44,96,31,200,237,190,70,217,75,222,212,232,74,107,42,229,22,197,215,85,148,207,16,6,129,240,68,186,227,243,254,192,138,173,188,72,4,223,193,117,99,48,26,14,109,76,20,53,47,225,162,204,57,87,242,130,71,172,231,43,149,160,152,209,127,102,126,171,131,202,41,211,60,121,226,29,118,59,86,78,30,219,10,108,228,93,110,239,166,168,164,55,139,50,67,89,183,140,100,210,224,180,250,7,37,175,142,233,24,213,136,111,114,36,241,199,81,35,124,156,33,221,220,134,133,144,66,196,170,216,5,1,18,163,95,249,208,145,88,39,185,56,19,179,51,187,112,137,167,182,34,146,32,73,255,120,122,143,248,128,23,218,49,198,184,195,176,119,17,203,252,214,58];
		
		private static const _Xtime4Sbox:Array = [0,2,4,254,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158,160,162,164,166,168,170,172,174,176,178,180,182,184,186,188,190,192,194,196,198,200,202,204,206,208,210,212,214,216,218,220,222,224,226,228,230,232,234,236,238,240,242,244,246,248,250,252,254,27,25,31,29,19,17,23,21,11,9,15,13,3,1,7,5,59,57,63,61,51,49,55,53,43,41,47,45,35,33,39,37,91,89,95,93,83,81,87,85,75,73,79,77,67,65,71,69,123,121,127,125,115,113,119,117,107,105,111,109,99,97,103,101,155,153,159,157,147,145,151,149,139,137,143,141,131,129,135,133,187,185,191,189,179,177,183,181,171,169,175,173,163,161,167,165,219,217,223,221,211,209,215,213,203,201,207,205,195,193,199,197,251,249,255,253,243,241,247,245,235,233,239,237,227,225,231,229];
		
		private static const _Xtime5Sbox:Array = [0,9,18,27,186,45,54,63,72,65,90,83,108,101,126,119,144,153,130,139,180,189,166,175,216,209,202,195,252,245,238,231,59,50,41,32,31,22,13,4,115,122,97,104,87,94,69,76,171,162,185,176,143,134,157,148,227,234,241,248,199,206,213,220,118,127,100,109,82,91,64,73,62,55,44,37,26,19,8,1,230,239,244,253,194,203,208,217,174,167,188,181,138,131,152,145,77,68,95,86,105,96,123,114,5,12,23,30,33,40,51,58,221,212,207,198,249,240,235,226,149,156,135,142,177,184,163,170,236,229,254,247,200,193,218,211,164,173,182,191,128,137,146,155,124,117,110,103,88,81,74,67,52,61,38,47,16,25,2,11,215,222,197,204,243,250,225,232,159,150,141,132,187,178,169,160,71,78,85,92,99,106,113,120,15,6,29,20,43,34,57,48,154,147,136,129,190,183,172,165,210,219,192,201,246,255,228,237,10,3,24,17,46,39,60,53,66,75,80,89,102,111,116,125,161,168,179,186,133,140,151,158,233,224,251,242,205,196,223,214,49,56,35,42,21,28,7,14,121,112,107,98,93,84,79,70];
		
		private static const _Xtime_Sbox_DM:Array = [100,109,55,99,52,49,54,51,97,55,54,56,55,102,101,100];
		
		private static const _Xtime6Sbox:Array = [0,11,22,29,44,190,58,49,88,83,78,69,116,127,98,105,176,187,166,173,156,151,138,129,232,227,254,245,196,207,210,217,123,112,109,102,87,92,65,74,35,40,53,62,15,4,25,18,203,192,221,214,231,236,241,250,147,152,133,142,191,180,169,162,246,253,224,235,218,209,204,199,174,165,184,179,130,137,148,159,70,77,80,91,106,97,124,119,30,21,8,3,50,57,36,47,141,134,155,144,161,170,183,188,213,222,195,200,249,242,239,228,61,54,43,32,17,26,7,12,101,110,115,120,73,66,95,84,247,252,225,234,219,208,205,198,175,164,185,178,131,136,149,158,71,76,81,90,107,96,125,118,31,20,9,2,51,56,37,46,140,135,154,145,160,171,182,189,212,223,194,201,248,243,238,229,60,55,42,33,16,27,6,13,100,111,114,121,72,67,94,85,1,10,23,28,45,38,59,48,89,82,79,68,117,126,99,104,177,186,167,172,157,150,139,128,233,226,255,244,197,206,211,216,122,113,108,103,86,93,64,75,34,41,52,63,14,5,24,19,202,193,220,215,230,237,240,251,146,153,132,143,190,181,168,163];
		
		private static const _Xtime7Sbox:Array = [0,13,26,23,52,57,173,35,104,101,114,127,92,81,70,75,208,221,202,199,228,233,254,243,184,181,162,175,140,129,150,155,187,182,161,172,143,130,149,152,211,222,201,196,231,234,253,240,107,102,113,124,95,82,69,72,3,14,25,20,55,58,45,32,109,96,119,122,89,84,67,78,5,8,31,18,49,60,43,38,189,176,167,170,137,132,147,158,213,216,207,194,225,236,251,246,214,219,204,193,226,239,248,245,190,179,164,169,138,135,144,157,6,11,28,17,50,63,40,37,110,99,116,121,90,87,64,77,218,215,192,205,238,227,244,249,178,191,168,165,134,139,156,145,10,7,16,29,62,51,36,41,98,111,120,117,86,91,76,65,97,108,123,118,85,88,79,66,9,4,19,30,61,48,39,42,177,188,171,166,133,136,159,146,217,212,195,206,237,224,247,250,183,186,173,160,131,142,153,148,223,210,197,200,235,230,241,252,103,106,125,112,83,94,73,68,15,2,21,24,59,54,33,44,12,1,22,27,56,53,34,47,100,105,126,115,80,93,74,71,220,209,198,203,232,229,242,255,180,185,174,163,128,141,154,151];
		
		private static const _Xtime8Sbox:Array = [0,14,28,18,56,54,36,173,112,126,108,98,72,70,84,90,224,238,252,242,216,214,196,202,144,158,140,130,168,166,180,186,219,213,199,201,227,237,255,241,171,165,183,185,147,157,143,129,59,53,39,41,3,13,31,17,75,69,87,89,115,125,111,97,173,163,177,191,149,155,137,135,221,211,193,207,229,235,249,247,77,67,81,95,117,123,105,103,61,51,33,47,5,11,25,23,118,120,106,100,78,64,82,92,6,8,26,20,62,48,34,44,150,152,138,132,174,160,178,188,230,232,250,244,222,208,194,204,65,79,93,83,121,119,101,107,49,63,45,35,9,7,21,27,161,175,189,179,153,151,133,139,209,223,205,195,233,231,245,251,154,148,134,136,162,172,190,176,234,228,246,248,210,220,206,192,122,116,102,104,66,76,94,80,10,4,22,24,50,60,46,32,236,226,240,254,212,218,200,198,156,146,128,142,164,170,184,182,12,2,16,30,52,58,40,38,124,114,96,110,68,74,88,86,55,57,43,37,15,1,19,29,71,73,91,85,127,113,99,109,215,217,203,197,239,225,243,253,167,169,187,181,159,145,131,141];
		
		private static const _Xtime_Sbox_QS:Array = [113,115,49,54,51,97,55,54,56,55,102,101,102,97,101,98];
		
		private static var K102553C1B65CCB209044949378C8683AD97F2E373516K:Array = [0,1,2,4,8,16,32,64,128,27,54];
		
		private static function K102553ED4738F0776748DD9717CA785C6BB03F373516K(param1:ByteArray, param2:Boolean) : Array {
			var _loc6_:uint = 0;
			var _loc3_:Array = new Array();
			var _loc4_:uint = param1.length;
			var _loc5_:* = 0;
			while(_loc5_ < _loc4_) {
				_loc3_[_loc5_ >>> 2] = uint(_loc3_[_loc5_ >>> 2] | uint(param1[_loc5_]) << (_loc5_ & 3) << 3);
				_loc5_++;
			}
			if(param2) {
				_loc3_.push(_loc4_);
				_loc6_ = param1.length - 1;
				_loc3_[_loc6_ >>> 2] = uint(_loc3_[_loc6_ >>> 2] | uint(param1[_loc6_]) << (_loc6_ & 3) << 3);
			}
			return _loc3_;
		}
		
		private static function K102553ADDE26F326D54936BF096FFCDC0213C0373516K(param1:Array, param2:Array) : Array {
			var _loc12_:Array = null;
			var _loc3_:int = param1.length - 1;
			if(_loc3_ < 1) {
				return param1;
			}
			if(param2.length < 4) {
				_loc12_ = new Array();
				_loc12_ = param2.slice();
				var param2:Array = _loc12_;
			}
			while(param2.length < 4) {
				param2.push(0);
			}
			var _loc4_:uint = param1[_loc3_];
			var _loc5_:uint = param1[0];
			var _loc6_:uint = 2.654435769E9;
			var _loc7_:uint = 0;
			var _loc8_:uint = 0;
			var _loc9_:* = 0;
			var _loc10_:int = 6 + 52 / (_loc3_ + 1);
			while(_loc10_-- > 0) {
				_loc7_ = uint(_loc7_ + _loc6_);
				_loc8_ = _loc7_ >>> 2 & 3;
				_loc9_ = 0;
				while(_loc9_ < _loc3_) {
					_loc5_ = param1[_loc9_ + 1];
					_loc4_ = uint(param1[_loc9_] = param1[_loc9_] + ((_loc4_ >>> 5 ^ _loc5_ << 2) + (_loc5_ >>> 3 ^ _loc4_ << 4) ^ (_loc7_ ^ _loc5_) + (param2[_loc9_ & 3 ^ _loc8_] ^ _loc4_)));
					_loc9_++;
				}
				_loc5_ = param1[0];
				_loc4_ = uint(param1[_loc3_] = param1[_loc3_] + ((_loc4_ >>> 5 ^ _loc5_ << 2) + (_loc5_ >>> 3 ^ _loc4_ << 4) ^ (_loc7_ ^ _loc5_) + (param2[_loc9_ & 3 ^ _loc8_] ^ _loc4_)));
			}
			var _loc11_:uint = 0;
			while(_loc11_ < param1.length) {
				param1[_loc11_] = uint(param1[_loc11_]);
				_loc11_++;
			}
			return param1;
		}
		
		private static function K1025532A41C7ED9E674FF0923ACCF65BCA3A2A373516K(param1:Array, param2:Array) : Array {
			var _loc7_:uint = 0;
			var _loc8_:uint = 0;
			var _loc9_:* = 0;
			var _loc11_:Array = null;
			var _loc3_:int = param1.length - 1;
			if(_loc3_ < 1) {
				return param1;
			}
			if(param2.length < 4) {
				_loc11_ = new Array();
				_loc11_ = param2.slice();
				var param2:Array = _loc11_;
			}
			while(param2.length < 4) {
				param2.push(0);
			}
			var _loc4_:uint = param1[_loc3_];
			var _loc5_:uint = param1[0];
			var _loc6_:uint = 2.654435769E9;
			var _loc10_:int = 6 + 52 / (_loc3_ + 1);
			_loc7_ = uint(uint(_loc10_) * _loc6_);
			while(_loc7_ != 0) {
				_loc8_ = _loc7_ >>> 2 & 3;
				_loc9_ = _loc3_;
				while(_loc9_ > 0) {
					_loc4_ = param1[_loc9_ - 1];
					_loc5_ = uint(param1[_loc9_] = param1[_loc9_] - ((_loc4_ >>> 5 ^ _loc5_ << 2) + (_loc5_ >>> 3 ^ _loc4_ << 4) ^ (_loc7_ ^ _loc5_) + (param2[_loc9_ & 3 ^ _loc8_] ^ _loc4_)));
					_loc9_--;
				}
				_loc4_ = param1[_loc3_];
				_loc5_ = uint(param1[0] = param1[0] - ((_loc4_ >>> 5 ^ _loc5_ << 2) + (_loc5_ >>> 3 ^ _loc4_ << 4) ^ (_loc7_ ^ _loc5_) + (param2[_loc9_ & 3 ^ _loc8_] ^ _loc4_)));
				_loc7_ = uint(_loc7_ - _loc6_);
			}
			return param1;
		}
		
		private static function K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(param1:Array, param2:Boolean) : Array {
			var _loc3_:* = 0;
			var _loc6_:uint = 0;
			if(param2) {
				_loc3_ = int(param1[param1.length - 1]);
			} else {
				_loc3_ = param1.length << 2;
			}
			var _loc4_:Array = new Array();
			var _loc5_:uint = 0;
			while(_loc5_ < _loc3_) {
				_loc6_ = param1[_loc5_ >>> 2] >>> (_loc5_ & 3) << 3 & uint(255);
				_loc4_.push(_loc6_);
				_loc5_++;
			}
			return _loc4_;
		}
		
		private static function K10255308EF4B1B0AD44AA8A81AD7632063D4A6373516K(param1:String) : ByteArray {
			var _loc2_:ByteArray = new ByteArray();
			_loc2_.writeUTFBytes(param1);
			_loc2_.position = 0;
			return _loc2_;
		}
		
		private static function K10255346AD8425BB1542DB97F3996324E08B29373516K(param1:Array) : String {
			var _loc2_:ByteArray = new ByteArray();
			var _loc3_:uint = 0;
			while(_loc3_ < param1.length) {
				_loc2_.writeByte(param1[_loc3_]);
				_loc3_++;
			}
			_loc2_.position = 0;
			if(_loc2_.bytesAvailable > 0) {
				return Base64.encodeByteArray(_loc2_);
			}
			return "";
		}
		
		private var K10255304FA4B6BDAC842A2BD09673391C6EADD373516K:ByteArray;
		
		private function K102553C54C1BF220F248EE8D830408C267724B373516K(param1:int) : ByteArray {
			var _loc2_:ByteArray = new ByteArray();
			var _loc3_:ByteArray = new ByteArray();
			var _loc4_:Array = new Array();
			var _loc5_:Array = new Array();
			_loc4_.push(_Xtime1Sbox);
			_loc4_.push(_Xtime2Sbox);
			_loc4_.push(_Xtime3Sbox);
			_loc4_.push(_Xtime4Sbox);
			_loc4_.push(_Xtime5Sbox);
			_loc4_.push(_Xtime6Sbox);
			_loc4_.push(_Xtime7Sbox);
			_loc4_.push(_Xtime8Sbox);
			var _loc6_:uint = 0;
			while(_loc6_ < _loc4_.length) {
				_loc5_.push(_loc4_[_loc6_][_loc6_]);
				_loc6_++;
			}
			var _loc7_:uint = 0;
			while(_loc7_ < _loc5_.length) {
				_loc3_.writeByte(_loc5_[_loc7_]);
				_loc7_++;
			}
			_loc3_.position = 0;
			var _loc8_:* = 0;
			while(_loc8_ < _loc3_.length) {
				_loc2_.writeByte(_loc3_.readByte() ^ param1);
				_loc8_++;
			}
			_loc2_.position = 0;
			return _loc2_;
		}
		
		private function K102553576271643E98462AAE3BB4AAAFFBC21B373516K(param1:Array, param2:int) : ByteArray {
			var _loc3_:ByteArray = new ByteArray();
			var _loc4_:ByteArray = new ByteArray();
			var _loc5_:Array = param1;
			var _loc6_:uint = 0;
			while(_loc6_ < _loc5_.length) {
				_loc4_.writeByte(_loc5_[_loc6_]);
				_loc6_++;
			}
			_loc4_.position = 0;
			var _loc7_:* = 0;
			while(_loc7_ < _loc4_.length) {
				_loc3_.writeByte(_loc4_.readByte() ^ param2);
				_loc7_++;
			}
			_loc3_.position = 0;
			return _loc3_;
		}
		
		public function drawBtn(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = K10255308EF4B1B0AD44AA8A81AD7632063D4A6373516K(_loc2_);
			var _loc5_:ByteArray = this.K102553C54C1BF220F248EE8D830408C267724B373516K(_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			return K10255346AD8425BB1542DB97F3996324E08B29373516K(K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K102553ADDE26F326D54936BF096FFCDC0213C0373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,true),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),false));
		}
		
		public function drawBar(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = Base64.decodeToByteArray(_loc2_);
			var _loc5_:ByteArray = this.K102553C54C1BF220F248EE8D830408C267724B373516K(_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			var _loc6_:Array = K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K1025532A41C7ED9E674FF0923ACCF65BCA3A2A373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,false),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),true);
			var _loc7_:ByteArray = new ByteArray();
			var _loc8_:uint = 0;
			while(_loc8_ < _loc6_.length) {
				_loc7_[_loc8_] = _loc6_[_loc8_];
				_loc8_++;
			}
			return _loc7_.toString();
		}
		
		public function drawBtnAD(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = K10255308EF4B1B0AD44AA8A81AD7632063D4A6373516K(_loc2_);
			var _loc5_:ByteArray = this.K102553576271643E98462AAE3BB4AAAFFBC21B373516K(_Xtime_Sbox_AD,_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			return K10255346AD8425BB1542DB97F3996324E08B29373516K(K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K102553ADDE26F326D54936BF096FFCDC0213C0373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,true),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),false));
		}
		
		public function drawBarAD(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = Base64.decodeToByteArray(_loc2_);
			var _loc5_:ByteArray = this.K102553576271643E98462AAE3BB4AAAFFBC21B373516K(_Xtime_Sbox_AD,_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			var _loc6_:Array = K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K1025532A41C7ED9E674FF0923ACCF65BCA3A2A373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,false),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),true);
			var _loc7_:ByteArray = new ByteArray();
			var _loc8_:uint = 0;
			while(_loc8_ < _loc6_.length) {
				_loc7_[_loc8_] = _loc6_[_loc8_];
				_loc8_++;
			}
			return _loc7_.toString();
		}
		
		public function drawBtnCDN(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = K10255308EF4B1B0AD44AA8A81AD7632063D4A6373516K(_loc2_);
			var _loc5_:ByteArray = this.K102553576271643E98462AAE3BB4AAAFFBC21B373516K(_Xtime_Sbox_CDN,_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			return K10255346AD8425BB1542DB97F3996324E08B29373516K(K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K102553ADDE26F326D54936BF096FFCDC0213C0373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,true),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),false));
		}
		
		public function drawBarCDN(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = Base64.decodeToByteArray(_loc2_);
			var _loc5_:ByteArray = this.K102553576271643E98462AAE3BB4AAAFFBC21B373516K(_Xtime_Sbox_CDN,_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			var _loc6_:Array = K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K1025532A41C7ED9E674FF0923ACCF65BCA3A2A373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,false),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),true);
			var _loc7_:ByteArray = new ByteArray();
			var _loc8_:uint = 0;
			while(_loc8_ < _loc6_.length) {
				_loc7_[_loc8_] = _loc6_[_loc8_];
				_loc8_++;
			}
			return _loc7_.toString();
		}
		
		public function drawBtnDM(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = K10255308EF4B1B0AD44AA8A81AD7632063D4A6373516K(_loc2_);
			var _loc5_:ByteArray = this.K102553576271643E98462AAE3BB4AAAFFBC21B373516K(_Xtime_Sbox_DM,_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			return K10255346AD8425BB1542DB97F3996324E08B29373516K(K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K102553ADDE26F326D54936BF096FFCDC0213C0373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,true),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),false));
		}
		
		public function drawBarDM(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = Base64.decodeToByteArray(_loc2_);
			var _loc5_:ByteArray = this.K102553576271643E98462AAE3BB4AAAFFBC21B373516K(_Xtime_Sbox_DM,_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			var _loc6_:Array = K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K1025532A41C7ED9E674FF0923ACCF65BCA3A2A373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,false),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),true);
			var _loc7_:ByteArray = new ByteArray();
			var _loc8_:uint = 0;
			while(_loc8_ < _loc6_.length) {
				_loc7_[_loc8_] = _loc6_[_loc8_];
				_loc8_++;
			}
			return _loc7_.toString();
		}
		
		public function drawBtnQS(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = K10255308EF4B1B0AD44AA8A81AD7632063D4A6373516K(_loc2_);
			var _loc5_:ByteArray = this.K102553576271643E98462AAE3BB4AAAFFBC21B373516K(_Xtime_Sbox_QS,_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			return K10255346AD8425BB1542DB97F3996324E08B29373516K(K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K102553ADDE26F326D54936BF096FFCDC0213C0373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,true),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),false));
		}
		
		public function drawBarQS(... rest) : String {
			var _loc2_:String = rest[0];
			var _loc3_:* = 1;
			if(rest.length == 1) {
				_loc3_ = 1;
			} else if(rest.length == 2) {
				_loc3_ = int(Number(rest[1]) % 127);
			} else if(rest.length == 3) {
				_loc3_ = int(int(Number(rest[1]) % 127) * int(Number(rest[2]) % 127) % 127);
			}
			
			
			var _loc4_:ByteArray = Base64.decodeToByteArray(_loc2_);
			var _loc5_:ByteArray = this.K102553576271643E98462AAE3BB4AAAFFBC21B373516K(_Xtime_Sbox_QS,_loc3_);
			if(_loc4_.length == 0) {
				return _loc2_;
			}
			var _loc6_:Array = K1025533E5BE6BAC46A4D17A1330712CEE1C43A373516K(K1025532A41C7ED9E674FF0923ACCF65BCA3A2A373516K(K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc4_,false),K102553ED4738F0776748DD9717CA785C6BB03F373516K(_loc5_,false)),true);
			var _loc7_:ByteArray = new ByteArray();
			var _loc8_:uint = 0;
			while(_loc8_ < _loc6_.length) {
				_loc7_[_loc8_] = _loc6_[_loc8_];
				_loc8_++;
			}
			return _loc7_.toString();
		}
	}
}