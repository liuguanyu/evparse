package com.qiyi.player.core.model.remote {
	import com.qiyi.player.base.rpc.impl.BaseRemoteObject;
	import flash.utils.Dictionary;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.logging.ILogger;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import com.qiyi.player.core.player.def.PlayerUseTypeEnum;
	import com.qiyi.player.base.utils.MD5;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.core.Config;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.base.rpc.RemoteObjectStatusEnum;
	import flash.net.sendToURL;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.utils.ErrorCodeUtils;
	import com.qiyi.player.base.logging.Log;
	
	public class MixerRemote extends BaseRemoteObject {
		
		public function MixerRemote(param1:ICorePlayer) {
			this._log = Log.getLogger("com.qiyi.player.core.model.remote.MixerRemote");
			super(0,"MixerRemote");
			this._holder = param1;
			this._holder.runtimeData.authenticationError = false;
			_timeout = Config.MIXER_TIMEOUT;
			_retryMaxCount = Config.MIXER_MAX_RETRY;
		}
		
		private static var _vmsErrorMap:Dictionary = null;
		
		public static function get VMSErrorMap() : Dictionary {
			if(_vmsErrorMap == null) {
				_vmsErrorMap = new Dictionary();
				_vmsErrorMap["A000001"] = 707;
				_vmsErrorMap["A000003"] = 708;
				_vmsErrorMap["A000004"] = 709;
			}
			return _vmsErrorMap;
		}
		
		private var _holder:ICorePlayer;
		
		private var _requestDuration:int = 0;
		
		private var _log:ILogger;
		
		override protected function getRequest() : URLRequest {
			var _loc1_:String = null;
			this._requestDuration = getTimer();
			if(this._holder.pingBack) {
				this._holder.pingBack.sendStartLoadVrs();
			}
			var _loc2_:* = 0;
			if(this._holder.runtimeData.CDNStatus == -1 && this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN) {
				_loc2_ = 1;
			} else {
				_loc2_ = 0;
			}
			var _loc3_:* = "aw6UWGtp";
			var _loc4_:uint = getTimer();
			var _loc5_:String = MD5.calculate(_loc3_ + String(_loc4_) + this._holder.runtimeData.tvid);
			var _loc6_:String = MD5.calculate(MD5.calculate(this._holder.runtimeData.ugcAuthKey) + String(_loc4_) + this._holder.runtimeData.tvid);
			var _loc7_:String = Settings.instance.boss?"&vv=821d3c731e374feaa629dcdaab7c394b":"";
			var _loc8_:String = (UserManager.getInstance().user) && !(UserManager.getInstance().user.level == UserDef.USER_LEVEL_NORMAL)?"1":"0";
			if(!this._holder.runtimeData.movieIsMember) {
				_loc1_ = Config.MIXER_VX_URL + "?key=fvip&src=1702633101b340d8917a69cf8a4b8c7c" + "&tvId=" + this._holder.runtimeData.tvid + "&vid=" + this._holder.runtimeData.originalVid + "&vinfo=" + _loc2_ + "&tm=" + _loc4_ + "&enc=" + _loc5_ + "&qyid=" + this._holder.uuid + "&puid=" + (UserManager.getInstance().user?UserManager.getInstance().user.passportID:"") + "&authKey=" + _loc6_ + "&um=" + _loc8_ + _loc7_ + "&thdk=" + this._holder.runtimeData.thdKey + "&thdt=" + this._holder.runtimeData.thdToken + "&tn=" + Math.random();
				this._holder.runtimeData.ugcAuthKey = "";
			} else {
				_loc1_ = Config.MIXER_VX_VIP_URL + "?key=fvinp&src=1702633101b340d8917a69cf8a4b8c7c" + "&tvId=" + this._holder.runtimeData.tvid + "&vid=" + this._holder.runtimeData.originalVid + "&cid=" + this._holder.runtimeData.communicationlId + "&token=" + this._holder.runtimeData.key + "&uid=" + this._holder.runtimeData.QY00001 + "&pf=b6c13e26323c537d" + "&vinfo=" + _loc2_ + "&tm=" + _loc4_ + "&enc=" + _loc5_ + "&qyid=" + this._holder.uuid + "&puid=" + (UserManager.getInstance().user?UserManager.getInstance().user.passportID:"") + "&authKey=" + _loc6_ + "&um=" + _loc8_ + _loc7_ + "&thdk=" + this._holder.runtimeData.thdKey + "&thdt=" + this._holder.runtimeData.thdToken + "&tn=" + Math.random();
			}
			return new URLRequest(_loc1_);
		}
		
		override public function initialize() : void {
			ProcessesTimeRecord.STime_vms = getTimer();
			super.initialize();
		}
		
		override protected function onComplete(param1:Event) : void {
			var json:Object = null;
			var event:Event = param1;
			clearTimeout(_waitingResponse);
			_waitingResponse = 0;
			ProcessesTimeRecord.usedTime_vms = getTimer() - ProcessesTimeRecord.STime_vms;
			if(this._requestDuration > 0) {
				this._requestDuration = getTimer() - this._requestDuration;
				if(this._holder.pingBack) {
					this._holder.pingBack.sendVRSRequestTime(this._requestDuration);
				}
			}
			try {
				json = com.adobe.serialization.json.JSON.decode(_loader.data);
				if((json) && (json.code == "A000000") && (json.data)) {
					_data = new Object();
					_data.code = json.code;
					_data.useCache = false;
					_data.vp = json.data.vp != undefined?json.data.vp:null;
					_data.vi = json.data.vi != undefined?json.data.vi:null;
					_data.f4v = json.data.f4v != undefined?json.data.f4v:null;
					if(this._holder.runtimeData.movieIsMember) {
						_data.vp = json.data.np != undefined?json.data.np:null;
					}
					super.onComplete(event);
				} else if((json) && !(VMSErrorMap[json.code] == null)) {
					_data = new Object();
					_data.code = json.code;
					super.onComplete(event);
				} else {
					this._log.error("MixerRemote failed to load the mixer data, code: " + (json != null?json.code:""));
					this.setStatus(RemoteObjectStatusEnum.DataError);
				}
				
			}
			catch(e:Error) {
				_log.fatal("MixerRemote, the mixer data is invalid:");
				if(_loader.data) {
					_log.info(_loader.data.substr(0,100));
					sendHijackPingBack(_loader.data);
				}
				setStatus(RemoteObjectStatusEnum.DataError);
				return;
			}
		}
		
		private function sendHijackPingBack(param1:String) : void {
			var request:URLRequest = null;
			var var_35:String = param1;
			if(var_35) {
				try {
					request = new URLRequest();
					request.url = "http://msg.video.qiyi.com/tmpstats.gif?type=isphijack20140210&rt=" + encodeURIComponent(var_35.substr(0,500)) + "&tn=" + Math.random();
					sendToURL(request);
				}
				catch(e:Error) {
				}
			}
		}
		
		override protected function setStatus(param1:EnumItem) : void {
			var _loc2_:* = 0;
			if(param1 == RemoteObjectStatusEnum.Timeout || param1 == RemoteObjectStatusEnum.ConnectError || param1 == RemoteObjectStatusEnum.DataError || param1 == RemoteObjectStatusEnum.SecurityError || param1 == RemoteObjectStatusEnum.UnknownError) {
				_loc2_ = ErrorCodeUtils.getErrorCodeByRemoteObject(this,param1);
				if(this._holder.pingBack) {
					this._holder.pingBack.sendError(_loc2_);
				}
				this._holder.runtimeData.errorCode = _loc2_;
			}
			super.setStatus(param1);
		}
	}
}
