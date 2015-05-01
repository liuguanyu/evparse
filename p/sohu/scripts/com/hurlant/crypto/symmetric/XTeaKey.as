package com.hurlant.crypto.symmetric {
	import flash.utils.ByteArray;
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.util.Memory;
	
	public class XTeaKey extends Object implements ISymmetricKey {
		
		public function XTeaKey(param1:ByteArray) {
			super();
			param1.position = 0;
			this.K10255269C23FDCE8B24503A67C29619F006FF3373515K = [param1.readUnsignedInt(),param1.readUnsignedInt(),param1.readUnsignedInt(),param1.readUnsignedInt()];
		}
		
		public static function parseKey(param1:String) : XTeaKey {
			var _loc2_:ByteArray = new ByteArray();
			_loc2_.writeUnsignedInt(parseInt(param1.substr(0,8),16));
			_loc2_.writeUnsignedInt(parseInt(param1.substr(8,8),16));
			_loc2_.writeUnsignedInt(parseInt(param1.substr(16,8),16));
			_loc2_.writeUnsignedInt(parseInt(param1.substr(24,8),16));
			_loc2_.position = 0;
			return new XTeaKey(_loc2_);
		}
		
		public const NUM_ROUNDS:uint = 32;
		
		private var K10255269C23FDCE8B24503A67C29619F006FF3373515K:Array;
		
		public function getBlockSize() : uint {
			return 8;
		}
		
		public function encrypt(param1:ByteArray, param2:uint = 0) : void {
			var _loc5_:uint = 0;
			param1.position = param2;
			var _loc3_:uint = param1.readUnsignedInt();
			var _loc4_:uint = param1.readUnsignedInt();
			var _loc6_:uint = 0;
			var _loc7_:uint = 2.654435769E9;
			_loc5_ = 0;
			while(_loc5_ < this.NUM_ROUNDS) {
				_loc6_ = _loc6_ + _loc7_;
				_loc3_ = _loc3_ + ((_loc4_ << 4) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[0] ^ _loc4_ + _loc6_ ^ (_loc4_ >> 5) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[1]);
				_loc4_ = _loc4_ + ((_loc3_ << 4) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[2] ^ _loc3_ + _loc6_ ^ (_loc3_ >> 5) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[3]);
				_loc5_++;
			}
			param1.position = param1.position - 8;
			param1.writeUnsignedInt(_loc3_);
			param1.writeUnsignedInt(_loc4_);
		}
		
		public function decrypt(param1:ByteArray, param2:uint = 0) : void {
			var _loc5_:uint = 0;
			param1.position = param2;
			var _loc3_:uint = param1.readUnsignedInt();
			var _loc4_:uint = param1.readUnsignedInt();
			var _loc6_:uint = 2.654435769E9;
			var _loc7_:uint = _loc6_ * this.NUM_ROUNDS;
			if(this.NUM_ROUNDS == 32) {
				_loc7_ = 3.337565984E9;
			} else if(this.NUM_ROUNDS == 16) {
				_loc7_ = 3.81626664E9;
			}
			
			_loc5_ = 0;
			while(_loc5_ < this.NUM_ROUNDS) {
				_loc4_ = _loc4_ - ((_loc3_ << 4) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[2] ^ _loc3_ + _loc7_ ^ (_loc3_ >> 5) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[3]);
				_loc3_ = _loc3_ - ((_loc4_ << 4) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[0] ^ _loc4_ + _loc7_ ^ (_loc4_ >> 5) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[1]);
				_loc7_ = _loc7_ - _loc6_;
				_loc5_++;
			}
			param1.position = param1.position - 8;
			param1.writeUnsignedInt(_loc3_);
			param1.writeUnsignedInt(_loc4_);
		}
		
		public function dispose() : void {
			var _loc1_:Random = new Random();
			var _loc2_:uint = 0;
			while(_loc2_ < this.K10255269C23FDCE8B24503A67C29619F006FF3373515K.length) {
				this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[_loc2_] = _loc1_.nextByte();
				delete this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[_loc2_];
				true;
				_loc2_++;
			}
			this.K10255269C23FDCE8B24503A67C29619F006FF3373515K = null;
			Memory.gc();
		}
		
		public function toString() : String {
			return "xtea";
		}
	}
}
