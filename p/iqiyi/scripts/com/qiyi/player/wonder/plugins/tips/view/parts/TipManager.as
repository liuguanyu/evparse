package com.qiyi.player.wonder.plugins.tips.view.parts {
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import com.qiyi.player.core.player.IPlayer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import com.qiyi.player.core.model.impls.pub.Statistics;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.logging.Log;
	
	public class TipManager extends EventDispatcher {
		
		public function TipManager() {
			var so:SharedObject = null;
			var date:Date = null;
			var stat:Object = null;
			var _lastModifyDate:Date = null;
			this._log = Log.getLogger("com.qiyi.components.tips.TipManager");
			this._attribute = new Object();
			this._liveStat = new Object();
			this._external = new Object();
			this.listeners = new Array();
			super();
			try {
				so = SharedObject.getLocal(TipStatistics,"/");
				date = new Date();
				if((so) && (so.data.tipStat)) {
					stat = so.data.tipStat;
					_lastModifyDate = new Date(Number(stat.date));
					if(!(date.date == _lastModifyDate.date) || !(date.month == _lastModifyDate.month) || !(date.fullYear == _lastModifyDate.fullYear)) {
						stat.date = date;
						stat.list = new Array();
						stat.conflict = new Object();
						so.data.tipStat = stat;
						so.flush();
					}
				} else {
					stat = new Object();
					stat.date = date;
					stat.list = new Array();
					stat.conflict = new Object();
					so.data.tipStat = stat;
					so.flush();
				}
				_tipStatChanged = true;
				this._log.debug("TipManager: new instance");
			}
			catch(e:Error) {
				_log.debug("TipManager: init get stat cookie error,unable cookie");
				_enableCookie = false;
				sendErrorEvent(e);
			}
		}
		
		public static const TipStatistics:String = "qiyi_tips_statistics";
		
		public static const TIP_SHOW_STATUS_OK:int = 0;
		
		public static const TIP_SHOW_STATUS_FAILED:int = 1;
		
		public static const TIP_SHOW_STATUS_CONFLICTED:int = 2;
		
		private static var _enable:Boolean = true;
		
		private static var _tipStatChanged:Boolean = false;
		
		private static var loader:URLLoader;
		
		private static var _playerDuration_subscribeTipShowTime_arr:Array = [];
		
		private static var conditions:Array = [];
		
		private static var _startTime:int = 0;
		
		private static var _endTime:int = 0;
		
		private static var _currTime:int = 0;
		
		private static var _totalTime:int = 0;
		
		private static var _playerDuration:int = 0;
		
		private static var _subscribeTipShowTime:uint = 0;
		
		private static var _instance:TipManager;
		
		public static function get instance() : TipManager {
			if(_instance == null) {
				_instance = new TipManager();
			}
			return TipManager(_instance);
		}
		
		public static function showTip(param1:String) : int {
			var data:XML = null;
			var itemXml:XML = null;
			var id:String = param1;
			if(_enable == false) {
				return TIP_SHOW_STATUS_FAILED;
			}
			if(playerModel == null) {
				return TIP_SHOW_STATUS_FAILED;
			}
			var tipItem:Object = getItem(id);
			if(tipItem) {
				if(tipItem.type == "1") {
					data = instance._dataXml;
					itemXml = data..item.(@id == id)[0];
					if(itemXml.conditions[0]) {
						if(checkFrequency(id,itemXml.conditions[0]) == false) {
							return TIP_SHOW_STATUS_FAILED;
						}
						if(checkField(id,itemXml.conditions[0]) == false) {
							instance._log.debug("Tipmanager: fields don\'t meet");
							return TIP_SHOW_STATUS_FAILED;
						}
					}
				}
				return tipBar.showTip(id);
			}
			return TIP_SHOW_STATUS_FAILED;
		}
		
		public static function showInstantTip(param1:String, param2:String) : void {
			if(_enable == false) {
				return;
			}
			if(playerModel == null) {
				return;
			}
			if(param1 != "") {
				tipBar.showInstantTip(param1,param2);
			}
		}
		
		public static function hideTip(param1:String = "") : void {
			if(tipBar == null) {
				return;
			}
			if(param1 == "" || param1 == tipBar.currentTipId && !(param1 == "")) {
				tipBar.hideTip();
			}
		}
		
		public static function isShow(param1:String) : Boolean {
			if(tipBar) {
				return param1 == tipBar.currentTipId;
			}
			return false;
		}
		
		public static function initialize(param1:TipBar) : void {
			instance._tipBar = param1;
			instance._log.debug("TipManager: initialize");
			instance._external.curADState = false;
		}
		
		public static function setDataClass(param1:Class) : void {
			var _loc2_:ByteArray = new param1();
			var _loc3_:XML = XML(_loc2_.readUTFBytes(_loc2_.bytesAvailable));
			setData(_loc3_);
		}
		
		public static function setPlayerModel(param1:IPlayer) : void {
			if(instance._model != param1) {
				instance._model = param1;
			}
		}
		
		public static function setStartTime(param1:int) : void {
			_startTime = param1;
		}
		
		public static function setEndTime(param1:int) : void {
			_endTime = param1;
		}
		
		public static function setCurrTime(param1:int, param2:int = 0) : void {
			if(_currTime != param1) {
				_currTime = param1;
				_playerDuration = param2;
				checkCondition();
			}
		}
		
		private static function checkAdTips() : void {
			checkCondition();
		}
		
		public static function setTotalTime(param1:int) : void {
			_totalTime = param1;
		}
		
		public static function setIsLogin(param1:Boolean) : void {
			instance._external.login = param1;
			instance._log.info("Tipmanager: set login " + String(param1));
		}
		
		public static function setCanSubscribe(param1:Boolean) : void {
			instance._external.cansubcribe = param1;
			instance._log.info("Tipmanager: set cansubcribe " + String(param1));
		}
		
		public static function setSubscribed(param1:Boolean) : void {
			instance._external.issubcribe = param1;
			instance._log.info("Tipmanager: set subdcribed " + String(param1));
		}
		
		public static function setIsBD(param1:uint) : void {
			instance._external.bd = param1;
			instance._log.info("Tipmanager: set bd " + String(param1));
		}
		
		public static function setPassportId(param1:String) : void {
			instance._external.passportid = param1;
			instance._log.info("Tipmanager: set passportId " + String(param1));
		}
		
		private static var _adTipsTimer:Timer;
		
		public static function setADState(param1:Boolean) : void {
			instance._external.curADState = param1;
			if(param1) {
				if(_adTipsTimer == null) {
					_adTipsTimer = new Timer(1000);
					_adTipsTimer.addEventListener(TimerEvent.TIMER,onAdTipsTimer);
					_adTipsTimer.start();
				}
			} else if(_adTipsTimer) {
				_adTipsTimer.stop();
				_adTipsTimer.removeEventListener(TimerEvent.TIMER,onAdTipsTimer);
				_adTipsTimer = null;
			}
			
			instance._log.info("Tipmanager: set isADState " + String(param1));
		}
		
		private static function onAdTipsTimer(param1:TimerEvent) : void {
			checkAdTips();
		}
		
		public static function set enable(param1:Boolean) : void {
			_enable = param1;
		}
		
		public static function setData(param1:XML) : void {
			var list:XMLList = null;
			var i:int = 0;
			var item:XML = null;
			var data:XML = param1;
			_instance._dataXml = data;
			var arr:Array = getConditions();
			if(arr.length != 0) {
				conditions = arr;
				return;
			}
			conditions = new Array();
			try {
				data = instance._dataXml;
				if(data) {
					list = data..conditions;
					i = 0;
					while(i < list.length()) {
						item = XML(list[i]).parent();
						if(item.@type == "2") {
							conditions.push(item);
						}
						i++;
					}
					saveConditions();
				}
			}
			catch(e:Error) {
			}
		}
		
		private static var _so:Object;
		
		private static function getConditions() : Array {
			var so:SharedObject = null;
			var result:Array = [];
			try {
				so = SharedObject.getLocal(TipStatistics,"/");
				if(so.size != 0) {
					if(so.data.conditions) {
						result = so.data.conditions;
					} else {
						result = [];
					}
				}
				_so = so;
			}
			catch(e:Error) {
			}
		}
		
		private static function saveConditions() : void {
			if(conditions == null) {
				return;
			}
			try {
				if(_so == null) {
					_so = SharedObject.getLocal(TipStatistics,"/");
				}
				_so.data.conditions = conditions;
				_so.flush();
			}
			catch(e:Error) {
			}
		}
		
		public static function setDataUrl(param1:String) : void {
			if(loader) {
				removeLoaderListener();
				loader = null;
			}
			var _loc2_:URLRequest = new URLRequest(param1 + "?n=" + Math.random());
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			loader.load(_loc2_);
		}
		
		public static function setIsMember(param1:Boolean) : void {
			instance._external["member"] = param1;
			instance._log.info("Tipmanager: set member " + String(param1));
		}
		
		public static function getItem(param1:String) : Object {
			var result:Object = null;
			var arr:Array = null;
			var data:XML = null;
			var len:int = 0;
			var list:XMLList = null;
			var item:XML = null;
			var msgs:XMLList = null;
			var i:int = 0;
			var msg:XML = null;
			var index:int = 0;
			var id:String = param1;
			try {
				arr = new Array();
				data = instance._dataXml;
				if(data) {
					list = data.item.(@id == id);
					if((list) && list.length() > 0) {
						item = list[0];
						result = new Object();
						result.id = item.@id;
						result.level = item.@level;
						result.duration = item.@duration;
						result.type = item.@type;
						if(item.@force != undefined) {
							result.force = item.@force;
						}
						msgs = item..message;
						i = 0;
						while(i < msgs.length()) {
							msg = msgs[i];
							arr.push(trim(String(msg)));
							i++;
						}
					}
				}
				len = arr.length;
				if(len > 0) {
					index = Math.round(Math.random() * (len - 1)) + 1;
					result.message = String(arr[index - 1]);
				}
			}
			catch(e:*) {
				instance._log.debug("TipManager: get item data error");
				sendErrorEvent(e);
			}
			return result;
		}
		
		private static function getItems() : Array {
			var data:XML = null;
			var list:XMLList = null;
			var i:int = 0;
			var arr:Array = new Array();
			try {
				data = instance._dataXml;
				if(data) {
					list = data..item;
					i = 0;
					while(i < list.length()) {
						arr.push(list[i].@id);
						i++;
					}
				}
			}
			catch(e:Error) {
				instance._log.debug("TipManager: get items  error");
			}
			return arr;
		}
		
		public static function getAttribute() : Object {
			return instance._attribute;
		}
		
		public static function addCountAlbum(param1:String, param2:String) : void {
			var so:SharedObject = null;
			var users:Object = null;
			var albums:Object = null;
			var count:int = 0;
			var passportId:String = param1;
			var albumId:String = param2;
			try {
				so = SharedObject.getLocal(TipStatistics,"/");
				users = so.data.tipStat.users;
				users = users == null?new Object():users;
				users[passportId] = users[passportId] == null?new Object():users[passportId];
				albums = users[passportId].albums;
				albums = albums == null?new Object():albums;
				count = 0;
				count = albums[albumId] == null?0:albums[albumId];
				count = count + 1;
				albums[albumId] = count;
				so.data.tipStat.users = users;
				so.flush();
				_tipStatChanged = true;
			}
			catch(e:Error) {
			}
		}
		
		public static function addCount(param1:String) : void {
			var list:Array = null;
			var vvNum:int = 0;
			var liveNum:int = 0;
			var userId:String = null;
			var albumId:String = null;
			var so:SharedObject = null;
			var id:String = param1;
			var stat:Object = tipStat;
			if((stat) && (stat.list)) {
				list = stat.list as Array;
				list = list == null?new Array():list;
				vvNum = Statistics.instance.dayVV;
				liveNum = Statistics.instance.playCount;
				userId = instance._external.passportid;
				userId = userId == null?"":userId;
				albumId = "";
				if((playerModel) && (playerModel.movieModel) && (playerModel.movieModel.albumId)) {
					albumId = playerModel.movieModel.albumId;
				}
				list.push([id,vvNum,liveNum,userId,albumId]);
				try {
					so = SharedObject.getLocal(TipStatistics,"/");
					so.data.tipStat = stat;
					so.flush();
					_tipStatChanged = true;
				}
				catch(e:Error) {
				}
			}
		}
		
		public static function getShowGroupCount(param1:String, param2:Array) : int {
			var isMeet:Boolean = false;
			var item:Array = null;
			var dayFlag:Boolean = false;
			var vvFlag:Boolean = false;
			var liveFlag:Boolean = false;
			var userFlag:Boolean = false;
			var albumFlag:Boolean = false;
			var id:String = param1;
			var groups:Array = param2;
			var hasRestrain:Function = function(param1:String):Boolean {
				var _loc2_:* = 0;
				if(groups) {
					_loc2_ = 0;
					while(_loc2_ < groups.length) {
						if(groups[_loc2_] == param1) {
							return true;
						}
						_loc2_++;
					}
				}
				return false;
			};
			if(groups == null) {
				return 0;
			}
			var stat:Object = tipStat;
			if(stat == null) {
				return -1;
			}
			if(stat.list == null) {
				return 0;
			}
			var list:Array = stat.list as Array;
			var vvNum:int = Statistics.instance.dayVV;
			var liveNum:int = Statistics.instance.playCount;
			var userId:String = instance._external.passportid;
			userId = userId == null?"":userId;
			var albumId:String = "";
			if((playerModel) && (playerModel.movieModel) && (playerModel.movieModel.albumId)) {
				albumId = playerModel.movieModel.albumId;
			}
			var count:int = 0;
			var i:int = 0;
			while(i < list.length) {
				isMeet = false;
				item = list[i];
				if(item[0] == id) {
					dayFlag = true;
					vvFlag = true;
					if(hasRestrain("vv")) {
						if(vvNum != item[1]) {
							vvFlag = false;
						}
					}
					liveFlag = true;
					if((hasRestrain("live")) && !(liveNum == item[2])) {
						liveFlag = false;
					}
					userFlag = true;
					if((hasRestrain("user")) && !(userId == item[3])) {
						userFlag = false;
					}
					albumFlag = true;
					if((hasRestrain("album")) && !(albumId == item[4])) {
						albumFlag = false;
					}
					if((dayFlag) && (vvFlag) && (liveFlag) && (userFlag) && (albumFlag)) {
						count = count + 1;
					}
				}
				i++;
			}
			return count;
		}
		
		static function addShowCount(param1:String) : void {
			addCount(param1);
		}
		
		static function checkNextConflict() : void {
			checkCondition();
		}
		
		public static function addConflict(param1:String) : void {
			var conflict:Object = null;
			var vvNum:int = 0;
			var so:SharedObject = null;
			var var_25:String = param1;
			var stat:Object = tipStat;
			if((stat) && (stat.conflict)) {
				conflict = stat.conflict;
				conflict = conflict == null?new Object():conflict;
				vvNum = Statistics.instance.dayVV;
				conflict[var_25] = vvNum;
				try {
					so = SharedObject.getLocal(TipStatistics,"/");
					so.data.tipStat = stat;
					so.flush();
					_tipStatChanged = true;
				}
				catch(e:Error) {
					instance._log.debug("TipManager: addConflict cookie error, unable cookie.");
					instance._enableCookie = false;
				}
			}
		}
		
		public static function clearConflict(param1:String) : void {
			var conflict:Object = null;
			var so:SharedObject = null;
			var id:String = param1;
			var stat:Object = tipStat;
			if((stat) && (stat.conflict)) {
				conflict = stat.conflict;
				conflict = conflict == null?new Object():conflict;
				if(conflict[id]) {
					conflict[id] = -1;
					try {
						so = SharedObject.getLocal(TipStatistics,"/");
						so.data.tipStat = stat;
						so.flush();
						_tipStatChanged = true;
					}
					catch(e:Error) {
						instance._log.debug("TipManager: clearConflict cookie error,unable cookie.");
						instance._enableCookie = false;
					}
				}
			}
		}
		
		public static function getConflictVV(param1:String) : int {
			var _loc2_:Object = tipStat;
			if((_loc2_) && (_loc2_.conflict) && !(_loc2_.conflict[param1] == undefined)) {
				return _loc2_.conflict[param1];
			}
			return -1;
		}
		
		private static function checkCondition() : void {
			var _loc3_:XML = null;
			var _loc4_:XML = null;
			var _loc5_:Object = null;
			var _loc6_:Object = null;
			var _loc7_:Object = null;
			if(instance._enableCookie == false) {
				return;
			}
			if(playerModel == null) {
				return;
			}
			var _loc1_:Array = new Array();
			if(conditions == null) {
				return;
			}
			var _loc2_:* = 0;
			while(_loc2_ < conditions.length) {
				_loc3_ = conditions[_loc2_];
				if(_loc3_.@type == "2") {
					_loc4_ = _loc3_.conditions[0];
					if(checkField(_loc3_.@id,_loc4_) != false) {
						if(getConflictVV(_loc3_.@id) != Statistics.instance.dayVV) {
							if(checkFrequency(_loc3_.@id,_loc4_) != false) {
								_loc5_ = new Object();
								_loc5_.id = _loc3_.@id;
								_loc5_.level = Number(_loc3_.@level);
								_loc1_.push(_loc5_);
							}
						}
					}
				}
				_loc2_++;
			}
			if(_loc1_.length > 0) {
				_loc2_ = 0;
				while(_loc2_ < _loc1_.length) {
					_loc7_ = _loc1_[_loc2_];
					if(_loc6_ == null) {
						_loc6_ = _loc7_;
					} else if(_loc7_.level > _loc6_.level) {
						_loc6_ = _loc7_;
					}
					
					_loc2_++;
				}
			}
			if(_loc6_) {
				showTip(_loc6_.id);
			}
		}
		
		private static function checkField(param1:String, param2:XML) : Boolean {
			/*
			 * Decompilation error
			 * Code may be obfuscated
			 * Deobfuscation is activated but decompilation still failed. If the file is NOT obfuscated, disable "Automatic deobfuscation" for better results.
			 * Error type: TranslateException
			 */
			throw new flash.errors.IllegalOperationError("Not decompiled due to error");
		}
		
		private static function checkFrequency(param1:String, param2:XML) : Boolean {
			var _loc4_:* = 0;
			var _loc5_:XMLList = null;
			var _loc6_:Array = null;
			var _loc7_:* = 0;
			var _loc8_:* = 0;
			var _loc9_:String = null;
			if(instance._enableCookie == false) {
				return false;
			}
			var _loc3_:XML = param2.frequency[0];
			if(_loc3_) {
				_loc4_ = _loc3_.@count;
				_loc5_ = _loc3_..restrain;
				_loc6_ = new Array();
				_loc7_ = 0;
				while(_loc7_ < _loc5_.length()) {
					_loc9_ = _loc5_[_loc7_].@name;
					_loc6_.push(_loc9_);
					_loc7_++;
				}
				_loc8_ = getShowGroupCount(param1,_loc6_);
				if(_loc8_ < _loc4_) {
					return true;
				}
			}
			return false;
		}
		
		private static function getFieldValue(param1:String, param2:String = "", param3:XML = null) : Object {
			var _loc4_:Object = null;
			var _loc5_:Object = null;
			var _loc6_:Object = null;
			if((playerModel) && (playerModel.movieModel)) {
				_loc4_ = playerModel.movieModel.source;
				if((_loc4_) && (_loc4_[param1])) {
					return _loc4_[param1];
				}
			}
			if((playerModel) && (playerModel.movieInfo)) {
				_loc5_ = playerModel.movieInfo.infoJSON;
				if((_loc5_) && (_loc5_[param1])) {
					return _loc5_[param1];
				}
			}
			if(instance._external) {
				_loc6_ = instance._external;
				if(_loc6_[param1] != null) {
					return _loc6_[param1];
				}
			}
			if(Statistics.instance) {
				if(param1 == "vv") {
					return Statistics.instance.dayVV;
				}
				if(param1 == "live") {
					return Statistics.instance.currentVV;
				}
				if(param1 == "playtime") {
					return int(Statistics.instance.playDuration / 1000);
				}
				if(param1 == "playcount") {
					return Statistics.instance.playCount;
				}
			}
			if(param1 == "start") {
				return _currTime;
			}
			if(param1 == "end") {
				return _totalTime - _currTime;
			}
			if(param1 == "startplay") {
				return playerModel?_currTime - _startTime:0;
			}
			if(param1 == "endplay") {
				return _endTime - _currTime;
			}
			if(param1 == "curPlayDuration") {
				return Math.floor(playerModel.playingDuration / 1000);
			}
			if(param1 == "interval") {
				return judgeMeetIntervalReq(param2,"interval",param3);
			}
			if(param1 == "expiredTimeInterval") {
				return getRealExpiredTime();
			}
			return null;
		}
		
		public static function updatePlayTime(param1:int, param2:int) : void {
			if(!(_currTime == param1) || !(_totalTime == param2)) {
				_currTime = param1;
				_totalTime = param2;
				checkCondition();
			}
		}
		
		public static function updateAttribute(param1:String, param2:String) : void {
			instance._attribute[param1] = param2;
		}
		
		public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void {
			if(param1 == TipEvent.All) {
				instance.listeners = new Array();
				TipManager.addEventListener(TipEvent.ASEvent,param2,param3,param4,param5);
				TipManager.addEventListener(TipEvent.JSEvent,param2,param3,param4,param5);
				TipManager.addEventListener(TipEvent.Show,param2,param3,param4,param5);
				TipManager.addEventListener(TipEvent.Hide,param2,param3,param4,param5);
				TipManager.addEventListener(TipEvent.Close,param2,param3,param4,param5);
				TipManager.addEventListener(TipEvent.Error,param2,param3,param4,param5);
				TipManager.addEventListener(TipEvent.LinkEvent,param2,param3,param4,param5);
			} else {
				TipManager.addLog("TipManager: addEventListener " + param1);
				removeEventListener(param1,param2,param3);
				instance.listeners.push([param1,param2,param3]);
				instance.addEventListener(param1,param2,param3,param4,param5);
			}
		}
		
		public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void {
			var _loc4_:* = 0;
			if(param1 == TipEvent.All) {
				removeAllEventListener();
			} else {
				_loc4_ = 0;
				while(_loc4_ < instance.listeners.length) {
					if(param1 == instance.listeners[_loc4_][0]) {
						instance.listeners.splice(_loc4_,1);
						instance.removeEventListener(param1,param2,param3);
					}
					_loc4_++;
				}
			}
		}
		
		public static function removeAllEventListener() : void {
			var _loc1_:Array = instance.listeners;
			var _loc2_:* = 0;
			while(_loc2_ < _loc1_.length) {
				removeEventListener(_loc1_[0],_loc1_[1],_loc1_[2]);
				_loc2_++;
			}
			_loc1_ = new Array();
		}
		
		private static var _valueBiggerThan15Minutes:int = 1000;
		
		private static function judgeMeetIntervalReq(param1:String = "", param2:String = "", param3:XML = null) : int {
			var so:SharedObject = null;
			var var_26:String = param1;
			var var_27:String = param2;
			var var_28:XML = param3;
			var returnValue:int = 0;
			try {
				so = SharedObject.getLocal(TipStatistics,"/");
				if(so.data.tipStat) {
					if(!so.data.tipStat.hasOwnProperty("subscribeTipShowTime")) {
						so.data.tipStat.subscribeTipShowTime = 0;
					}
					_subscribeTipShowTime = so.data.tipStat.subscribeTipShowTime;
					if(!so.data.tipStat.hasOwnProperty("playerDuration_subscribeTipShowTime_arr")) {
						so.data.tipStat.playerDuration_subscribeTipShowTime_arr = [];
					}
					_playerDuration_subscribeTipShowTime_arr = so.data.tipStat.playerDuration_subscribeTipShowTime_arr;
				}
			}
			catch(name_1:Error) {
			}
			if(_subscribeTipShowTime == 0) {
				_playerDuration_subscribeTipShowTime_arr.push({
					"time":1,
					"playingDuration":_playerDuration
				});
				returnValue = _valueBiggerThan15Minutes;
			} else if(_playerDuration_subscribeTipShowTime_arr.length >= _subscribeTipShowTime) {
				if(_playerDuration - _playerDuration_subscribeTipShowTime_arr[_subscribeTipShowTime - 1]["playingDuration"] > 900) {
					_playerDuration_subscribeTipShowTime_arr.push({
						"time":_subscribeTipShowTime + 1,
						"playingDuration":_playerDuration
					});
				}
				returnValue = _playerDuration - _playerDuration_subscribeTipShowTime_arr[_subscribeTipShowTime - 1]["playingDuration"];
			}
			
			savePlayerDuration_subscribeTipShowTime_arr();
			return returnValue;
		}
		
		static function addProSubUpdateTipCount(param1:String) : void {
			if(param1 == "ProSubUpdate") {
				addSubscribeTipShowTime();
			}
		}
		
		private static function savePlayerDuration_subscribeTipShowTime_arr() : void {
			var so:SharedObject = null;
			try {
				so = SharedObject.getLocal(TipStatistics,"/");
				if((so.data.tipStat) && !so.data.tipStat.playerDuration_subscribeTipShowTime_arr) {
					so.data.tipStat.playerDuration_subscribeTipShowTime_arr = [];
				} else {
					so.data.tipStat.playerDuration_subscribeTipShowTime_arr = _playerDuration_subscribeTipShowTime_arr;
				}
				so.flush();
				instance._log.debug("just saved subscribeTipShowTime to local lso ：" + so.data.tipStat.playerDuration_subscribeTipShowTime_arr);
			}
			catch(e:Error) {
				instance._log.debug("TipManager : addSubscribeTipShowTime error");
			}
		}
		
		private static function getPlayerDuration_subscribeTipShowTime_arr() : Array {
			var so:SharedObject = null;
			var result:Array = [];
			try {
				so = SharedObject.getLocal(TipStatistics,"/");
				if((so.data.tipStat) && (so.data.tipStat.playerDuration_subscribeTipShowTime_arr)) {
					result = so.data.tipStat.playerDuration_subscribeTipShowTime_arr;
				} else {
					so.data.tipStat.playerDuration_subscribeTipShowTime_arr = [];
					result = [];
					so.flush();
				}
				instance._log.debug("get lso local playerDuration_subscribeTipShowTime_arr" + result);
			}
			catch(name_3:Error) {
				instance._log.debug("TipManager : playerDuration_subscribeTipShowTime_arr error");
			}
		}
		
		private static function getSubscribeTipShowTime() : uint {
			var so:SharedObject = null;
			var result:uint = 0;
			try {
				so = SharedObject.getLocal(TipStatistics,"/");
				if((so.data.tipStat) && (so.data.tipStat.subscribeTipShowTime)) {
					result = so.data.tipStat.subscribeTipShowTime;
				} else {
					so.data.tipStat.subscribeTipShowTime = 0;
					result = 0;
					so.flush();
				}
				instance._log.debug("get lso local _subscribeTipShowTime：" + result);
			}
			catch(name_3:Error) {
				instance._log.debug("TipManager : _subscribeTipShowTime： error");
			}
		}
		
		private static function addSubscribeTipShowTime() : void {
			var so:SharedObject = null;
			try {
				so = SharedObject.getLocal(TipStatistics,"/");
				if((so.data.tipStat) && !so.data.tipStat.subscribeTipShowTime) {
					so.data.tipStat.subscribeTipShowTime = 1;
				} else {
					so.data.tipStat.subscribeTipShowTime = so.data.tipStat.subscribeTipShowTime + 1;
				}
				so.flush();
				instance._log.debug("just saved subscribeTipShowTime to local lso ：" + so.data.tipStat.subscribeTipShowTime);
			}
			catch(e:Error) {
				instance._log.debug("TipManager : addSubscribeTipShowTime error");
			}
		}
		
		private static function get tipStat() : Object {
			var so:SharedObject = null;
			if(_tipStatChanged) {
				try {
					so = SharedObject.getLocal(TipStatistics,"/");
					instance._tipStat = so.data.tipStat;
				}
				catch(e:Error) {
				}
				_tipStatChanged = false;
			}
			if(instance._tipStat == null) {
				instance._log.debug("TipManager: get stat cookie error,unable cookie.");
				instance._enableCookie = false;
			}
			return instance._tipStat;
		}
		
		private static function trim(param1:String) : String {
			if(param1 == null) {
				return null;
			}
			var _loc2_:RegExp = new RegExp("^\\s*");
			var param1:String = param1.replace(_loc2_,"");
			_loc2_ = new RegExp("\\s*$");
			return param1.replace(_loc2_,"");
		}
		
		private static var _expiredDateStr:String;
		
		private static function getRealExpiredTime() : int {
			var _loc2_:* = NaN;
			var _loc3_:Date = null;
			var _loc4_:Date = null;
			var _loc1_:* = "";
			if((playerModel.movieInfo) && (playerModel.movieInfo.infoJSON) && (playerModel.movieInfo.infoJSON.hasOwnProperty("etm"))) {
				_loc1_ = playerModel.movieInfo.infoJSON.etm;
			}
			if(_loc1_ == "") {
				_loc2_ = 100;
			} else {
				_loc3_ = produceDate(_loc1_);
				_loc4_ = new Date();
				_loc2_ = Math.ceil((_loc3_.getTime() - _loc4_.getTime()) / 1000 / 864000 * 10);
			}
			return _loc2_;
		}
		
		private static function produceDate(param1:String) : Date {
			var _loc2_:Date = new Date();
			_loc2_.fullYear = Number(param1.substr(0,4));
			_loc2_.month = Number(param1.substr(4,2)) - 1;
			_loc2_.date = Number(param1.substr(6,2));
			_expiredDateStr = _loc2_.fullYear + "年" + (_loc2_.month + 1) + "月" + _loc2_.date + "日";
			updateAttribute("expiredTime",_expiredDateStr);
			updateAttribute("videoName",remainWord(playerModel.movieInfo.albumName,22));
			return _loc2_;
		}
		
		static function addLog(param1:String) : void {
			instance._log.debug(param1);
		}
		
		static function TipDebugInfo() : void {
			var obj:Object = null;
			var key:String = null;
			var i:int = 0;
			var list:Array = null;
			var conflict:Array = null;
			if(_enableDebugKey == false) {
				instance._log.debug("TipManager : unenable DebugKey");
				return;
			}
			var info:String = "--------TipDebugInfo----------";
			try {
				obj = instance._external;
				for(key in obj) {
					info = info + "\n" + key + ":" + obj[key];
				}
			}
			catch(e:Error) {
			}
			try {
				obj = playerModel.movieModel.source;
				for(key in obj) {
					info = info + "\n" + key + ":" + obj[key];
				}
			}
			catch(e:Error) {
			}
			try {
				obj = playerModel.movieInfo.infoJSON;
				for(key in obj) {
					info = info + "\n" + key + ":" + obj[key];
				}
			}
			catch(e:Error) {
			}
			try {
				info = info + "\n";
				i = 0;
				list = tipStat.list as Array;
				i = 0;
				while(i < list.length) {
					obj = tipStat.list[i];
					for(key in obj) {
						info = info + "\t" + key + ":" + obj[key];
					}
					info = info + "\n";
					i++;
				}
				info = info + "\n";
				conflict = tipStat.conflict as Array;
				i = 0;
				while(i < conflict.length) {
					obj = tipStat.conflict[i];
					for(key in obj) {
						info = info + "\t" + key + ":" + obj[key];
					}
					info = info + "\n";
					i++;
				}
			}
			catch(e:Error) {
			}
			try {
				info = info + "\n start:" + String(getFieldValue("start"));
				info = info + "\n end:" + String(getFieldValue("end"));
				info = info + "\n startplay:" + String(getFieldValue("startplay"));
				info = info + "\n endplay:" + String(getFieldValue("endplay"));
			}
			catch(e:Error) {
			}
			info = info + "\n----------TipDebugInfo------------";
			instance._log.debug(info);
		}
		
		private static var _enableDebugKey:Boolean = true;
		
		public static function enableDebugKey(param1:Boolean) : void {
			_enableDebugKey = param1;
		}
		
		public static function get tipBar() : TipBar {
			return instance._tipBar;
		}
		
		public static function get playerModel() : IPlayer {
			return instance._model;
		}
		
		private static function onComplete(param1:Event) : void {
			var loader:URLLoader = null;
			var dataXML:XML = null;
			var event:Event = param1;
			try {
				loader = URLLoader(event.target);
				dataXML = XML(loader.data);
				setData(dataXML);
				removeLoaderListener();
			}
			catch(e:Error) {
				instance._log.warn("TipManager: load xml error" + e.errorID);
			}
		}
		
		private static function onIOError(param1:IOErrorEvent) : void {
			removeLoaderListener();
			instance._log.warn("TipManager: get data url ioError");
		}
		
		private static function onSecurityError(param1:SecurityErrorEvent) : void {
			removeLoaderListener();
			instance._log.debug("TipManager: get data url securityError");
		}
		
		private static function removeLoaderListener() : void {
			loader.removeEventListener(Event.COMPLETE,onComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
		}
		
		private static function sendErrorEvent(param1:*) : void {
			var _loc2_:TipEvent = new TipEvent(TipEvent.Error);
			_loc2_.error = param1;
			instance.dispatchEvent(_loc2_);
		}
		
		public static function remainWord(param1:String, param2:uint) : String {
			var _loc3_:* = "";
			if(param1.length > param2) {
				_loc3_ = param1.substr(0,param2) + "...";
			} else {
				_loc3_ = param1;
			}
			return _loc3_;
		}
		
		private var _enableCookie:Boolean = true;
		
		private var _model:IPlayer;
		
		private var _log:ILogger;
		
		private var _dataXml:XML;
		
		private var _attribute:Object;
		
		private var _liveStat:Object;
		
		private var _external:Object;
		
		private var _tipStat:Object;
		
		private var listeners:Array;
		
		private var _tipBar:TipBar;
	}
}
