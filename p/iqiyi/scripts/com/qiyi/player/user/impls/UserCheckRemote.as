package com.qiyi.player.user.impls {
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import flash.utils.getTimer;
	import flash.net.URLRequest;
	import com.qiyi.player.base.utils.MD5;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.logging.Log;
	
	public class UserCheckRemote extends BaseRemoteObject {
		
		public function UserCheckRemote(param1:String, param2:String) {
			this._userLevel = UserDef.USER_LEVEL_NORMAL;
			this._userType = UserDef.USER_TYPE_QIYI;
			this._limitationType = UserDef.USER_LIMITATION_NONE;
			this._log = Log.getLogger("com.qiyi.player.wonder.body.model.remote.UserCheckRemote");
			super(0,"UserCheckRemote");
			this._passportID = param1;
			this._P00001 = param2;
			_timeout = 2000;
			_retryMaxCount = 2;
		}
		
		private const MEMBER_CHECK_URL:String = "http://passport.iqiyi.com/apis/user/check_vip.action";
		
		private const REQUEST_KEY:String = "w0JD89dhtS7BdPLU2";
		
		private const RESPONSE_KEY:String = "-0J1d9d^ESd)9jSsja";
		
		private var _passportID:String = "";
		
		private var _P00001:String = "";
		
		private var _userID:String = "";
		
		private var _userName:String = "";
		
		private var _userLevel:int;
		
		private var _userType:int;
		
		private var _limitationType:int;
		
		private var _heartBeatTime:int = 0;
		
		private var _log:ILogger;
		
		public function get userID() : String {
			return this._userID;
		}
		
		public function get userName() : String {
			return this._userName;
		}
		
		public function get userLevel() : int {
			return this._userLevel;
		}
		
		public function get userType() : int {
			return this._userType;
		}
		
		public function get limitationType() : int {
			return this._limitationType;
		}
		
		public function get heartBeatTime() : int {
			return this._heartBeatTime;
		}
		
		override public function initialize() : void {
			ProcessesTimeRecord.STime_userInfo = getTimer();
			super.initialize();
		}
		
		override protected function getRequest() : URLRequest {
			var subP00001:String = "";
			try {
				subP00001 = this._P00001.substring(4,36);
			}
			catch(e:Error) {
			}
			var url:String = this.MEMBER_CHECK_URL;
			url = url + ("?authcookie=" + this._P00001);
			url = url + ("&agenttype=" + 1);
			url = url + ("&sign=" + MD5.calculate(subP00001 + "|" + "1" + "|" + this.REQUEST_KEY));
			url = url + ("&tn=" + Math.random());
			return new URLRequest(url);
		}
		
		override protected function onComplete(param1:Event) : void {
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			ProcessesTimeRecord.usedTime_userInfo = getTimer() - ProcessesTimeRecord.STime_userInfo;
			this._log.info("Login user check info: " + _loader.data);
			try {
				_data = com.adobe.serialization.json.JSON.decode(_loader.data as String);
				if(_data.code == "A00000") {
					if(this.getResultSignVerify(_data)) {
						this._userLevel = UserDef.USER_LEVEL_PRIMARY;
						if((_data.data) && !(_data.data.keepalive == undefined)) {
							this._heartBeatTime = int(_data.data.keepalive) * 1000;
						} else {
							this._heartBeatTime = 0;
						}
					} else {
						this._userLevel = UserDef.USER_LEVEL_NORMAL;
						this._log.info("Login user check Sign verify error!");
					}
				} else {
					if(_data.code == "A10001") {
						this._limitationType = UserDef.USER_LIMITATION_UPPER;
					} else if(_data.code == "A10002") {
						this._limitationType = UserDef.USER_LIMITATION_CLOSING;
					}
					
					this._userLevel = UserDef.USER_LEVEL_NORMAL;
				}
				super.onComplete(event);
			}
			catch(e:Error) {
				_userLevel = UserDef.USER_LEVEL_NORMAL;
				_limitationType = UserDef.USER_LIMITATION_NONE;
				_heartBeatTime = 0;
				setStatus(RemoteObjectStatusEnum.DataError);
			}
		}
		
		private function getResultSignVerify(param1:Object) : Boolean {
			var rt:String = null;
			var var_1:Object = param1;
			var subP00001:String = "";
			try {
				subP00001 = this._P00001.substring(5,39);
				subP00001 = subP00001.split("").reverse().join("");
				rt = MD5.calculate(subP00001 + "<1" + "<" + this.RESPONSE_KEY);
				if(var_1.data) {
					if(var_1.data.sign == rt) {
						return true;
					}
				}
			}
			catch(e:Error) {
			}
			return false;
		}
	}
}
