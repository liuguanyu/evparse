package com.hurlant.crypto.prng {
	import flash.utils.ByteArray;
	import flash.text.Font;
	import flash.system.System;
	import flash.system.Capabilities;
	import flash.utils.getTimer;
	import com.hurlant.util.Memory;
	
	public class Random extends Object {
		
		public function Random(param1:Class = null) {
			var _loc2_:uint = 0;
			super();
			if(param1 == null) {
				var param1:Class = ARC4;
			}
			this.state = new param1() as IPRNG;
			this.K10260281A4035357FB48ADA03038D171A278CD373565K = this.state.getPoolSize();
			this.K102602703AE35BC410456981F392E33C28DE34373565K = new ByteArray();
			this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = 0;
			while(this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K < this.K10260281A4035357FB48ADA03038D171A278CD373565K) {
				_loc2_ = 65536 * Math.random();
				this.K102602703AE35BC410456981F392E33C28DE34373565K[this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K++] = _loc2_ >>> 8;
				this.K102602703AE35BC410456981F392E33C28DE34373565K[this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K++] = _loc2_ & 255;
			}
			this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = 0;
			this.seed();
		}
		
		private var state:IPRNG;
		
		private var K10260294EA6D5D9CCC4E4D82B72EB00DFF07DF373565K:Boolean = false;
		
		private var K102602703AE35BC410456981F392E33C28DE34373565K:ByteArray;
		
		private var K10260281A4035357FB48ADA03038D171A278CD373565K:int;
		
		private var K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K:int;
		
		private var K102602DB472586B87642DB9D3B4C36D690E9D3373565K:Boolean = false;
		
		public function seed(param1:int = 0) : void {
			if(param1 == 0) {
				var param1:int = new Date().getTime();
			}
			var _loc2_:* = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K++;
			this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc2_] = this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc2_] ^ param1 & 255;
			this.K102602703AE35BC410456981F392E33C28DE34373565K[this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K++] = this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc3_] ^ param1 >> 8 & 255;
			this.K102602703AE35BC410456981F392E33C28DE34373565K[this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K++] = this.K102602703AE35BC410456981F392E33C28DE34373565K[this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K++] ^ param1 >> 16 & 255;
			this.K102602703AE35BC410456981F392E33C28DE34373565K[this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K++] = this.K102602703AE35BC410456981F392E33C28DE34373565K[this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K++] ^ param1 >> 24 & 255;
			this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K % this.K10260281A4035357FB48ADA03038D171A278CD373565K;
			this.K102602DB472586B87642DB9D3B4C36D690E9D3373565K = true;
		}
		
		public function autoSeed() : void {
			var _loc3_:Font = null;
			var _loc1_:ByteArray = new ByteArray();
			_loc1_.writeUnsignedInt(System.totalMemory);
			_loc1_.writeUTF(Capabilities.serverString);
			_loc1_.writeUnsignedInt(getTimer());
			_loc1_.writeUnsignedInt(new Date().getTime());
			var _loc2_:Array = Font.enumerateFonts(true);
			for each(_loc3_ in _loc2_) {
				_loc1_.writeUTF(_loc3_.fontName);
				_loc1_.writeUTF(_loc3_.fontStyle);
				_loc1_.writeUTF(_loc3_.fontType);
			}
			_loc1_.position = 0;
			while(_loc1_.bytesAvailable >= 4) {
				this.seed(_loc1_.readUnsignedInt());
			}
		}
		
		public function nextBytes(param1:ByteArray, param2:int) : void {
			while(param2--) {
				param1.writeByte(this.nextByte());
			}
		}
		
		public function nextByte() : int {
			if(!this.K10260294EA6D5D9CCC4E4D82B72EB00DFF07DF373565K) {
				if(!this.K102602DB472586B87642DB9D3B4C36D690E9D3373565K) {
					this.autoSeed();
				}
				this.state.init(this.K102602703AE35BC410456981F392E33C28DE34373565K);
				this.K102602703AE35BC410456981F392E33C28DE34373565K.length = 0;
				this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = 0;
				this.K10260294EA6D5D9CCC4E4D82B72EB00DFF07DF373565K = true;
			}
			return this.state.next();
		}
		
		public function dispose() : void {
			var _loc1_:uint = 0;
			while(_loc1_ < this.K102602703AE35BC410456981F392E33C28DE34373565K.length) {
				this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc1_] = Math.random() * 256;
				_loc1_++;
			}
			this.K102602703AE35BC410456981F392E33C28DE34373565K.length = 0;
			this.K102602703AE35BC410456981F392E33C28DE34373565K = null;
			this.state.dispose();
			this.state = null;
			this.K10260281A4035357FB48ADA03038D171A278CD373565K = 0;
			this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = 0;
			Memory.gc();
		}
		
		public function toString() : String {
			return "random-" + this.state.toString();
		}
	}
}
