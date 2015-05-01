package com.qiyi.cupid.adplayer {
	import flash.display.Sprite;
	import com.qiyi.cupid.adplayer.base.Log;
	import flash.events.IEventDispatcher;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import com.qiyi.cupid.adplayer.model.AdBlockedBlackScreen;
	import com.qiyi.cupid.adplayer.events.AdPlayerEvent;
	import com.qiyi.cupid.adplayer.base.Pingback;
	import flash.utils.getTimer;
	import com.qiyi.cupid.adplayer.base.PingbackConst;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import com.qiyi.cupid.adplayer.events.AdBlockedBlackScreenEvent;
	import flash.utils.clearTimeout;
	import com.adobe.crypto.MD5;
	import flash.display.StageDisplayState;
	import com.qiyi.cupid.adplayer.base.CupidParam;
	
	public class CupidAdPlayer extends Sprite {
		
		public function CupidAdPlayer(param1:CupidParam) {
			super();
			log.debug("init",VERSION);
			log.debug("init param",param1.toObject());
			this._videoClientVersion = param1.videoPlayerVersion;
			this._videoId = param1.videoId;
			this._tvId = param1.tvId;
			this._channelId = param1.channelId;
			this._collectionId = param1.collectionId;
			this._rawPlayerId = param1.playerId;
			this._playerId = this.getPlayerId(param1.playerId,this._channelId);
			this._albumId = param1.albumId;
			this._uaaUserId = param1.userId;
			this._webEventId = param1.webEventId;
			this._videoEventId = param1.videoEventId;
			this._vipRight = param1.vipRight;
			this._terminal = param1.terminal;
			this._duration = param1.duration;
			this._passportId = param1.passportId;
			this._passportCookie = param1.passportCookie;
			this._passportKey = param1.passportKey;
			this._videoDefinitionId = param1.videoDefinitionId;
			this._cacheMachineIp = param1.cacheMachineIp;
			this._couponCode = param1.couponCode;
			this._couponVer = param1.couponVer;
			this._videoPlaySecondsOfDay = param1.videoPlaySecondsOfDay;
			if(this.isQiyiWebEx()) {
				this._adClientUrl = this.IQIYI_WEBEX_AM_URL;
			} else if(param1.playerUrl) {
				this._adClientUrl = param1.playerUrl;
			} else {
				this._adClientUrl = this.IQIYI_WEB_AM_URL;
			}
			
			if(param1.dispatcher == null) {
				this._dispatcher = this;
			} else {
				this._dispatcher = param1.dispatcher;
			}
			this._volume = param1.volume;
			this._videoIndex = param1.videoIndex;
			this._stageWidth = param1.stageWidth;
			this._stageHeight = param1.stageHeight;
			this._displayContainer = param1.adContainer;
			this._screenStatus = this.isFullScreen()?"1":"0";
			this._baiduMainVideo = param1.baiduMainVideo;
			this._disablePreroll = param1.disablePreroll;
			this._disableSkipAd = param1.disableSkipAd;
			this._enableVideoCore = param1.enableVideoCore;
			this._isUGC = param1.isUGC;
			this._videoClientUrl = this._displayContainer.loaderInfo?this._displayContainer.loaderInfo.loaderURL:"";
			this._videoEventId2 = this.generateVideoEventId();
			this._env = this.generateEnv();
			this.addAdPlayerEventListeners();
		}
		
		private static var log:Log = new Log("main");
		
		public static const VERSION:String = "2.5.0";
		
		private var _tvId:String;
		
		private var _videoId:String;
		
		private var _albumId:String;
		
		private var _channelId:uint;
		
		private var _collectionId:String;
		
		private var _webEventId:String;
		
		private var _videoEventId:String;
		
		private var _videoEventId2:String;
		
		private var _uaaUserId:String;
		
		private var _vipRight:String;
		
		private var _terminal:String;
		
		private var _duration:Number;
		
		private var _passportId:String;
		
		private var _passportCookie:String;
		
		private var _passportKey:String;
		
		private var _enableVideoCore:Boolean;
		
		private var _isUGC:Boolean;
		
		private var _videoDefinitionId:Number;
		
		private var _dispatcher:IEventDispatcher;
		
		private var _cacheMachineIp:String;
		
		private var _displayContainer:DisplayObjectContainer;
		
		private var _volume:Number;
		
		private var _videoIndex:int;
		
		private var _stageWidth:Number;
		
		private var _stageHeight:Number;
		
		private var _screenStatus:String;
		
		private var _baiduMainVideo:String;
		
		private var _disablePreroll:Boolean;
		
		private var _disableSkipAd:Boolean;
		
		private var _playerId:String;
		
		private var _videoClientUrl:String;
		
		private var _videoClientVersion:String;
		
		private var _adClientUrl:String;
		
		private var _adManager;
		
		private var _playerLoader:Loader;
		
		private var _playerUrlLoader:URLLoader;
		
		private var _playerRequest:URLRequest;
		
		private var _speed:Number;
		
		private var _startTime:Number;
		
		private var _startupTime:Number;
		
		private var _loadPlayerTimeout:uint;
		
		private var _playerTimeOutLengthsIndex:int = 0;
		
		private var _couponCode:String;
		
		private var _couponVer:String;
		
		private var _rawPlayerId:String;
		
		private var _videoPlaySecondsOfDay:int;
		
		private const PLAYER_TIMEOUT_LENGTHS:Array = new Array(10000,15000);
		
		private var _env:Dictionary;
		
		private var _adBlockedBlackScreen:AdBlockedBlackScreen;
		
		private const IQIYI_WEB_AM_URL:String = "http://www.iqiyi.com/player/cupid/common/iamw.swf";
		
		private const IQIYI_WEBEX_AM_URL:String = "http://www.iqiyi.com/player/cupid/common/iamo.swf";
		
		private function getPlayerId(param1:String, param2:int) : String {
			if((param1) && (16 == param1.length) && 0 == param1.indexOf("qc_")) {
				return param1;
			}
			log.debug("invalid player id",param1,"channel id",param2);
			var _loc3_:Object = {
				1:"qc_100001_100014",
				2:"qc_100001_100015",
				3:"qc_100001_100002",
				4:"qc_100001_100012",
				5:"qc_100001_100003",
				6:"qc_100001_100016",
				7:"qc_100001_100017",
				8:"qc_100001_100161",
				9:"qc_100001_100018",
				10:"qc_100001_100019",
				12:"qc_100001_100106",
				13:"qc_100001_100062",
				15:"qc_100001_100147",
				16:"qc_100001_100071",
				17:"qc_100001_100089",
				18:"qc_100001_100082",
				20:"qc_100001_100100",
				21:"qc_100001_100095",
				22:"qc_100001_100099",
				24:"qc_100001_100128",
				25:"qc_100001_100153",
				26:"qc_100001_100156",
				27:"qc_100001_100226",
				28:"qc_100001_100327",
				29:"qc_100001_100436",
				30:"qc_100001_100435"
			};
			return _loc3_[param2] || _loc3_[27];
		}
		
		private function addAdPlayerEventListeners() : void {
			this._dispatcher.addEventListener(AdPlayerEvent.VIDEO_CHANGE_SIZE,this.onChangeSize);
			this._dispatcher.addEventListener(AdPlayerEvent.VIDEO_FULLSCREEN,this.onFullscreen);
			this._dispatcher.addEventListener(AdPlayerEvent.VIDEO_NORMALSCREEN,this.onNormalscreen);
		}
		
		private function removeAdPlayerEventListeners() : void {
			this._dispatcher.removeEventListener(AdPlayerEvent.VIDEO_CHANGE_SIZE,this.onChangeSize);
			this._dispatcher.removeEventListener(AdPlayerEvent.VIDEO_FULLSCREEN,this.onFullscreen);
			this._dispatcher.removeEventListener(AdPlayerEvent.VIDEO_NORMALSCREEN,this.onNormalscreen);
		}
		
		private function onChangeSize(param1:AdPlayerEvent) : void {
			if(param1.data) {
				this._stageWidth = param1.data.width;
				this._stageHeight = param1.data.height;
			}
			this.resizeBlackScreen();
		}
		
		private function onFullscreen(param1:AdPlayerEvent) : void {
			this._screenStatus = "1";
		}
		
		private function onNormalscreen(param1:AdPlayerEvent) : void {
			this._screenStatus = "0";
		}
		
		public function load() : void {
			log.debug("load");
			new Pingback().sendVisitPb(this._env);
			this._startupTime = getTimer();
			if((this.canShowBlackScreen()) && (AdBlockedBlackScreen.isInBlacklist(this._videoClientUrl))) {
				log.error("illegal player",this._videoClientUrl);
				this.onAdBlocked({"errCode":PingbackConst.CODE_VP_ILLEGAL});
				return;
			}
			this.cleanBeforeLoad();
			this.loadPlayer(this._adClientUrl);
		}
		
		private function loadPlayer(param1:String) : void {
			this._playerRequest = new URLRequest(param1);
			this.tryGetPlayer();
		}
		
		private function tryGetPlayer() : void {
			log.debug("load player",this._playerRequest.url,"time",this._playerTimeOutLengthsIndex + 1);
			this.clearPlayerLoader();
			this.clearPlayerUrlLoader();
			this.clearPlayerTimeout();
			try {
				this._playerUrlLoader = new URLLoader();
				this._playerUrlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				this.addPlayerUrlLoaderEventListeners(this._playerUrlLoader);
				this._loadPlayerTimeout = setTimeout(this.playerTimeoutHandler,this.PLAYER_TIMEOUT_LENGTHS[this._playerTimeOutLengthsIndex]);
				this._startTime = new Date().time;
				this._playerUrlLoader.load(this._playerRequest);
			}
			catch(e:Error) {
				log.error("load error",e.message,e.getStackTrace());
				playerErrorHandler(e.message);
			}
		}
		
		private function addPlayerUrlLoaderEventListeners(param1:URLLoader) : void {
			param1.addEventListener(Event.OPEN,this.playerOpenHandler);
			param1.addEventListener(Event.COMPLETE,this.playerCompleteHandler);
			param1.addEventListener(IOErrorEvent.IO_ERROR,this.playerIOErrorHandler);
			param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.playerSecurityErrorHandler);
		}
		
		private function removePlayerUrlLoaderEventListeners(param1:URLLoader) : void {
			param1.removeEventListener(Event.OPEN,this.playerOpenHandler);
			param1.removeEventListener(Event.COMPLETE,this.playerCompleteHandler);
			param1.removeEventListener(IOErrorEvent.IO_ERROR,this.playerIOErrorHandler);
			param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.playerSecurityErrorHandler);
		}
		
		private function playerOpenHandler(param1:Event) : void {
			log.debug("open");
			this.clearPlayerTimeout();
		}
		
		private function playerCompleteHandler(param1:Event) : void {
			var totalTime:Number = NaN;
			var totalKb:Number = NaN;
			var byteArray:ByteArray = null;
			var e:Event = param1;
			this.removePlayerUrlLoaderEventListeners(this._playerUrlLoader);
			try {
				totalTime = (new Date().time - this._startTime) / 1000;
				totalKb = this._playerUrlLoader.bytesTotal / 1024;
				this._speed = Math.round(totalKb / totalTime);
				log.debug("load complete, speed",this._speed + "k/s");
				byteArray = this._playerUrlLoader.data;
				this._playerLoader = new Loader();
				this._playerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.playerLoadedHandler);
				this._playerLoader.loadBytes(byteArray,new LoaderContext(false,ApplicationDomain.currentDomain));
			}
			catch(error:Error) {
				log.error("catch error while loading bytes",error.message,error.getStackTrace());
				playerErrorHandler(error.message);
			}
		}
		
		private function playerLoadedHandler(param1:Event) : void {
			var param:Object = null;
			var errMsg:String = null;
			var e:Event = param1;
			log.debug("loaded");
			this._playerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.playerLoadedHandler);
			try {
				this._adManager = e.target.content;
				if((this._adManager) && (this._adManager.hasOwnProperty("start"))) {
					this.removeAdPlayerEventListeners();
					param = {
						"tvId":this._tvId,
						"videoId":this._videoId,
						"channelId":this._channelId,
						"albumId":this._albumId,
						"collectionId":this._collectionId,
						"stageWidth":this._stageWidth,
						"stageHeight":this._stageHeight,
						"screenStatus":this._screenStatus,
						"userId":this._uaaUserId,
						"uaaUserId":this._uaaUserId,
						"vipRight":this._vipRight,
						"webEventId":this._webEventId,
						"cacheMachineIp":this._cacheMachineIp,
						"videoEventId":this._videoEventId,
						"videoEventId2":this._videoEventId2,
						"playerId":this._playerId,
						"rawPlayerId":this._rawPlayerId,
						"speed":this._speed,
						"terminal":this._terminal,
						"duration":this._duration,
						"passportId":this._passportId,
						"passportCookie":this._passportCookie,
						"passportKey":this._passportKey,
						"videoDefinitionId":this._videoDefinitionId,
						"baiduMainVideo":this._baiduMainVideo,
						"disablePreroll":this._disablePreroll,
						"disableSkipAd":this._disableSkipAd,
						"enableVideoCore":this._enableVideoCore,
						"volume":this._volume,
						"videoIndex":this._videoIndex,
						"isUGC":this._isUGC,
						"videoPlayerVersion":this._videoClientVersion,
						"videoClientVersion":this._videoClientVersion,
						"videoClientUrl":this._videoClientUrl,
						"adClientUrl":this._adClientUrl,
						"couponCode":this._couponCode,
						"couponVer":this._couponVer,
						"enableCP2":true,
						"videoPlaySecondsOfDay":this._videoPlaySecondsOfDay,
						"otherInfo":{
							"startupTime":this._startupTime,
							"playerRetry":this._playerTimeOutLengthsIndex
						}
					};
					log.debug("call ad player",param);
					this._adManager.start(this._dispatcher,this._displayContainer,param);
					new Pingback().sendPlayerSuccess(this._env,getTimer() - this._startupTime,this.calRequestCount());
				} else {
					log.error("ad player init error: no definition");
					errMsg = "interface missing";
					new Pingback().sendPlayerError(this._env,PingbackConst.CODE_PL_INIT_ERROR,errMsg,this.calRequestCount());
					if(this.canShowBlackScreen()) {
						this.onAdBlocked({"errCode":PingbackConst.CODE_PL_INIT_ERROR});
					} else {
						this.onAdPlayerFailure();
					}
				}
			}
			catch(error:Error) {
				log.error("init error",error.message,error.getStackTrace());
				new Pingback().sendPlayerError(_env,PingbackConst.CODE_PL_RUNTIME_ERROR,error.message,calRequestCount());
				onAdPlayerFailure();
			}
		}
		
		private function playerIOErrorHandler(param1:IOErrorEvent) : void {
			log.error("io error",this._playerTimeOutLengthsIndex + 1);
			this.playerErrorHandler("io");
		}
		
		private function playerSecurityErrorHandler(param1:SecurityErrorEvent) : void {
			log.error("security error",this._playerTimeOutLengthsIndex + 1);
			this.playerErrorHandler("security");
		}
		
		private function playerErrorHandler(param1:String) : void {
			this.clearPlayerTimeout();
			this.clearPlayerLoader();
			this.clearPlayerUrlLoader();
			if(this.retryGetPlayer()) {
				return;
			}
			new Pingback().sendPlayerError(this._env,PingbackConst.CODE_PL_HTTP_ERROR,param1,this.calRequestCount());
			if(this.canShowBlackScreen()) {
				this.onAdBlocked({"errCode":PingbackConst.CODE_PL_HTTP_ERROR});
			} else {
				this.onAdPlayerFailure();
			}
		}
		
		private function onAdBlocked(param1:Object) : void {
			new Pingback().sendStatisticsAdBlock(this._env,param1.errCode);
			this.showBlackScreen();
		}
		
		private function showBlackScreen() : void {
			log.debug("show black screen");
			this._adBlockedBlackScreen = new AdBlockedBlackScreen(this._stageWidth,this._stageHeight);
			this._adBlockedBlackScreen.addEventListener(AdBlockedBlackScreenEvent.BLACK_SCREEN_COMPLETE,this.onBlackScreenComplete);
			this._displayContainer.stage.addChild(this._adBlockedBlackScreen);
			this._adBlockedBlackScreen.show();
		}
		
		private function onBlackScreenComplete(param1:AdBlockedBlackScreenEvent) : void {
			var _loc2_:Object = null;
			this.clearBlackScreen();
			this.onAdPlayerBlock();
			if(this._dispatcher) {
				_loc2_ = {
					"tvId":this._tvId,
					"videoId":this._videoId
				};
				this._dispatcher.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.CONTROL_VIDEO_START,_loc2_));
				log.debug("black screen complete and control video start");
			}
		}
		
		private function resizeBlackScreen() : void {
			if(this._adBlockedBlackScreen) {
				this._adBlockedBlackScreen.resize(this._stageWidth,this._stageHeight);
			}
		}
		
		private function clearBlackScreen() : void {
			log.debug("clear black screen");
			if(this._adBlockedBlackScreen) {
				this._adBlockedBlackScreen.removeEventListener(AdBlockedBlackScreenEvent.BLACK_SCREEN_COMPLETE,this.onBlackScreenComplete);
				this._adBlockedBlackScreen.destroy();
				if(this._displayContainer.stage.contains(this._adBlockedBlackScreen)) {
					this._displayContainer.stage.removeChild(this._adBlockedBlackScreen);
				}
				this._adBlockedBlackScreen = null;
			}
		}
		
		private function playerTimeoutHandler() : void {
			log.debug("timeout",this._playerTimeOutLengthsIndex + 1);
			this.clearPlayerTimeout();
			this.clearPlayerLoader();
			this.clearPlayerUrlLoader();
			if(this.retryGetPlayer()) {
				return;
			}
			new Pingback().sendPlayerError(this._env,PingbackConst.CODE_PL_TIMEOUT,"timeout",this.calRequestCount());
			this.onAdPlayerFailure();
		}
		
		private function clearPlayerUrlLoader() : void {
			if(this._playerUrlLoader) {
				this.removePlayerUrlLoaderEventListeners(this._playerUrlLoader);
				try {
					this._playerUrlLoader.close();
				}
				catch(e:Error) {
				}
				this._playerUrlLoader = null;
			}
		}
		
		private function clearPlayerLoader() : void {
			if(this._playerLoader) {
				this._playerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.playerLoadedHandler);
				try {
					this._playerLoader.unloadAndStop();
					this._playerLoader.close();
				}
				catch(e:Error) {
				}
				this._playerLoader = null;
			}
		}
		
		private function clearPlayerTimeout() : void {
			if(this._loadPlayerTimeout) {
				clearTimeout(this._loadPlayerTimeout);
				this._loadPlayerTimeout = 0;
			}
		}
		
		private function retryGetPlayer() : Boolean {
			this._playerTimeOutLengthsIndex++;
			if(this._playerTimeOutLengthsIndex < this.PLAYER_TIMEOUT_LENGTHS.length) {
				log.debug("retry");
				this.tryGetPlayer();
				return true;
			}
			return false;
		}
		
		private function cleanBeforeLoad() : void {
			log.debug("clean before load");
			this.clearPlayerTimeout();
			this.clearPlayerLoader();
			this.clearPlayerUrlLoader();
			if(this._displayContainer) {
				log.debug("displayContainer.numChildren",this._displayContainer.numChildren);
				while(this._displayContainer.numChildren > 0) {
					this._displayContainer.removeChildAt(0);
				}
			}
		}
		
		public function destroy() : void {
			log.debug("destroy");
			this.removeAdPlayerEventListeners();
			this.clearPlayerTimeout();
			this.clearPlayerLoader();
			this.clearPlayerUrlLoader();
			this.clearBlackScreen();
			if(this._adManager) {
				this._adManager = null;
			}
			if(this._dispatcher) {
				this._dispatcher = null;
			}
			if(this._displayContainer) {
				while(this._displayContainer.numChildren > 0) {
					this._displayContainer.removeChildAt(0);
				}
				this._displayContainer = null;
			}
		}
		
		private function onAdPlayerFailure() : void {
			var _loc1_:Object = null;
			log.debug("dispatch adplayer loading failure event");
			if(this._dispatcher) {
				_loc1_ = {
					"tvId":this._tvId,
					"videoId":this._videoId
				};
				this._dispatcher.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.ADPLAYER_LOADING_FAILURE,_loc1_));
			}
		}
		
		private function onAdPlayerBlock() : void {
			var _loc1_:Object = null;
			log.debug("emit ad player block");
			if(this._dispatcher) {
				_loc1_ = {
					"tvId":this._tvId,
					"videoId":this._videoId
				};
				this._dispatcher.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.ADPLAYER_AD_BLOCK,_loc1_));
			}
		}
		
		private function generateEnv() : Dictionary {
			var _loc1_:Dictionary = new Dictionary();
			_loc1_.userId = this._uaaUserId;
			_loc1_.passportId = this._passportId;
			_loc1_.webEventId = this._webEventId;
			_loc1_.videoEventId = this._videoEventId;
			_loc1_.playerId = this._playerId;
			_loc1_.videoId = this._videoId;
			_loc1_.tvId = this._tvId;
			_loc1_.albumId = this._albumId;
			_loc1_.channelId = this._channelId;
			_loc1_.isPreload = false;
			_loc1_.adClientVersion = VERSION;
			_loc1_.adClientUrl = this._adClientUrl;
			_loc1_.videoClientVersion = this._videoClientVersion;
			_loc1_.videoClientUrl = this._videoClientUrl;
			_loc1_.uaaUserId = this._uaaUserId;
			_loc1_.videoEventId2 = this._videoEventId2;
			return _loc1_;
		}
		
		private function generateVideoEventId() : String {
			return MD5.hash(this._tvId + this._videoId + this._uaaUserId + new Date().time + getTimer() + Math.random());
		}
		
		private function calRequestCount() : int {
			return this._playerTimeOutLengthsIndex >= this.PLAYER_TIMEOUT_LENGTHS.length - 1?-1:this._playerTimeOutLengthsIndex + 1;
		}
		
		private function canShowBlackScreen() : Boolean {
			return (AdBlockedBlackScreen.CAN_SHOW) && this._vipRight == "0";
		}
		
		private function isQiyiWebEx() : Boolean {
			return this._terminal == "iqiyiwex";
		}
		
		private function isFullScreen() : Boolean {
			if(!this._displayContainer || !this._displayContainer.stage) {
				return false;
			}
			return this._displayContainer.stage.displayState == StageDisplayState.FULL_SCREEN;
		}
	}
}
