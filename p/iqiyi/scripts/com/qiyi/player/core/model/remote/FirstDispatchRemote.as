package com.qiyi.player.core.model.remote
{
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import com.qiyi.player.core.Config;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import com.adobe.serialization.json.JSON;
	import flash.utils.getTimer;
	import com.qiyi.player.base.utils.KeyUtils;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.utils.ErrorCodeUtils;
	import com.qiyi.player.base.logging.Log;
	
	public class FirstDispatchRemote extends BaseRemoteObject
	{
		
		private var _segment:Segment;
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function FirstDispatchRemote(param1:Segment, param2:ICorePlayer)
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.remote.FirstDispatchRemote");
			super(0,"FirstDispatchRemote" + Math.random());
			this._segment = param1;
			this._holder = param2;
			_timeout = Config.DISPATCH_TIMEOUT;
			_retryMaxCount = Config.DISPATCH_MAX_RETRY;
		}
		
		override protected function getRequest() : URLRequest
		{
			var _loc1:String = Config.FIRST_DISPATCH_URL + "?tn=" + Math.random();
			return new URLRequest(_loc1);
		}
		
		override public function initialize() : void
		{
			if(this._holder.runtimeData.dispatcherServerTime == 0)
			{
				super.initialize();
			}
			else
			{
				this.onComplete(null);
			}
		}
		
		override protected function onComplete(param1:Event) : void
		{
			var time:uint = 0;
			var s:String = null;
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			try
			{
				time = 0;
				if(event)
				{
					_data = com.adobe.serialization.json.JSON.decode(_loader.data);
					this._holder.runtimeData.dispatchFlashRunTime = int(getTimer() / 1000);
					this._holder.runtimeData.dispatcherServerTime = uint(_data.t);
					time = this._holder.runtimeData.dispatcherServerTime;
				}
				else
				{
					time = uint(getTimer() / 1000) - this._holder.runtimeData.dispatchFlashRunTime + this._holder.runtimeData.dispatcherServerTime;
				}
				this._holder.runtimeData.key = KeyUtils.getDispatchKey(time,this._segment.rid);
				super.onComplete(event);
			}
			catch(e:Error)
			{
				_log.error("FirstDispatch parse JSON error:");
				s = _loader.data;
				if(s)
				{
					_log.info(s.substr(0,100));
				}
				this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception,e));
				setStatus(RemoteObjectStatusEnum.DataError);
			}
		}
		
		override protected function setStatus(param1:EnumItem) : void
		{
			var _loc2:* = 0;
			if(param1 == RemoteObjectStatusEnum.Timeout || param1 == RemoteObjectStatusEnum.ConnectError || param1 == RemoteObjectStatusEnum.DataError || param1 == RemoteObjectStatusEnum.AuthenticationError || param1 == RemoteObjectStatusEnum.SecurityError || param1 == RemoteObjectStatusEnum.UnknownError)
			{
				_loc2 = ErrorCodeUtils.getErrorCodeByRemoteObject(this,param1);
				this._holder.pingBack.sendError(_loc2);
				this._holder.runtimeData.errorCode = _loc2;
			}
			super.setStatus(param1);
		}
	}
}
