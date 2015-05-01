package com.qiyi.player.wonder.common.utils {
	import flash.utils.Dictionary;
	
	public class ObjectPool extends Object {
		
		public function ObjectPool() {
			super();
			this._pool = new Dictionary(true);
		}
		
		private var _pool:Dictionary;
		
		public function push(param1:*) : void {
			this._pool[param1] = null;
		}
		
		public function pop() : Object {
			var _loc1_:Object = null;
			var _loc2_:* = undefined;
			for(_loc2_ in this._pool) {
				delete this._pool[_loc2_];
				true;
				return _loc2_;
			}
			return null;
		}
		
		public function get length() : int {
			var _loc2_:* = undefined;
			var _loc1_:* = 0;
			for(_loc2_ in this._pool) {
				_loc1_++;
			}
			_loc2_ = null;
			return _loc1_;
		}
	}
}
