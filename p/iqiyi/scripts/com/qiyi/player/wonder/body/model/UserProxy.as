package com.qiyi.player.wonder.body.model {
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.wonder.body.model.remote.BonusRemote;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.user.UserManagerEvent;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.common.utils.ConstUtils;
	import com.qiyi.player.wonder.common.lso.LSO;
	import com.qiyi.player.base.logging.Log;
	
	public class UserProxy extends Proxy {
		
		public function UserProxy() {
			this._log = Log.getLogger("com.qiyi.player.wonder.body.model.UserProxy");
			super(NAME);
			this._bonusRemote = new BonusRemote();
			UserManager.getInstance().userLocalSex.load();
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.body.model.UserProxy";
		
		private var _playerProxy:PlayerProxy;
		
		private var _isLogin:Boolean = false;
		
		private var _passportID:String = "";
		
		private var _P00001:String = "";
		
		private var _profileID:String = "";
		
		private var _profileCookie:String = "";
		
		private var _bonusRemote:BonusRemote;
		
		private var _bonusCompleted:Boolean = false;
		
		private var _initPlayer:Boolean = false;
		
		private var _log:ILogger;
		
		public function get isLogin() : Boolean {
			return this._isLogin;
		}
		
		public function set isLogin(param1:Boolean) : void {
			this._isLogin = param1;
		}
		
		public function get passportID() : String {
			return this._passportID;
		}
		
		public function set passportID(param1:String) : void {
			this._passportID = param1;
		}
		
		public function get P00001() : String {
			return this._P00001;
		}
		
		public function set P00001(param1:String) : void {
			this._P00001 = param1;
		}
		
		public function get profileID() : String {
			return this._profileID;
		}
		
		public function set profileID(param1:String) : void {
			this._profileID = param1;
		}
		
		public function get profileCookie() : String {
			return this._profileCookie;
		}
		
		public function set profileCookie(param1:String) : void {
			this._profileCookie = param1;
		}
		
		public function get userID() : String {
			if(UserManager.getInstance().user) {
				return UserManager.getInstance().user.id;
			}
			return "";
		}
		
		public function get userName() : String {
			if(UserManager.getInstance().user) {
				return UserManager.getInstance().user.nickName;
			}
			return "";
		}
		
		public function get userLevel() : int {
			if(UserManager.getInstance().user) {
				return UserManager.getInstance().user.level;
			}
			return UserDef.USER_LEVEL_NORMAL;
		}
		
		public function get userType() : int {
			if(UserManager.getInstance().user) {
				return UserManager.getInstance().user.type;
			}
			return UserDef.USER_TYPE_QIYI;
		}
		
		public function get bonusCompleted() : Boolean {
			return this._bonusCompleted;
		}
		
		public function set bonusCompleted(param1:Boolean) : void {
			this._bonusCompleted = param1;
		}
		
		public function injectPlayerProxy(param1:PlayerProxy) : void {
			this._playerProxy = param1;
		}
		
		public function checkUser() : void {
			if(this._isLogin) {
				UserManager.getInstance().addEventListener(UserManagerEvent.Evt_LoginSuccess,this.onUserLoginSuccess);
				UserManager.getInstance().login(this._passportID,this._P00001,this._profileID,this._profileCookie);
			} else {
				UserManager.getInstance().removeEventListener(UserManagerEvent.Evt_LoginSuccess,this.onUserLoginSuccess);
				UserManager.getInstance().logout();
				if(!this._initPlayer) {
					this._initPlayer = true;
					sendNotification(BodyDef.NOTIFIC_REQUEST_INIT_PLAYER);
				}
				this._log.info("check user complete,userID:" + this.userID + ", userName:" + this.userName + ", userLevel:" + this.userLevel + ", userType:" + this.userType);
				sendNotification(BodyDef.NOTIFIC_CHECK_USER_COMPLETE);
				sendNotification(BodyDef.NOTIFIC_CHECK_TRY_WATCH_REFRESH);
			}
		}
		
		public function saveOneMinusBonus(param1:uint) : void {
			var _loc2_:String = null;
			if(!this._bonusCompleted) {
				if(this._isLogin) {
					_loc2_ = (this._playerProxy.curActor.movieInfo) && !(this._playerProxy.curActor.movieInfo.infoJSON.sid == undefined)?this._playerProxy.curActor.movieInfo.infoJSON.sid:"";
					if(param1 > ConstUtils.MIN_2_MS) {
						this._bonusRemote.sendOneMinute(this._playerProxy.curActor.uuid,this._playerProxy.curActor.movieModel.tvid,this._playerProxy.curActor.movieModel.channelID,this._playerProxy.curActor.movieModel.albumId,_loc2_);
						this._bonusCompleted = true;
					}
				} else if(param1 > ConstUtils.MIN_2_MS) {
					LSO.getInstance().addBonus();
					this._bonusCompleted = true;
				}
				
			}
		}
		
		public function savePlayOverBonus(param1:uint, param2:int) : void {
			var _loc3_:String = null;
			if(!this._bonusCompleted) {
				if(this._isLogin) {
					_loc3_ = (this._playerProxy.curActor.movieInfo) && !(this._playerProxy.curActor.movieInfo.infoJSON.sid == undefined)?this._playerProxy.curActor.movieInfo.infoJSON.sid:"";
					if(param1 > ConstUtils.MIN_2_MS || param1 <= ConstUtils.MIN_2_MS && param2 <= ConstUtils.MIN_2_MS) {
						this._bonusRemote.sendPlayOver(this._playerProxy.curActor.uuid,this._playerProxy.curActor.movieModel.tvid,this._playerProxy.curActor.movieModel.channelID,this._playerProxy.curActor.movieModel.albumId,_loc3_);
						this._bonusCompleted = true;
					}
				} else if(param1 > ConstUtils.MIN_2_MS || param1 <= ConstUtils.MIN_2_MS && param2 <= ConstUtils.MIN_2_MS) {
					LSO.getInstance().addBonus();
					this._bonusCompleted = true;
				}
				
			}
		}
		
		public function saveTotalBonus(param1:uint, param2:String) : void {
			var _loc3_:String = (this._playerProxy.curActor.movieInfo) && !(this._playerProxy.curActor.movieInfo.infoJSON.sid == undefined)?this._playerProxy.curActor.movieInfo.infoJSON.sid:"";
			this._bonusRemote.sendSavedTotalBonus(param1,param2,_loc3_);
		}
		
		private function onUserLoginSuccess(param1:UserManagerEvent) : void {
			UserManager.getInstance().removeEventListener(UserManagerEvent.Evt_LoginSuccess,this.onUserLoginSuccess);
			if(!this._initPlayer) {
				this._initPlayer = true;
				sendNotification(BodyDef.NOTIFIC_REQUEST_INIT_PLAYER);
			}
			sendNotification(BodyDef.NOTIFIC_CHECK_USER_COMPLETE);
			sendNotification(BodyDef.NOTIFIC_CHECK_TRY_WATCH_REFRESH);
		}
	}
}
