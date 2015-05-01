package com.qiyi.player.wonder.common.lso {
	import flash.net.SharedObject;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.qiyi.player.wonder.body.BodyDef;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.logging.Log;
	
	public class LSO extends Object {
		
		public function LSO(param1:SingletonClass) {
			this._clientFlashInfoArr = [];
			this._bonusLastDate = new Date();
			this._sttDate = new Date();
			this._log = Log.getLogger("com.qiyi.player.wonder.common.lso.LSO");
			super();
		}
		
		private static var _instance:LSO;
		
		public static function getInstance() : LSO {
			if(_instance == null) {
				_instance = new LSO(new SingletonClass());
			}
			return _instance;
		}
		
		private var _commonSO:SharedObject;
		
		private var _clientFlashSO:SharedObject;
		
		private var _commonSOTimeout:uint = 0;
		
		private var _clientFlashInfoArr:Array;
		
		private var _totalBonus:uint = 0;
		
		private var _todayBonus:uint = 0;
		
		private var _bonusLastDate:Date;
		
		private var _maxTicketCount:int = 5;
		
		private var _sttDate:Date;
		
		private var _sttShowCountOneDay:int = 0;
		
		private var _sttMaxCount:int = 0;
		
		private var _log:ILogger;
		
		public function init() : void {
			try {
				this._commonSO = SharedObject.getLocal(SystemConfig.COMMON_COOKIE_NAME,"/");
				if(this._commonSO.size > 0) {
					if((this._commonSO.data.bonus) && !(this._commonSO.data.bonus.wonder_todayBonus == undefined)) {
						this._todayBonus = this._commonSO.data.bonus.wonder_todayBonus;
					}
					if((this._commonSO.data.bonus) && !(this._commonSO.data.bonus.wonder_totalBonus == undefined)) {
						this._totalBonus = this._commonSO.data.bonus.wonder_totalBonus;
					}
					if((this._commonSO.data.bonus) && !(this._commonSO.data.bonus.wonder_bonusLastDate == undefined)) {
						this._bonusLastDate = new Date(Number(this._commonSO.data.bonus.wonder_bonusLastDate));
					}
					if((this._commonSO.data.stt) && !(this._commonSO.data.stt.date == undefined)) {
						this._sttDate = this._commonSO.data.stt.date;
						if(this._sttDate == null) {
							this._sttDate = new Date();
						}
					}
					if((this._commonSO.data.stt) && !(this._commonSO.data.stt.sttShowCountOneDay == undefined)) {
						this._sttShowCountOneDay = this._commonSO.data.stt.sttShowCountOneDay;
					}
					if((this._commonSO.data.stt) && !(this._commonSO.data.stt.sttMaxCount == undefined)) {
						this._sttMaxCount = this._commonSO.data.stt.sttMaxCount;
					}
				}
			}
			catch(e:Error) {
			}
		}
		
		public function get maxTicketCount() : int {
			return this._maxTicketCount;
		}
		
		public function get sttDate() : Date {
			return this._sttDate;
		}
		
		public function set sttDate(param1:Date) : void {
			this._sttDate = param1;
			this.prepareUpdateCommon();
		}
		
		public function get sttShowCountOneDay() : int {
			return this._sttShowCountOneDay;
		}
		
		public function set sttShowCountOneDay(param1:int) : void {
			if(param1 != this._sttShowCountOneDay) {
				this._sttShowCountOneDay = param1;
				this.prepareUpdateCommon();
			}
		}
		
		public function get sttMaxCount() : int {
			return this._sttMaxCount;
		}
		
		public function set sttMaxCount(param1:int) : void {
			if(param1 != this.sttMaxCount) {
				this._sttMaxCount = param1;
				this.prepareUpdateCommon();
			}
		}
		
		public function setClientFlashInfo(param1:Array) : void {
			if(param1) {
				this._clientFlashInfoArr = param1;
				this.updateClientFlash();
			}
		}
		
		public function addBonus() : void {
			var _loc1_:Date = null;
			if(this._totalBonus == 0) {
				this._totalBonus = BodyDef.BONUS_DEFAULT_COUNT_ONCE;
				this._todayBonus = BodyDef.BONUS_DEFAULT_COUNT_ONCE;
				this._bonusLastDate = new Date();
			} else {
				_loc1_ = new Date();
				if(!(_loc1_.date == this._bonusLastDate.date) || !(_loc1_.month == this._bonusLastDate.month) || !(_loc1_.fullYear == this._bonusLastDate.fullYear)) {
					this._todayBonus = 0;
				}
				if(this._todayBonus < 50 && this._totalBonus < 100) {
					this._todayBonus = this._todayBonus + BodyDef.BONUS_DEFAULT_COUNT_ONCE;
					this._totalBonus = this._totalBonus + BodyDef.BONUS_DEFAULT_COUNT_ONCE;
					this._bonusLastDate = _loc1_;
				}
			}
			this.prepareUpdateCommon();
		}
		
		public function takeOutTotalBonus() : uint {
			try {
				this._commonSO = SharedObject.getLocal(SystemConfig.COMMON_COOKIE_NAME,"/");
				if(this._commonSO.size > 0) {
					if((this._commonSO.data.bonus) && !(this._commonSO.data.bonus.wonder_todayBonus == undefined)) {
						this._todayBonus = this._commonSO.data.bonus.wonder_todayBonus;
					}
					if((this._commonSO.data.bonus) && !(this._commonSO.data.bonus.wonder_totalBonus == undefined)) {
						this._totalBonus = this._commonSO.data.bonus.wonder_totalBonus;
					}
				}
			}
			catch(e:Error) {
			}
			var result:uint = 0;
			if(this._totalBonus != 0) {
				result = this._totalBonus;
				this._totalBonus = 0;
				this._todayBonus = 0;
				this._bonusLastDate = new Date();
				this.updateCommon();
			} else {
				result = 0;
			}
			return result;
		}
		
		private function prepareUpdateCommon() : void {
			if(this._commonSOTimeout == 0) {
				this._commonSOTimeout = setTimeout(this.updateCommon,200);
			}
		}
		
		private function updateCommon() : void {
			var bonus:Object = null;
			var stt:Object = null;
			clearTimeout(this._commonSOTimeout);
			this._commonSOTimeout = 0;
			try {
				if(this._commonSO == null) {
					this._commonSO = SharedObject.getLocal(SystemConfig.COMMON_COOKIE_NAME,"/");
				}
				bonus = {};
				bonus.wonder_todayBonus = this._todayBonus;
				bonus.wonder_totalBonus = this._totalBonus;
				bonus.wonder_bonusLastDate = this._bonusLastDate;
				this._commonSO.data.bonus = bonus;
				stt = {};
				stt.date = this._sttDate;
				stt.sttShowCountOneDay = this._sttShowCountOneDay;
				stt.sttMaxCount = this._sttMaxCount;
				this._commonSO.data.stt = stt;
				this._commonSO.flush();
			}
			catch(e:Error) {
			}
		}
		
		private function updateClientFlash() : void {
			var len:int = 0;
			var i:int = 0;
			var info:Object = null;
			try {
				if(this._clientFlashSO == null) {
					this._clientFlashSO = SharedObject.getLocal(SystemConfig.CLIENT_FLASH_COOKIE_NAME,"/");
				}
				if(this._clientFlashSO.data.count == undefined) {
					this._clientFlashSO.data.count = 0;
				}
				len = this._clientFlashSO.data.count;
				i = 0;
				i = 0;
				while(i < len) {
					delete this._clientFlashSO.data["curvideoinfo_" + i];
					true;
					i++;
				}
				info = null;
				len = this._clientFlashInfoArr.length;
				i = 0;
				while(i < len) {
					info = this._clientFlashInfoArr[i];
					info.action = "down";
					info.cursystime = String(new Date().time);
					this._clientFlashSO.data["curvideoinfo_" + i] = com.adobe.serialization.json.JSON.encode(info);
					i++;
				}
				this._clientFlashSO.data.count = len;
				this._clientFlashSO.flush();
				this._clientFlashInfoArr = [];
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
