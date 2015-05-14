package com.qiyi.player.user.impls
{
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.base.uuid.UUIDManager;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.user.UserManagerEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class UserLocalSex extends EventDispatcher
	{
		
		private const COMMON_COOKIE_NAME:String = "qiyi_player_common";
		
		private const SO_TIMEOUT_TIME:int = 604800.0;
		
		private var _sex:int;
		
		private var _state:int;
		
		private var _userLocalSexRemote:UserLocalSexRemote;
		
		private var _SO:SharedObject;
		
		private var _log:ILogger;
		
		public function UserLocalSex()
		{
			this._sex = UserDef.USER_SEX_NONE;
			this._state = UserDef.USER_LOCAL_SEX_STATE_NONE;
			this._log = Log.getLogger("com.qiyi.player.user.impls.UserLocalSex");
			super();
		}
		
		public function get state() : int
		{
			return this._state;
		}
		
		public function load() : void
		{
			var tmpUserLocalSex:int = 0;
			var tmpUserLocalSexSaveTime:uint = 0;
			var date:Date = null;
			var curSecond:uint = 0;
			var uuid:String = null;
			if(this._state == UserDef.USER_LOCAL_SEX_STATE_NONE)
			{
				tmpUserLocalSex = -1;
				tmpUserLocalSexSaveTime = 0;
				try
				{
					if(this._SO == null)
					{
						this._SO = SharedObject.getLocal(this.COMMON_COOKIE_NAME,"/");
					}
					if(this._SO.size > 0)
					{
						if(!(this._SO.data.user_localSex == undefined) && !(this._SO.data.user_localSexSaveTime == undefined))
						{
							tmpUserLocalSex = this._SO.data.user_localSex;
							tmpUserLocalSexSaveTime = this._SO.data.user_localSexSaveTime;
						}
					}
				}
				catch(e:Error)
				{
				}
				date = new Date();
				curSecond = date.time / 1000;
				if(tmpUserLocalSex >= UserDef.USER_SEX_BEGIN && tmpUserLocalSex < UserDef.USER_SEX_END && !(tmpUserLocalSex == UserDef.USER_SEX_NONE) && curSecond - tmpUserLocalSexSaveTime < this.SO_TIMEOUT_TIME)
				{
					this._sex = tmpUserLocalSex;
					this._state = UserDef.USER_LOCAL_SEX_STATE_COMPLETE;
					this._log.info("local sex from SO! sex is " + this._sex);
				}
				else
				{
					uuid = UUIDManager.instance.uuid;
					if(uuid)
					{
						this._state = UserDef.USER_LOCAL_SEX_STATE_LOADING;
						this._userLocalSexRemote = new UserLocalSexRemote(uuid);
						this._userLocalSexRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
						this._userLocalSexRemote.initialize();
					}
					else
					{
						this.randomSex();
						this.saveSex();
						this._state = UserDef.USER_LOCAL_SEX_STATE_COMPLETE;
						this._log.info("local sex uuid is none! sex is " + this._sex);
					}
				}
			}
			if(this._state == UserDef.USER_LOCAL_SEX_STATE_NONE)
			{
				return;
			}
		}
		
		public function getSex() : int
		{
			return this._sex;
		}
		
		public function setSex(param1:int, param2:Boolean = true) : void
		{
			if(!(param1 == this._sex) && param1 >= UserDef.USER_SEX_BEGIN && param1 < UserDef.USER_SEX_END)
			{
				this._sex = param1;
				this.destroyUserLocalSexRemote();
				if(param2)
				{
					this.saveSex();
				}
			}
		}
		
		private function onCheckResult(param1:RemoteObjectEvent) : void
		{
			if(this._userLocalSexRemote.status == RemoteObjectStatusEnum.Success)
			{
				this._sex = this._userLocalSexRemote.sex;
				if(this._sex == UserDef.USER_SEX_NONE)
				{
					this.randomSex();
				}
			}
			else
			{
				this.randomSex();
			}
			this.saveSex();
			this.destroyUserLocalSexRemote();
			this._state = UserDef.USER_LOCAL_SEX_STATE_COMPLETE;
			dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LocalSexInitComplete));
		}
		
		private function randomSex() : void
		{
			if(Math.random() > 0.5)
			{
				this._sex = UserDef.USER_SEX_MALE;
			}
			else
			{
				this._sex = UserDef.USER_SEX_FEMALE;
			}
		}
		
		private function saveSex() : void
		{
			var date:Date = null;
			var curSecond:uint = 0;
			try
			{
				if(this._SO == null)
				{
					this._SO = SharedObject.getLocal(this.COMMON_COOKIE_NAME,"/");
				}
				this._SO.data.user_localSex = this._sex;
				date = new Date();
				curSecond = date.time / 1000;
				this._SO.data.user_localSexSaveTime = curSecond;
				this._SO.flush();
			}
			catch(e:Error)
			{
			}
		}
		
		private function destroyUserLocalSexRemote() : void
		{
			if(this._userLocalSexRemote)
			{
				this._userLocalSexRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged,this.onCheckResult);
				this._userLocalSexRemote.destroy();
				this._userLocalSexRemote = null;
			}
		}
	}
}
