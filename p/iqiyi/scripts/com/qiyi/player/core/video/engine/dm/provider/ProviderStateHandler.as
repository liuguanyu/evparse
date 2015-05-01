package com.qiyi.player.core.video.engine.dm.provider {
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.base.pub.EnumItem;
	import loader.vod.FileState;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.utils.Utility;
	import com.qiyi.player.core.model.def.TryWatchEnum;
	import flash.utils.getTimer;
	import com.qiyi.player.base.logging.Log;
	
	public class ProviderStateHandler extends Object {
		
		public function ProviderStateHandler(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.video.engine.dm.provider.ProviderStateHandler");
			super();
			this._holder = param1;
		}
		
		private var _holder:ICorePlayer;
		
		private var _log:ILogger;
		
		public function onStateChanged(param1:Provider) : void {
			var a:Array = null;
			var property:String = null;
			var tryWatchType:EnumItem = null;
			var var_34:Provider = param1;
			if(var_34 == null || var_34.fileState == null) {
				return;
			}
			var stateCode:int = var_34.fileState.stateCode;
			var data:String = var_34.fileState.data;
			var json:Object = null;
			if(stateCode == FileState.FirstDispatch + FileState.State_Success) {
				this._holder.runtimeData.errorCode = 0;
				this._log.debug("Provider.onStateChanged, FirstDispatch, success = " + stateCode);
				return;
			}
			if(stateCode == FileState.FirstDispatch + FileState.State_Timeout) {
				this._holder.runtimeData.errorCode = 3101;
				this._log.error("Provider.onStateChanged, FirstDispatch, timeout = " + stateCode);
				return;
			}
			if(stateCode == FileState.FirstDispatch + FileState.State_ConnectError) {
				this._holder.runtimeData.errorCode = 3102;
				this._log.error("Provider.onStateChanged, FirstDispatch, connect error = " + stateCode);
				return;
			}
			if(stateCode == FileState.FirstDispatch + FileState.State_DataError) {
				this._holder.runtimeData.errorCode = 3103;
				this._log.error("Provider.onStateChanged, FirstDispatch, data error = " + stateCode);
				return;
			}
			if(stateCode == FileState.FirstDispatch + FileState.State_SecurityError) {
				this._holder.runtimeData.errorCode = 3105;
				this._log.error("Provider.onStateChanged, FirstDispatch, security error = " + stateCode);
				return;
			}
			if(stateCode == FileState.SecondDispatch + FileState.State_Success) {
				try {
					this._holder.runtimeData.errorCode = 0;
					json = com.adobe.serialization.json.JSON.decode(data);
					this._holder.runtimeData.userDisInfo[var_34.fileState.index] = {
						"t":json.t,
						"z":json.z
					};
					this._holder.runtimeData.preDispatchArea = json.z;
					if(json.hasOwnProperty("s")) {
						this._holder.runtimeData.CDNStatus = int(json.s);
					}
					if(this._holder.runtimeData.currentUserIP == "") {
						a = String(json.t).split("-");
						this._holder.runtimeData.currentUserArea = a[0];
						this._holder.runtimeData.currentUserIP = a[1];
					}
					this._log.debug("Provider.onStateChanged, SecondDispatch, success = " + stateCode);
				}
				catch(e:Error) {
				}
				return;
			}
			if(stateCode == FileState.SecondDispatch + FileState.State_Timeout) {
				this._holder.runtimeData.errorCode = 3201;
				this._log.error("Provider.onStateChanged, SecondDispatch, timeout = " + stateCode);
				return;
			}
			if(stateCode == FileState.SecondDispatch + FileState.State_ConnectError) {
				this._holder.runtimeData.errorCode = 3202;
				this._log.error("Provider.onStateChanged, SecondDispatch, connect error = " + stateCode);
				return;
			}
			if(stateCode == FileState.SecondDispatch + FileState.State_DataError) {
				this._holder.runtimeData.errorCode = 3203;
				this._log.error("Provider.onStateChanged, SecondDispatch, data error = " + stateCode);
				return;
			}
			if(stateCode == FileState.SecondDispatch + FileState.State_SecurityError) {
				this._holder.runtimeData.errorCode = 3205;
				this._log.error("Provider.onStateChanged, SecondDispatch, security error = " + stateCode);
				return;
			}
			if(stateCode == FileState.AuthChecker + FileState.State_Success || stateCode == FileState.AuthChecker + FileState.State_AuthenticationError) {
				try {
					this._log.debug("AuthenticationRemote result:" + data);
					if(stateCode == FileState.AuthChecker + FileState.State_Success) {
						this._holder.runtimeData.errorCode = 0;
						this._holder.runtimeData.authenticationError = false;
						this._log.debug("Provider.onStateChanged, AuthChecker, success = " + stateCode);
					} else {
						this._holder.runtimeData.errorCode = 504;
						this._log.error("Provider.onStateChanged, AuthChecker, AuthenticationError = " + stateCode);
					}
					json = com.adobe.serialization.json.JSON.decode(data);
					if(json.code == "A00000") {
						this._holder.runtimeData.isTryWatch = json.data.prv == "1";
						if(this._holder.runtimeData.isTryWatch) {
							if(json.hasOwnProperty("previewType")) {
								tryWatchType = Utility.getItemById(TryWatchEnum.ITEMS,int(json.previewType));
								if(tryWatchType) {
									this._holder.runtimeData.tryWatchType = tryWatchType;
								}
							}
							if(json.hasOwnProperty("previewTime")) {
								this._holder.runtimeData.tryWatchTime = int(json.previewTime) * 60 * 1000;
							}
							if(json.hasOwnProperty("previewEpisodes")) {
							}
						}
						this._holder.runtimeData.dispatcherServerTime = Number(json.data.st);
						this._holder.runtimeData.dispatchFlashRunTime = int(getTimer() / 1000);
					} else {
						this._holder.runtimeData.authenticationError = true;
					}
					for(property in json) {
						this._holder.runtimeData.authentication[property] = json[property];
					}
				}
				catch(e:Error) {
				}
				return;
			}
			if(stateCode == FileState.AuthChecker + FileState.State_Timeout) {
				this._holder.runtimeData.errorCode = 501;
				this._log.error("Provider.onStateChanged, AuthChecker, timeout = " + stateCode);
				return;
			}
			if(stateCode == FileState.AuthChecker + FileState.State_ConnectError) {
				this._holder.runtimeData.errorCode = 502;
				this._log.error("Provider.onStateChanged, AuthChecker, connect error = " + stateCode);
				return;
			}
			if(stateCode == FileState.AuthChecker + FileState.State_DataError) {
				this._holder.runtimeData.errorCode = 503;
				this._log.error("Provider.onStateChanged, AuthChecker, data error = " + stateCode);
				return;
			}
			if(stateCode == FileState.AuthChecker + FileState.State_SecurityError) {
				this._holder.runtimeData.errorCode = 505;
				this._log.error("Provider.onStateChanged, AuthChecker, security error = " + stateCode);
				return;
			}
			if(stateCode == FileState.AuthDispatch + FileState.State_Success) {
				this._log.debug("Provider.onStateChanged, AuthDispatch, success = " + stateCode);
				try {
					this._holder.runtimeData.errorCode = 0;
					json = com.adobe.serialization.json.JSON.decode(data);
					this._holder.runtimeData.userDisInfo[var_34.fileState.index] = {
						"t":json.t,
						"z":json.z
					};
					this._holder.runtimeData.preDispatchArea = json.z;
					if(this._holder.runtimeData.currentUserIP == "") {
						this._holder.runtimeData.currentUserIP = String(json.t).split("-")[1];
					}
				}
				catch(e:Error) {
				}
				return;
			}
			if(stateCode == FileState.AuthDispatch + FileState.State_Timeout) {
				this._holder.runtimeData.errorCode = 3201;
				this._log.error("Provider.onStateChanged, AuthDispatch, timeout = " + stateCode);
				return;
			}
			if(stateCode == FileState.AuthDispatch + FileState.State_ConnectError) {
				this._holder.runtimeData.errorCode = 3202;
				this._log.error("Provider.onStateChanged, AuthDispatch, connect error = " + stateCode);
				return;
			}
			if(stateCode == FileState.AuthDispatch + FileState.State_DataError) {
				this._holder.runtimeData.errorCode = 3203;
				this._log.error("Provider.onStateChanged, AuthDispatch, data error = " + stateCode);
				return;
			}
			if(stateCode == FileState.AuthDispatch + FileState.State_SecurityError) {
				this._holder.runtimeData.errorCode = 3205;
				this._log.error("Provider.onStateChanged, AuthDispatch, security error = " + stateCode);
				return;
			}
			if(stateCode == FileState.CDNRequest + FileState.State_Success) {
				this._holder.runtimeData.errorCode = 0;
				this._log.debug("Provider.onStateChanged, CDNRequest, success = " + stateCode);
				return;
			}
			if(stateCode == FileState.CDNRequest + FileState.State_Timeout) {
				this._holder.runtimeData.errorCode = 4011;
				this._log.error("Provider.onStateChanged, CDNRequest, timeout = " + stateCode);
				return;
			}
			if(stateCode == FileState.CDNRequest + FileState.State_ConnectError) {
				this._holder.runtimeData.errorCode = 4012;
				this._log.error("Provider.onStateChanged, CDNRequest, connect error = " + stateCode);
				return;
			}
			if(stateCode == FileState.CDNRequest + FileState.State_DataError) {
				this._holder.runtimeData.errorCode = 4016;
				this._log.error("Provider.onStateChanged, CDNRequest, data error = " + stateCode);
				return;
			}
			if(stateCode == FileState.CDNRequest + FileState.State_SecurityError) {
				this._holder.runtimeData.errorCode = 4017;
				this._log.error("Provider.onStateChanged, CDNRequest, security error = " + stateCode);
				return;
			}
		}
		
		public function onFinalError(param1:Provider) : void {
			if(param1 == null || param1.fileState == null) {
				return;
			}
			var _loc2_:int = param1.fileState.stateCode;
			var _loc3_:String = param1.fileState.data;
			this._log.error("Provider.onFinalError, code = " + _loc2_);
			if(_loc2_ == FileState.FirstDispatch + FileState.State_Timeout) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.FirstDispatch + FileState.State_ConnectError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.FirstDispatch + FileState.State_DataError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.FirstDispatch + FileState.State_SecurityError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.SecondDispatch + FileState.State_Timeout) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.SecondDispatch + FileState.State_ConnectError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.SecondDispatch + FileState.State_DataError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.SecondDispatch + FileState.State_SecurityError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.AuthChecker + FileState.State_Timeout) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.AuthChecker + FileState.State_ConnectError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.AuthChecker + FileState.State_DataError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.AuthChecker + FileState.State_SecurityError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.AuthDispatch + FileState.State_Timeout) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.AuthDispatch + FileState.State_ConnectError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.AuthDispatch + FileState.State_DataError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.AuthDispatch + FileState.State_SecurityError) {
				this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
				return;
			}
			if(_loc2_ == FileState.CDNRequest + FileState.State_Timeout) {
				return;
			}
			if(_loc2_ == FileState.CDNRequest + FileState.State_ConnectError) {
				return;
			}
			if(_loc2_ == FileState.CDNRequest + FileState.State_DataError) {
				return;
			}
			if(_loc2_ == FileState.CDNRequest + FileState.State_SecurityError) {
				return;
			}
		}
	}
}
