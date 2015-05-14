package com.qiyi.player.core.model.remote
{
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import com.qiyi.player.base.utils.MD5;
	import com.qiyi.player.core.Config;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.base.uuid.UUIDManager;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import com.qiyi.player.base.pub.EnumItem;
	import flash.utils.clearTimeout;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.utils.Utility;
	import com.qiyi.player.core.model.def.TryWatchEnum;
	import flash.utils.getTimer;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.core.model.utils.ErrorCodeUtils;
	import com.qiyi.player.base.logging.Log;
	
	public class AuthenticationRemote extends BaseRemoteObject
	{
		
		private var _holder:ICorePlayer;
		
		private var _segmentIndex:int;
		
		private var _log:ILogger;
		
		public function AuthenticationRemote(param1:int, param2:ICorePlayer)
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.remote.AuthenticationRemote");
			super(0,"AuthenticationRemote");
			this._holder = param2;
			this._segmentIndex = param1;
			_timeout = 5000;
			_retryMaxCount = 2;
		}
		
		override public function initialize() : void
		{
			super.initialize();
		}
		
		override protected function getRequest() : URLRequest
		{
			var s:String = null;
			var ut:Number = NaN;
			var utt:String = null;
			var vt:String = null;
			var MdStr:String = null;
			var uts:String = null;
			var request:URLRequest = null;
			var variables:URLVariables = null;
			try
			{
				this._holder.runtimeData.authenticationError = false;
				s = uint(0 ^ 2.391461978E9).toString();
				ut = new Date().time;
				uts = ut.toString();
				utt = String(ut % 1000 * int(uts.substr(0,2)) + (100 + this._segmentIndex));
				MdStr = this._holder.runtimeData.albumId + "_" + this._holder.runtimeData.communicationlId + "_" + this._holder.runtimeData.vid + "_" + uts + "_" + utt + "_" + s;
				vt = MD5.calculate(MdStr);
				this._log.debug("primitive MD5 String :" + MdStr);
				this._log.debug("MD5 String:" + vt);
				request = new URLRequest(Config.VIP_AUTH_URL);
				variables = new URLVariables();
				variables.ut = ut;
				variables.vid = this._holder.runtimeData.vid;
				variables.cid = this._holder.runtimeData.communicationlId;
				variables.aid = this._holder.runtimeData.albumId;
				variables.utt = utt;
				variables.v = vt;
				variables.version = "1.0";
				if((UserManager.getInstance().user) && (UserManager.getInstance().user.P00001))
				{
				}
				variables.uuid = UUIDManager.instance.uuid;
				if(this._holder.runtimeData.playerType)
				{
					variables.playType = this._holder.runtimeData.playerType.name;
				}
				variables.platform = "b6c13e26323c537d";
				request.method = URLRequestMethod.POST;
				request.data = variables;
			}
			catch(e:Error)
			{
				_log.warn("AuthenticationRemote create URLRequest error");
				return null;
			}
			return request;
		}
		
		override protected function onComplete(param1:Event) : void
		{
			var property:String = null;
			var tryWatchType:EnumItem = null;
			var s:String = null;
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			try
			{
				this._log.debug("AuthenticationRemote result:" + _loader.data);
				_data = com.adobe.serialization.json.JSON.decode(_loader.data);
				if(_data.code == "A00000")
				{
					this._holder.runtimeData.key = _data.data.t;
					this._holder.runtimeData.QY00001 = _data.data.u;
					this._holder.runtimeData.isTryWatch = _data.data.prv == "1";
					if(this._holder.runtimeData.isTryWatch)
					{
						if(_data.hasOwnProperty("previewType"))
						{
							tryWatchType = Utility.getItemById(TryWatchEnum.ITEMS,int(_data.previewType));
							if(tryWatchType)
							{
								this._holder.runtimeData.tryWatchType = tryWatchType;
							}
						}
						if(_data.hasOwnProperty("previewTime"))
						{
							this._holder.runtimeData.tryWatchTime = int(_data.previewTime) * 60 * 1000;
						}
						if(_data.hasOwnProperty("previewEpisodes"))
						{
						}
					}
					this._holder.runtimeData.dispatcherServerTime = Number(_data.data.st);
					this._holder.runtimeData.dispatchFlashRunTime = int(getTimer() / 1000);
				}
				else
				{
					this._holder.runtimeData.authenticationError = true;
				}
				for(property in _data)
				{
					this._holder.runtimeData.authentication[property] = _data[property];
				}
				super.onComplete(event);
			}
			catch(e:Error)
			{
				_log.error("AuthenticationRemote parse JSON error");
				s = _loader.data;
				if(s)
				{
					_log.info(s.substr(0,100));
				}
				setStatus(RemoteObjectStatusEnum.DataError);
			}
		}
		
		override protected function setStatus(param1:EnumItem) : void
		{
			var _loc2:* = 0;
			if(param1 == RemoteObjectStatusEnum.Timeout || param1 == RemoteObjectStatusEnum.ConnectError || param1 == RemoteObjectStatusEnum.DataError || param1 == RemoteObjectStatusEnum.AuthenticationError || param1 == RemoteObjectStatusEnum.SecurityError || param1 == RemoteObjectStatusEnum.UnknownError)
			{
				_loc2 = ErrorCodeUtils.getErrorCodeByRemoteObject(this,param1);
				if(this._holder.pingBack)
				{
					this._holder.pingBack.sendError(_loc2);
				}
				this._holder.runtimeData.errorCode = _loc2;
			}
			super.setStatus(param1);
		}
	}
}
