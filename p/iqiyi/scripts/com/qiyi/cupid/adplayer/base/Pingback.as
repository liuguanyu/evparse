package com.qiyi.cupid.adplayer.base {
	import flash.utils.Dictionary;
	import flash.system.Capabilities;
	import com.qiyi.cupid.adplayer.utils.CupidAdPlayerUtils;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import com.qiyi.cupid.adplayer.utils.StringUtils;
	
	public class Pingback extends Object {
		
		public function Pingback() {
			super();
		}
		
		private static var log:Log = new Log("pingback");
		
		private var _pingbackType:String;
		
		private var _subtype:String;
		
		private var _uaaUserId:String;
		
		private var _cupidUserId:String;
		
		private var _tvId:String;
		
		private var _albumId:String;
		
		private var _channelId:String;
		
		private var _videoEventId:String;
		
		private var _adPlayerId:String;
		
		private var _customInfo:String;
		
		private var _passportId:String;
		
		private var _isPreload:String;
		
		private var _flashPlayerVersion:String;
		
		private var _location:String;
		
		private var _adClientVersion:String;
		
		private var _videoClientVersion:String;
		
		private var _requestDuration:int;
		
		private var _requestCount:int;
		
		private var _errCode:int;
		
		private var _errMsg:String;
		
		public function sendVisitPb(param1:Dictionary) : void {
			this._pingbackType = PingbackConst.TYPE_VISIT;
			this._subtype = PingbackConst.SUBTYPE_SUCCESS;
			this._tvId = param1["tvId"];
			this._albumId = param1["albumId"];
			this._channelId = param1["channelId"];
			this._isPreload = param1["isPreload"]?"1":"0";
			this._passportId = param1["passportId"];
			this._customInfo = [param1["videoClientUrl"],param1["adClientUrl"]].join("||");
			this._flashPlayerVersion = Capabilities.version;
			this._location = CupidAdPlayerUtils.getLocation();
			this.send(param1);
		}
		
		public function sendPlayerSuccess(param1:Dictionary, param2:int, param3:int) : void {
			this._pingbackType = PingbackConst.TYPE_PLAYER;
			this._subtype = PingbackConst.SUBTYPE_SUCCESS;
			this._requestDuration = param2;
			this._requestCount = param3;
			this.send(param1);
		}
		
		public function sendPlayerError(param1:Dictionary, param2:int, param3:String, param4:int) : void {
			this._pingbackType = PingbackConst.TYPE_PLAYER;
			this._subtype = PingbackConst.SUBTYPE_ERROR;
			this._requestCount = param4;
			this._errCode = param2;
			this._errMsg = param3;
			this.send(param1);
		}
		
		public function sendStatisticsAdBlock(param1:Dictionary, param2:int) : void {
			this._pingbackType = PingbackConst.TYPE_STATISTICS;
			this._subtype = PingbackConst.SUBTYPE_ADBLOCK;
			this._errCode = param2;
			this.send(param1);
		}
		
		private function send(param1:Dictionary) : void {
			this._uaaUserId = param1["uaaUserId"];
			this._cupidUserId = param1["cupidUserId"];
			this._videoEventId = param1["videoEventId2"];
			this._adPlayerId = param1["playerId"];
			this._adClientVersion = param1["adClientVersion"];
			this._videoClientVersion = param1["videoClientVersion"];
			this.ping();
		}
		
		private function ping() : void {
			var urlRequest:URLRequest = null;
			try {
				urlRequest = new URLRequest(this.generateUrl());
				sendToURL(urlRequest);
			}
			catch(e:Error) {
			}
		}
		
		private function generateUrl() : String {
			var _loc3_:String = null;
			var _loc4_:String = null;
			var _loc5_:String = null;
			var _loc1_:Dictionary = new Dictionary();
			_loc1_["p"] = this._pingbackType;
			_loc1_["t"] = this._subtype;
			_loc1_["u"] = this._uaaUserId;
			_loc1_["a"] = this._cupidUserId;
			_loc1_["v"] = this._tvId;
			_loc1_["b"] = this._albumId;
			_loc1_["c"] = this._channelId;
			_loc1_["e"] = this._videoEventId;
			_loc1_["y"] = this._adPlayerId;
			_loc1_["x"] = this._customInfo;
			_loc1_["s"] = new Date().time;
			_loc1_["pp"] = this._passportId;
			_loc1_["pl"] = this._isPreload;
			_loc1_["fp"] = this._flashPlayerVersion;
			_loc1_["lc"] = this._location;
			_loc1_["av"] = this._adClientVersion;
			_loc1_["vv"] = this._videoClientVersion;
			_loc1_["rd"] = this._requestDuration > 0?this._requestDuration.toString():"";
			_loc1_["rc"] = this._requestCount != 0?this._requestCount.toString():"";
			_loc1_["ec"] = this._errCode != 0?this._errCode.toString():"";
			_loc1_["em"] = this._errMsg;
			var _loc2_:Array = new Array();
			for(_loc3_ in _loc1_) {
				_loc5_ = _loc1_[_loc3_];
				if(!StringUtils.isEmpty(_loc5_)) {
					if(PingbackConst.ENCODE_FIELDS.indexOf(_loc3_) >= 0) {
						_loc5_ = encodeURIComponent(_loc5_);
					}
					_loc2_.push(_loc3_ + "=" + _loc5_);
				}
			}
			_loc4_ = PingbackConst.SERVICE_URL + _loc2_.join("&");
			log.debug("send",_loc4_);
			return _loc4_;
		}
	}
}
