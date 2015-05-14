package com.qiyi.player.user.impls
{
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
	
	public class User extends EventDispatcher implements IUser
	{
		
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
		
		public function User(param1:String, param2:String, param3:String, param4:String)
		{
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
		
		public function get passportID() : String
		{
			return this._passportID;
		}
		
		public function get P00001() : String
		{
			return this._P00001;
		}
		
		public function get profileID() : String
		{
			return this._profileID;
		}
		
		public function get profileCookie() : String
		{
			return this._profileCookie;
		}
		
		public function get nickName() : String
		{
			return this._nickname;
		}
		
		public function get id() : String
		{
			return this._id;
		}
		
		public function get type() : int
		{
			return this._type;
		}
		
		public function get level() : int
		{
			return this._level;
		}
		
		public function get limitationType() : int
		{
			return this._limitationType;
		}
		
		public function set tvid(param1:String) : void
		{
			this._tvid = param1;
		}
		
		public function checkUser() : void
		{
			if(this._userCheckRemote)
			{
				this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
				this._userCheckRemote.destroy();
			}
			this._userCheckRemote = new UserCheckRemote(this._passportID,this._P00001);
			this._userCheckRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
			this._userCheckRemote.initialize();
		}
		
		public function openHeartBeat() : void
		{
			if(this._level != UserDef.USER_LEVEL_NORMAL)
			{
				this._isActivation = true;
				if((this._heartBeatTimer) && !this._heartBeatTimer.running)
				{
					this.onHeartBeatTimer();
					this._heartBeatTimer.start();
				}
			}
		}
		
		public function closeHeartBeat() : void
		{
			this._isActivation = false;
			if((this._heartBeatTimer) && (this._heartBeatTimer.running))
			{
				this._heartBeatTimer.stop();
			}
		}
		
		public function destroy() : void
		{
			if(this._userCheckRemote)
			{
				this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
				this._userCheckRemote.destroy();
				this._userCheckRemote = null;
			}
			if(this._heartBeatTimer)
			{
				this._heartBeatTimer.removeEventListener(TimerEvent.TIMER,this.onHeartBeatTimer);
				this._heartBeatTimer.stop();
				this._heartBeatTimer = null;
			}
			this._isActivation = false;
		}
		
		private function onCheckResult(param1:RemoteObjectEvent) : void
		{
			var _loc2:* = 0;
			if(this._userCheckRemote.status == RemoteObjectStatusEnum.Success)
			{
				if(this._userCheckRemote.userLevel == UserDef.USER_LEVEL_NORMAL)
				{
					this._id = "";
					this._nickname = "";
					this._level = UserDef.USER_LEVEL_NORMAL;
					this._type = UserDef.USER_TYPE_QIYI;
					this._limitationType = this._userCheckRemote.limitationType;
				}
				else if(this._userCheckRemote.userLevel == UserDef.USER_LEVEL_PRIMARY)
				{
					this._id = this._userCheckRemote.userID;
					this._nickname = this._userCheckRemote.userName;
					this._level = this._userCheckRemote.userLevel;
					this._type = this._userCheckRemote.userType;
					_loc2 = this._userCheckRemote.heartBeatTime;
					if(_loc2 > 0)
					{
						if(_loc2 < this.HEART_BEAT_MIN_TIME)
						{
							_loc2 = this.HEART_BEAT_MIN_TIME;
						}
						if(this._heartBeatTimer == null)
						{
							this._heartBeatTimer = new Timer(_loc2);
							this._heartBeatTimer.addEventListener(TimerEvent.TIMER,this.onHeartBeatTimer);
						}
						else
						{
							this._heartBeatTimer.delay = _loc2;
						}
						if(this._isActivation)
						{
							this._heartBeatTimer.start();
						}
					}
				}
				
			}
			else if(this._userCheckRemote.status == RemoteObjectStatusEnum.Processing)
			{
				return;
			}
			
			this._log.info("check user complete,userID:" + this._id + ", userName:" + this._nickname + ", userLevel:" + this._level + ", userType:" + this._type + ", limitationType:" + this._limitationType + ", heartBeatTime:" + this._userCheckRemote.heartBeatTime);
			this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
			this._userCheckRemote.destroy();
			this._userCheckRemote = null;
			dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LoginSuccess));
		}
		
		private function onHeartBeatTimer(param1:Event = null) : void
		{
			var _loc2:* = NaN;
			var _loc3:Array = null;
			var _loc4:String = null;
			var _loc5:uint = 0;
			var _loc6:String = null;
			var _loc7:URLRequest = null;
			if(this._level != UserDef.USER_LEVEL_NORMAL)
			{
				_loc2 = Math.random();
				_loc3 = new Array();
				_loc3.push("authcookie=" + this._P00001);
				_loc3.push("tn=" + _loc2);
				_loc3.push("tv_id=" + this._tvid);
				_loc3.push("device_id=" + UUIDManager.instance.uuid);
				_loc3.push("agenttype=" + 1);
				_loc3.sort();
				_loc4 = "";
				_loc5 = 0;
				while(_loc5 < _loc3.length)
				{
					_loc4 = _loc4 + (_loc3[_loc5] + "|");
					_loc5++;
				}
				_loc4 = _loc4 + this.KEY;
				_loc4 = MD5.calculate(_loc4);
				_loc6 = this.HEART_BEAT_URL;
				_loc6 = _loc6 + ("?authcookie=" + this._P00001);
				_loc6 = _loc6 + ("&agenttype=" + 1);
				_loc6 = _loc6 + ("&sign=" + _loc4);
				_loc6 = _loc6 + ("&device_id=" + UUIDManager.instance.uuid);
				_loc6 = _loc6 + ("&tv_id=" + this._tvid);
				_loc6 = _loc6 + ("&tn=" + _loc2);
				_loc7 = new URLRequest(_loc6);
				sendToURL(_loc7);
			}
		}
	}
}
