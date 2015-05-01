package com.qiyi.player.core.model.utils {
	public class Status extends Object {
		
		public function Status(param1:int, param2:int) {
			super();
			this._begin = param1;
			this._end = param2;
			this._statusVector = new Vector.<Boolean>(this._end);
			var _loc3_:* = 0;
			while(_loc3_ < this._end) {
				this._statusVector[_loc3_] = false;
				_loc3_++;
			}
		}
		
		private var _statusVector:Vector.<Boolean>;
		
		private var _begin:int;
		
		private var _end:int;
		
		public function addStatus(param1:int) : void {
			if(param1 >= this._begin && param1 < this._end) {
				this._statusVector[param1] = true;
			}
		}
		
		public function removeStatus(param1:int) : void {
			if(param1 >= this._begin && param1 < this._end) {
				this._statusVector[param1] = false;
			}
		}
		
		public function hasStatus(param1:int) : Boolean {
			if(param1 >= this._begin && param1 < this._end) {
				return this._statusVector[param1];
			}
			return false;
		}
		
		public function clone() : Status {
			var _loc1_:Status = new Status(this._begin,this._end);
			var _loc2_:int = this._begin;
			while(_loc2_ < this._end) {
				if(this.hasStatus(_loc2_)) {
					_loc1_.addStatus(_loc2_);
				} else {
					_loc1_.removeStatus(_loc2_);
				}
				_loc2_++;
			}
			return _loc1_;
		}
	}
}
