package com.qiyi.player.core.model.remote {
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import com.qiyi.player.core.model.impls.Segment;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import com.qiyi.player.base.uuid.UUIDManager;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.rpc.RemoteObjectEvent;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.utils.ErrorCodeUtils;
	import com.qiyi.player.base.logging.Log;
	import com.qiyi.player.core.Config;
	
	public class MemberDispatchRemote extends BaseRemoteObject {
		
		public function MemberDispatchRemote(param1:Segment, param2:int, param3:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.model.remote.MemberDispatchRemote");
			super(0,"MemberDispatchRemote");
			this._segment = param1;
			this._startPos = param2;
			this._holder = param3;
			this._holder.runtimeData.authenticationError = false;
			_retryMaxCount = Config.DISPATCH_MAX_RETRY;
			_timeout = Config.DISPATCH_TIMEOUT;
		}
		
		private var _segment:Segment;
		
		private var _startPos:int = -1;
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		override protected function getRequest() : URLRequest {
			var _loc1_:String = this._segment.url.split(".f4v").join(".hml");
			_loc1_ = _loc1_ + ("?t=" + this._holder.runtimeData.key + "&cid=" + this._holder.runtimeData.communicationlId + "&vid=" + this._holder.runtimeData.vid);
			_loc1_ = _loc1_ + ("&QY00001=" + this._holder.runtimeData.QY00001);
			if(this._startPos == -1) {
				if((this._segment.currentKeyframe) && !(this._segment.currentKeyframe.index == 0)) {
					_loc1_ = _loc1_ + ("&start=" + this._segment.currentKeyframe.position);
				}
			} else if(this._startPos != 0) {
				_loc1_ = _loc1_ + ("&start=" + this._startPos.toString());
			}
			
			if(this._holder.runtimeData.retryCount > 0) {
				_loc1_ = _loc1_ + ("&retry=" + this._holder.runtimeData.retryCount.toString());
			}
			_loc1_ = _loc1_ + ("&su=" + UUIDManager.instance.uuid);
			_loc1_ = _loc1_ + ("&client=" + this._holder.runtimeData.currentUserIP);
			_loc1_ = _loc1_ + ("&z=" + this._holder.runtimeData.preDispatchArea);
			_loc1_ = _loc1_ + ("&mi=" + this._holder.runtimeData.movieInfo);
			_loc1_ = _loc1_ + ("&bt=" + this._holder.runtimeData.preDefinition);
			_loc1_ = _loc1_ + ("&ct=" + this._holder.runtimeData.currentDefinition);
			if(this._holder.runtimeData.preAverageSpeed > 0) {
				_loc1_ = _loc1_ + ("&s=" + this._holder.runtimeData.preAverageSpeed.toString());
			}
			_loc1_ = _loc1_ + ("&e=" + this._holder.runtimeData.preErrorCode);
			_loc1_ = _loc1_ + ("&qyid=" + UUIDManager.instance.uuid);
			_loc1_ = _loc1_ + ("&tn=" + getTimer());
			return new URLRequest(_loc1_);
		}
		
		override protected function onComplete(param1:Event) : void {
			var s:String = null;
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			try {
				_data = com.adobe.serialization.json.JSON.decode(_loader.data);
				this._holder.runtimeData.userDisInfo[this._segment.index] = {
					"t":_data.t,
					"z":_data.z
				};
				this._holder.runtimeData.preDispatchArea = _data.z;
				if(this._holder.runtimeData.currentUserIP == "") {
					try {
						this._holder.runtimeData.currentUserIP = String(_data.t).split("-")[1];
					}
					catch(e:Error) {
					}
				}
				super.onComplete(event);
			}
			catch(e:Error) {
				_log.error("MemberDispatch: parse JSON error");
				s = _loader.data;
				if(s) {
					_log.info(s.substr(0,100));
				}
				this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception,RemoteObjectStatusEnum.DataError));
				setStatus(RemoteObjectStatusEnum.DataError);
			}
		}
		
		override protected function setStatus(param1:EnumItem) : void {
			var _loc2_:* = 0;
			if(param1 == RemoteObjectStatusEnum.Timeout || param1 == RemoteObjectStatusEnum.ConnectError || param1 == RemoteObjectStatusEnum.DataError || param1 == RemoteObjectStatusEnum.AuthenticationError || param1 == RemoteObjectStatusEnum.SecurityError || param1 == RemoteObjectStatusEnum.UnknownError) {
				_loc2_ = ErrorCodeUtils.getErrorCodeByRemoteObject(this,param1);
				this._holder.pingBack.sendError(_loc2_);
				this._holder.runtimeData.errorCode = _loc2_;
			}
			super.setStatus(param1);
		}
	}
}
