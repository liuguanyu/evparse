package com.qiyi.player.user.impls {
	import flash.events.EventDispatcher;
	import com.qiyi.player.user.IUser;
	import flash.utils.Timer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.user.UserDef;
	import flash.events.TimerEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.user.UserManagerEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.qiyi.player.base.uuid.UUIDManager;
	import com.qiyi.player.base.utils.MD5;
	import flash.net.sendToURL;
	import com.qiyi.player.base.logging.Log;
	
	public class User extends EventDispatcher implements IUser {
		
		public function User(param1:String, param2:String, param3:String, param4:String) {
			this._type = UserDef.USER_TYPE_QIYI;
			this._level = UserDef.USER_LEVEL_NORMAL;
			this._limitationType = UserDef.USER_LIMITATION_NONE;
			this._log = Log.getLogger("com.qiyi.player.user.impls.User");
			super();
			this._passportID = param1;
			this._P00001 = param2;
			this._profileID = param3;
			this._profileCookie = param4;
		}
		
		private const HEART_BEAT_MIN_TIME:int = 10000;
		
		private const HEART_BEAT_URL:String = "http://passport.iqiyi.com/apis/cmonitor/keepalive.action";
		
		private const KEY:String = "jfaljluixn39012$#";
		
		private var _id:String = "";
		
		private var _passportID:String = "";
		
		private var _P00001:String = "";
		
		private var _profileID:String = "";
		
		private var _profileCookie:String = "";
		
		private var _nickname:String = "";
		
		private var _type:int;
		
		private var _level:int;
		
		private var _limitationType:int;
		
		private var _userCheckRemote:UserCheckRemote;
		
		private var _heartBeatTimer:Timer;
		
		private var _tvid:String = "";
		
		private var _isActivation:Boolean = false;
		
		private var _log:ILogger;
		
		public function get passportID() : String {
			return this._passportID;
		}
		
		public function get P00001() : String {
			return this._P00001;
		}
		
		public function get profileID() : String {
			return this._profileID;
		}
		
		public function get profileCookie() : String {
			return this._profileCookie;
		}
		
		public function get nickName() : String {
			return this._nickname;
		}
		
		public function get id() : String {
			return this._id;
		}
		
		public function get type() : int {
			return this._type;
		}
		
		public function get level() : int {
			return this._level;
		}
		
		public function get limitationType() : int {
			return this._limitationType;
		}
		
		public function set tvid(param1:String) : void {
			this._tvid = param1;
		}
		
		public function checkUser() : void {
			if(this._userCheckRemote) {
				this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
				this._userCheckRemote.destroy();
			}
			this._userCheckRemote = new UserCheckRemote(this._passportID,this._P00001);
			this._userCheckRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
			this._userCheckRemote.initialize();
		}
		
		public function openHeartBeat() : void {
			if(this._level != UserDef.USER_LEVEL_NORMAL) {
				this._isActivation = true;
				if((this._heartBeatTimer) && !this._heartBeatTimer.running) {
					this.onHeartBeatTimer();
					this._heartBeatTimer.start();
				}
			}
		}
		
		public function closeHeartBeat() : void {
			this._isActivation = false;
			if((this._heartBeatTimer) && (this._heartBeatTimer.running)) {
				this._heartBeatTimer.stop();
			}
		}
		
		public function destroy() : void {
			if(this._userCheckRemote) {
				this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
				this._userCheckRemote.destroy();
				this._userCheckRemote = null;
			}
			if(this._heartBeatTimer) {
				this._heartBeatTimer.removeEventListener(TimerEvent.TIMER,this.onHeartBeatTimer);
				this._heartBeatTimer.stop();
				this._heartBeatTimer = null;
			}
			this._isActivation = false;
		}
		
		private function onCheckResult(param1:RemoteObjectEvent) : void {
			var _loc2_:* = 0;
			if(this._userCheckRemote.status == RemoteObjectStatusEnum.Success) {
				if(this._userCheckRemote.userLevel == UserDef.USER_LEVEL_NORMAL) {
					this._id = "";
					this._nickname = "";
					this._level = UserDef.USER_LEVEL_NORMAL;
					this._type = UserDef.USER_TYPE_QIYI;
					this._limitationType = this._userCheckRemote.limitationType;
				} else if(this._userCheckRemote.userLevel == UserDef.USER_LEVEL_PRIMARY) {
					this._id = this._userCheckRemote.userID;
					this._nickname = this._userCheckRemote.userName;
					this._level = this._userCheckRemote.userLevel;
					this._type = this._userCheckRemote.userType;
					_loc2_ = this._userCheckRemote.heartBeatTime;
					if(_loc2_ > 0) {
						if(_loc2_ < this.HEART_BEAT_MIN_TIME) {
							_loc2_ = this.HEART_BEAT_MIN_TIME;
						}
						if(this._heartBeatTimer == null) {
							this._heartBeatTimer = new Timer(_loc2_);
							this._heartBeatTimer.addEventListener(TimerEvent.TIMER,this.onHeartBeatTimer);
						} else {
							this._heartBeatTimer.delay = _loc2_;
						}
						if(this._isActivation) {
							this._heartBeatTimer.start();
						}
					}
				}
				
			} else if(this._userCheckRemote.status == RemoteObjectStatusEnum.Processing) {
				return;
			}
			
			this._log.info("check user complete,userID:" + this._id + ", userName:" + this._nickname + ", userLevel:" + this._level + ", userType:" + this._type + ", limitationType:" + this._limitationType + ", heartBeatTime:" + this._userCheckRemote.heartBeatTime);
			this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
			this._userCheckRemote.destroy();
			this._userCheckRemote = null;
			dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LoginSuccess));
		}
		
		private function onHeartBeatTimer(param1:Event = null) : void {
			var _loc2_:* = NaN;
			var _loc3_:Array = null;
			var _loc4_:String = null;
			var _loc5_:uint = 0;
			var _loc6_:String = null;
			var _loc7_:URLRequest = null;
			if(this._level != UserDef.USER_LEVEL_NORMAL) {
				_loc2_ = Math.random();
				_loc3_ = new Array();
				_loc3_.push("authcookie=" + this._P00001);
				_loc3_.push("tn=" + _loc2_);
				_loc3_.push("tv_id=" + this._tvid);
				_loc3_.push("device_id=" + UUIDManager.instance.uuid);
				_loc3_.push("agenttype=" + 1);
				_loc3_.sort();
				_loc4_ = "";
				_loc5_ = 0;
				while(_loc5_ < _loc3_.length) {
					_loc4_ = _loc4_ + (_loc3_[_loc5_] + "|");
					_loc5_++;
				}
				_loc4_ = _loc4_ + this.KEY;
				_loc4_ = MD5.calculate(_loc4_);
				_loc6_ = this.HEART_BEAT_URL;
				_loc6_ = _loc6_ + ("?authcookie=" + this._P00001);
				_loc6_ = _loc6_ + ("&agenttype=" + 1);
				_loc6_ = _loc6_ + ("&sign=" + _loc4_);
				_loc6_ = _loc6_ + ("&device_id=" + UUIDManager.instance.uuid);
				_loc6_ = _loc6_ + ("&tv_id=" + this._tvid);
				_loc6_ = _loc6_ + ("&tn=" + _loc2_);
				_loc7_ = new URLRequest(_loc6_);
				sendToURL(_loc7_);
			}
		}
	}
}
