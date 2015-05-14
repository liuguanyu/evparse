package com.qiyi.player.user.impls
{
	import flash.events.EventDispatcher;
	import com.qiyi.player.user.IUser;
	import com.qiyi.player.user.UserManagerEvent;
	
	public class UserManager extends EventDispatcher
	{
		
		private static var _instance:UserManager;
		
		private var _currentUser:User;
		
		private var _tmpUser:User;
		
		private var _userLocalSex:UserLocalSex;
		
		public function UserManager(param1:SingletonClass)
		{
			super();
			this._userLocalSex = new UserLocalSex();
		}
		
		public static function getInstance() : UserManager
		{
			if(_instance == null)
			{
				_instance = new UserManager(new SingletonClass());
			}
			return _instance;
		}
		
		public function get user() : IUser
		{
			return this._currentUser;
		}
		
		public function get userLocalSex() : UserLocalSex
		{
			return this._userLocalSex;
		}
		
		public function login(param1:String, param2:String, param3:String = "", param4:String = "") : void
		{
			this.destroyUser();
			this._tmpUser = new User(param1,param2,param3,param4);
			this._tmpUser.addEventListener(UserManagerEvent.Evt_LoginSuccess,this.onLoginSuccess);
			this._tmpUser.checkUser();
		}
		
		public function logout() : void
		{
			var _loc1:* = !(this._currentUser == null);
			this.destroyUser();
			if(_loc1)
			{
				dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LogoutSuccess));
			}
		}
		
		private function destroyUser() : void
		{
			if(this._currentUser)
			{
				this._currentUser.removeEventListener(UserManagerEvent.Evt_LoginSuccess,this.onLoginSuccess);
				this._currentUser.destroy();
			}
			else if(this._tmpUser)
			{
				this._tmpUser.removeEventListener(UserManagerEvent.Evt_LoginSuccess,this.onLoginSuccess);
				this._tmpUser.destroy();
			}
			
			this._currentUser = null;
			this._tmpUser = null;
		}
		
		private function onLoginSuccess(param1:UserManagerEvent) : void
		{
			this._currentUser = this._tmpUser;
			this._tmpUser = null;
			dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LoginSuccess));
		}
	}
}

class SingletonClass extends Object
{
	
	function SingletonClass()
	{
		super();
	}
}
