package com.hurlant.crypto.prng {
	import com.hurlant.crypto.symmetric.IStreamCipher;
	import flash.utils.ByteArray;
	import com.hurlant.util.Memory;
	
	public class ARC4 extends Object implements IPRNG, IStreamCipher {
		
		public function ARC4(param1:ByteArray = null) {
			super();
			this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K = new ByteArray();
			if(param1) {
				this.init(param1);
			}
		}
		
		private var i:int = 0;
		
		private var K102552C96791B855C8453B8619B51EA0AB7E40373515K:int = 0;
		
		private var K1026025EF84ACC028743C8B9086BDC07057FCF373565K:ByteArray;
		
		private const psize:uint = 256;
		
		public function getPoolSize() : uint {
			return this.psize;
		}
		
		public function init(param1:ByteArray) : void {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			_loc2_ = 0;
			while(_loc2_ < 256) {
				this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc2_] = _loc2_;
				_loc2_++;
			}
			_loc3_ = 0;
			_loc2_ = 0;
			while(_loc2_ < 256) {
				_loc3_ = _loc3_ + this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc2_] + param1[_loc2_ % param1.length] & 255;
				_loc4_ = this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc2_];
				this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc2_] = this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc3_];
				this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc3_] = _loc4_;
				_loc2_++;
			}
			this.i = 0;
			this.K102552C96791B855C8453B8619B51EA0AB7E40373515K = 0;
		}
		
		public function next() : uint {
			var _loc1_:* = 0;
			this.i = this.i + 1 & 255;
			this.K102552C96791B855C8453B8619B51EA0AB7E40373515K = this.K102552C96791B855C8453B8619B51EA0AB7E40373515K + this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.i] & 255;
			_loc1_ = this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.i];
			this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.i] = this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.K102552C96791B855C8453B8619B51EA0AB7E40373515K];
			this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.K102552C96791B855C8453B8619B51EA0AB7E40373515K] = _loc1_;
			return this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc1_ + this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.i] & 255];
		}
		
		public function getBlockSize() : uint {
			return 1;
		}
		
		public function encrypt(param1:ByteArray) : void {
			var _loc2_:uint = 0;
			while(_loc2_ < param1.length) {
				param1[_loc2_++] = param1[_loc2_++] ^ this.next();
			}
		}
		
		public function decrypt(param1:ByteArray) : void {
			this.encrypt(param1);
		}
		
		public function dispose() : void {
			var _loc1_:uint = 0;
			if(this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K != null) {
				_loc1_ = 0;
				while(_loc1_ < this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K.length) {
					this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc1_] = Math.random() * 256;
					_loc1_++;
				}
				this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K.length = 0;
				this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K = null;
			}
			this.i = 0;
			this.K102552C96791B855C8453B8619B51EA0AB7E40373515K = 0;
			Memory.gc();
		}
		
		public function toString() : String {
			return "rc4";
		}
	}
}
