package com.qiyi.player.core.model.remote
{
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import com.qiyi.player.base.utils.Utility;
	import com.qiyi.player.base.uuid.UUIDManager;
	import flash.events.Event;
	import com.adobe.serialization.json.JSON;
	import flash.utils.*;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.utils.ErrorCodeUtils;
	import com.qiyi.player.base.logging.Log;
	import com.qiyi.player.core.Config;
	
	public class SecondDispatchRemote extends BaseRemoteObject
	{
		
		private var _segment:Segment;
		
		private var _startPos:int = -1;
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function SecondDispatchRemote(param1:Segment, param2:int, param3:ICorePlayer)
		{
			this._log = Log.getLogger("com.qiyi.player.core.model.remote.SecondDispatchRemote");
			super(0,"SecondDispatchRemote" + Math.random());
			this._segment = param1;
			this._startPos = param2;
			this._holder = param3;
			_retryMaxCount = Config.DISPATCH_MAX_RETRY;
			_timeout = Config.DISPATCH_TIMEOUT;
		}
		
		override protected function getRequest() : URLRequest
		{
			var _loc1:String = Utility.getUrl(this._segment.url,this._holder.runtimeData.key);
			if(this._startPos == -1)
			{
				if((this._segment.currentKeyframe) && !(this._segment.currentKeyframe.index == 0))
				{
					_loc1 = _loc1 + ("?start=" + this._segment.currentKeyframe.position.toString());
				}
			}
			else if(this._startPos != 0)
			{
				_loc1 = _loc1 + ("?start=" + this._startPos.toString());
			}
			
			_loc1 = _loc1 + (_loc1.indexOf("?") == -1?"?":"&");
			_loc1 = _loc1 + ("su=" + UUIDManager.instance.uuid);
			if(this._holder.runtimeData.retryCount > 0)
			{
				_loc1 = _loc1 + ("&retry=" + this._holder.runtimeData.retryCount.toString());
			}
			_loc1 = _loc1 + ("&client=" + this._holder.runtimeData.currentUserIP);
			_loc1 = _loc1 + ("&z=" + this._holder.runtimeData.preDispatchArea);
			_loc1 = _loc1 + ("&mi=" + this._holder.runtimeData.movieInfo);
			_loc1 = _loc1 + ("&bt=" + this._holder.runtimeData.preDefinition);
			_loc1 = _loc1 + ("&ct=" + this._holder.runtimeData.currentDefinition);
			if(this._holder.runtimeData.preAverageSpeed > 0)
			{
				_loc1 = _loc1 + ("&s=" + this._holder.runtimeData.preAverageSpeed.toString());
			}
			_loc1 = _loc1 + ("&e=" + this._holder.runtimeData.preErrorCode);
			_loc1 = _loc1 + ("&qyid=" + UUIDManager.instance.uuid);
			_loc1 = _loc1 + ("&tn=" + getTimer());
			return new URLRequest(_loc1);
		}
		
		override protected function onComplete(param1:Event) : void
		{
			var a:Array = null;
			var s:String = null;
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			try
			{
				_data = com.adobe.serialization.json.JSON.decode(_loader.data);
				this._holder.runtimeData.userDisInfo[this._segment.index] = {
					"t":_data.t,
					"z":_data.z
				};
				this._holder.runtimeData.preDispatchArea = _data.z;
				if(_data.hasOwnProperty("s"))
				{
					this._holder.runtimeData.CDNStatus = int(_data.s);
				}
				else
				{
					this._holder.runtimeData.CDNStatus = 0;
				}
				if(this._holder.runtimeData.currentUserIP == "")
				{
					try
					{
						a = String(_data.t).split("-");
						this._holder.runtimeData.currentUserArea = a[0];
						this._holder.runtimeData.currentUserIP = a[1];
					}
					catch(e:Error)
					{
					}
				}
				super.onComplete(event);
			}
			catch(e:Error)
			{
				_log.error("SecondDispatch: parse JSON error");
				s = _loader.data;
				if(s)
				{
					_log.info(s.substr(0,100));
				}
				this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception,RemoteObjectStatusEnum.DataError));
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
