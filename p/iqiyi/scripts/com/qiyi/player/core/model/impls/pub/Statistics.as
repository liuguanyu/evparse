package com.qiyi.player.core.model.impls.pub {
	import flash.utils.setTimeout;
	import flash.net.SharedObject;
	import flash.utils.clearTimeout;
	import com.qiyi.player.core.Config;
	
	public class Statistics extends Object {
		
		public function Statistics(param1:SingletonClass) {
			var so:SharedObject = null;
			var date:Date = null;
			var obj:Object = null;
			var cls:SingletonClass = param1;
			super();
			try {
				so = SharedObject.getLocal(Config.STATISTICS_COOKIE,"/");
				date = new Date();
				obj = so.data.play;
				if(obj) {
					this._lastModifyDate = new Date(Number(obj.playTime.date));
					this._playDuration = obj.playTime.duration;
					this._playCount = obj.playCount;
					this._dayVV = obj.dayVV;
					if(!(date.date == this._lastModifyDate.date) || !(date.month == this._lastModifyDate.month) || !(date.fullYear == this._lastModifyDate.fullYear)) {
						this._lastModifyDate = date;
						this._playDuration = 0;
						this._playCount = 0;
						this._dayVV = 0;
					}
					this._playCount = this._playCount + 1;
				} else {
					this._lastModifyDate = date;
				}
			}
			catch(e:Error) {
				_lastModifyDate = date;
			}
		}
		
		private static var _instance:Statistics = null;
		
		public static function loadFromCookie() : void {
			_instance = new Statistics(new SingletonClass());
		}
		
		public static function get instance() : Statistics {
			return _instance;
		}
		
		private var _playDuration:int = 0;
		
		private var _lastModifyDate:Date = null;
		
		private var _playCount:int = 0;
		
		private var _dayVV:int = 0;
		
		private var _currentVV:int = 0;
		
		private var _updateTimeout:int = 0;
		
		public function get playDuration() : int {
			return this._playDuration;
		}
		
		public function get playCount() : int {
			return this._playCount;
		}
		
		public function get currentVV() : int {
			return this._currentVV;
		}
		
		public function get dayVV() : int {
			return this._dayVV;
		}
		
		public function addVV() : void {
			this._currentVV++;
			this._dayVV++;
			this.update();
		}
		
		public function addDuration(param1:int) : void {
			var _loc2_:Date = new Date();
			if(!(_loc2_.date == this._lastModifyDate.date) && _loc2_.month == this._lastModifyDate.month && _loc2_.fullYear == _loc2_.fullYear) {
				this._playDuration = param1;
				this._lastModifyDate = _loc2_;
			} else {
				this._playDuration = this._playDuration + param1;
			}
			if(this._updateTimeout == 0) {
				this._updateTimeout = setTimeout(this.update,20000);
			}
		}
		
		public function clearDuration() : void {
			this._updateTimeout = 0;
			this._playDuration = 0;
			this._lastModifyDate = new Date();
			this.update();
		}
		
		private function update() : void {
			var so:SharedObject = null;
			var obj:Object = null;
			clearTimeout(this._updateTimeout);
			this._updateTimeout = 0;
			try {
				so = SharedObject.getLocal(Config.STATISTICS_COOKIE,"/");
				if(so.data.common == null) {
					so.data.common = {};
				}
				obj = so.data.play;
				if(!obj) {
					obj = {"playTime":{}};
					so.data.play = obj;
				}
				obj.playTime.date = new Date().time;
				obj.playTime.duration = this._playDuration;
				obj.playCount = this._playCount;
				obj.dayVV = this._dayVV;
				so.flush();
			}
			catch(e:Error) {
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
