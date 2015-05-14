package com.qiyi.player.user.impls
{
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.logging.Log;
	
	public class UserLocalSexRemote extends BaseRemoteObject
	{
		
		private const REMOTE_URL:String = "http://uaa.iqiyi.com/api/v1/userprofile";
		
		private var _uuid:String = "";
		
		private var _sex:int;
		
		private var _log:ILogger;
		
		public function UserLocalSexRemote(param1:String)
		{
			this._sex = UserDef.USER_SEX_NONE;
			this._log = Log.getLogger("com.qiyi.player.user.impls.UserLocalSexRemote");
			super(0,"UserLocalSexRemote");
			this._uuid = param1;
			_timeout = 2000;
			_retryMaxCount = 2;
		}
		
		public function get sex() : int
		{
			return this._sex;
		}
		
		override protected function getRequest() : URLRequest
		{
			var _loc1:String = this.REMOTE_URL + "?platform=1&id=" + this._uuid + "&tn=" + Math.random();
			return new URLRequest(_loc1);
		}
		
		override protected function onComplete(param1:Event) : void
		{
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			this._log.info("UserLocalSexRemote complete! uuid:" + this._uuid + " result:" + _loader.data);
			try
			{
				_data = com.adobe.serialization.json.JSON.decode(_loader.data as String);
				if(int(_data.code) == 100)
				{
					if((_data.profile) && (_data.profile.gender) && (_data.profile.gender.value))
					{
						this._sex = _data.profile.gender.value == "male"?UserDef.USER_SEX_MALE:UserDef.USER_SEX_FEMALE;
					}
					else
					{
						this._sex = UserDef.USER_SEX_NONE;
					}
				}
				else
				{
					this._sex = UserDef.USER_SEX_NONE;
				}
				super.onComplete(event);
			}
			catch(e:Error)
			{
				_sex = UserDef.USER_SEX_NONE;
				setStatus(RemoteObjectStatusEnum.DataError);
			}
		}
	}
}
