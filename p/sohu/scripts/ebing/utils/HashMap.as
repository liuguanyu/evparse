package ebing.utils {
	import flash.utils.Dictionary;
	
	public class HashMap extends Object {
		
		public function HashMap() {
			super();
			this.length = 0;
			this.K102607B51541DE7D484BE68D809C6C53683D2A373570K = new Dictionary();
		}
		
		private var length:int;
		
		private var K102607B51541DE7D484BE68D809C6C53683D2A373570K:Dictionary;
		
		public function size() : int {
			return this.length;
		}
		
		public function isEmpty() : Boolean {
			return this.length == 0;
		}
		
		public function keys() : Array {
			var _loc3_:* = undefined;
			var _loc1_:Array = new Array(this.length);
			var _loc2_:* = 0;
			for(_loc1_[_loc2_] in this.K102607B51541DE7D484BE68D809C6C53683D2A373570K) {
				_loc2_++;
			}
			return _loc1_;
		}
		
		public function values() : Array {
			var _loc3_:* = undefined;
			var _loc1_:Array = new Array(this.length);
			var _loc2_:* = 0;
			for each(_loc1_[_loc2_] in this.K102607B51541DE7D484BE68D809C6C53683D2A373570K) {
				_loc2_++;
			}
			return _loc1_;
		}
		
		public function containValues(param1:*) : Boolean {
			var _loc2_:* = undefined;
			for each(_loc2_ in this.K102607B51541DE7D484BE68D809C6C53683D2A373570K) {
				if(_loc2_ === param1) {
					return true;
				}
			}
			return false;
		}
		
		public function containsKey(param1:*) : Boolean {
			if(this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1] != undefined) {
				return true;
			}
			return false;
		}
		
		public function getValue(param1:*) : * {
			var _loc2_:* = this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1];
			if(_loc2_ !== undefined) {
				return _loc2_;
			}
			return null;
		}
		
		public function put(param1:*, param2:*) : * {
			var _loc3_:* = false;
			var _loc4_:* = undefined;
			if(param1 == null) {
				return undefined;
			}
			if(param2 == null) {
				return this.remove(param1);
			}
			_loc3_ = this.containsKey(param1);
			if(!_loc3_) {
				this.length++;
			}
			_loc4_ = this.getValue(param1);
			this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1] = param2;
			return _loc4_;
		}
		
		public function remove(param1:*) : * {
			var _loc2_:Boolean = this.containsKey(param1);
			if(!_loc2_) {
				return null;
			}
			var _loc3_:* = this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1];
			delete this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1];
			true;
			this.length--;
			return _loc3_;
		}
		
		public function clear() : void {
			this.length = 0;
			this.K102607B51541DE7D484BE68D809C6C53683D2A373570K = new Dictionary();
		}
		
		public function clone() : HashMap {
			var _loc2_:* = undefined;
			var _loc1_:HashMap = new HashMap();
			for(_loc2_ in this.K102607B51541DE7D484BE68D809C6C53683D2A373570K) {
				_loc1_.put(_loc2_,this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[_loc2_]);
			}
			return _loc1_;
		}
		
		public function toString() : String {
			var _loc1_:Array = this.keys();
			var _loc2_:Array = this.values();
			var _loc3_:* = "HashMap Content:\n";
			var _loc4_:* = 0;
			while(_loc4_ < _loc1_.length) {
				_loc3_ = _loc3_ + (_loc1_[_loc4_] + "->" + _loc2_[_loc4_] + "\n");
				_loc4_++;
			}
			return _loc3_;
		}
	}
}
