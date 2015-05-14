package com.qiyi.player.wonder.body.model
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import com.qiyi.player.base.logging.ILogger;
	import flash.external.ExternalInterface;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.adobe.serialization.json.JSON;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.core.model.IMovieInfo;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import com.qiyi.player.wonder.common.lso.LSO;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.base.logging.Log;
	import gs.TweenLite;
	
	public class JavascriptAPIProxy extends Proxy
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.body.model.JavascriptAPIProxy";
		
		private var _userProxy:UserProxy;
		
		private var _playerProxy:PlayerProxy;
		
		private var _log:ILogger;
		
		public function JavascriptAPIProxy()
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.body.model.JavascriptAPIProxy");
			super(NAME);
			try
			{
				ExternalInterface.addCallback("loadQiyiVideo",this.loadQiyiVideo);
				ExternalInterface.addCallback("pauseQiyiVideo",this.pauseQiyiVideo);
				ExternalInterface.addCallback("resumeQiyiVideo",this.resumeQiyiVideo);
				ExternalInterface.addCallback("initQiyiVideo",this.initQiyiVideo);
				ExternalInterface.addCallback("seekQiyiVideo",this.seekQiyiVideo);
				ExternalInterface.addCallback("replayQiyiVideo",this.replayQiyiVideo);
				ExternalInterface.addCallback("setCyclePlay",this.setCyclePlay);
				ExternalInterface.addCallback("setNextQiyiVideoInfo",this.setNextQiyiVideoInfo);
				ExternalInterface.addCallback("setContinuePlayState",this.setContinuePlayState);
				ExternalInterface.addCallback("switchVideo",this.switchVideo);
				ExternalInterface.addCallback("switchNextVideo",this.switchNextVideo);
				ExternalInterface.addCallback("switchPreVideo",this.switchPreVideo);
				ExternalInterface.addCallback("addVideoList",this.addVideoList);
				ExternalInterface.addCallback("removeVideoList",this.removeVideoList);
				ExternalInterface.addCallback("getQiyiPlayerInfo",this.getQiyiPlayerInfo);
				ExternalInterface.addCallback("getQiyiVideoInfo",this.getQiyiVideoInfo);
				ExternalInterface.addCallback("getIsInMainVideo",this.getIsInMainVideo);
				ExternalInterface.addCallback("getQiyuInfo",this.getQiyuInfo);
				ExternalInterface.addCallback("setQiyiUserLogin",this.setQiyiUserLogin);
				ExternalInterface.addCallback("setQiyiSubscribe",this.setQiyiSubscribe);
				ExternalInterface.addCallback("setQiyiVisits",this.setQiyiVisits);
				ExternalInterface.addCallback("setLight",this.setLight);
				ExternalInterface.addCallback("forceToSaveCurVideoInfo",this.forceToSaveCurVideoInfo);
				ExternalInterface.addCallback("expand",this.expand);
				ExternalInterface.addCallback("setBarrageStatus",this.setBarrageStatus);
				ExternalInterface.addCallback("setSelfSendBarrageInfo",this.setSelfSendBarrageInfo);
				ExternalInterface.addCallback("setSmallWindowMode",this.setSmallWindowMode);
				ExternalInterface.addCallback("setBarrageSetting",this.setBarrageSetting);
				ExternalInterface.addCallback("getCaptureURL",this.getCaptureURL);
				ExternalInterface.addCallback("setActivityNoticeInfo",this.setActivityNoticeInfo);
				TweenLite.delayedCall(2,this.callJsPlayerLoadSuccess);
			}
			catch(error:Error)
			{
				_log.warn("JavascriptAPIProxy add call back error!");
			}
		}
		
		public function injectUserProxy(param1:UserProxy) : void
		{
			this._userProxy = param1;
		}
		
		public function injectPlayerProxy(param1:PlayerProxy) : void
		{
			this._playerProxy = param1;
		}
		
		private function unitTest() : void
		{
		}
		
		public function checkClientInstall() : Boolean
		{
			try
			{
				return ExternalInterface.call("lib.swf.checkClientInstall");
			}
			catch(error:Error)
			{
			}
			return false;
		}
		
		public function callJsPlayNextVideo() : void
		{
			this._log.debug("call js callJsPlayNextVideo");
			var dataProvider:Object = new Object();
			dataProvider.type = "playNextVideo";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsPlayPreVideo() : void
		{
		}
		
		public function callJsSetLight(param1:Boolean) : void
		{
			var var_6:Boolean = param1;
			this._log.debug("call js callJsSetLight");
			var dataProvider:Object = new Object();
			dataProvider.type = "setLight";
			var dataValue:Object = new Object();
			dataValue.open = var_6.toString();
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
			sendNotification(BodyDef.NOTIFIC_JS_LIGHT_CHANGED,var_6);
		}
		
		public function callJsLoadComplete() : void
		{
			this._log.debug("call js callJsLoadComplete");
			var dataProvider:Object = new Object();
			dataProvider.type = "loadComplete";
			var dataValue:Object = new Object();
			dataValue.complete = "true";
			if(this._playerProxy.curActor.movieModel)
			{
				dataValue.tvid = this._playerProxy.curActor.movieModel.tvid;
			}
			else
			{
				dataValue.tvid = "";
			}
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsDownload() : void
		{
			this._log.debug("call js callJsDownload");
			var movieModel:IMovieModel = this._playerProxy.curActor.movieModel;
			var movieInfo:IMovieInfo = this._playerProxy.curActor.movieInfo;
			var dataProvider:Object = new Object();
			dataProvider.type = "download";
			var dataValue:Object = new Object();
			dataValue.albumId = movieModel?movieModel.albumId:"";
			dataValue.videoName = movieInfo?movieInfo.title?movieInfo.title.replace(new RegExp("\\\"","g"),"\'"):"":"";
			dataValue.isCharge = movieModel?movieModel.member.toString():"false";
			dataValue.tvid = movieModel?movieModel.tvid:"";
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsPlayerStateChange(param1:String, param2:String = "", param3:String = "") : void
		{
			var var_7:String = param1;
			var var_8:String = param2;
			var var_9:String = param3;
			this._log.info("call js callJsPlayerStateChange(" + var_7 + "), tvid: " + var_8);
			var dataProvider:Object = new Object();
			dataProvider.type = "playerStateChange";
			var dataValue:Object = new Object();
			dataValue.tvid = var_8;
			dataValue.vid = var_9;
			dataValue.state = var_7;
			if((this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) && (this._playerProxy.curActor.errorCode == 708 || this._playerProxy.curActor.errorCode == 709))
			{
				dataValue.privateVideo = "1";
			}
			else
			{
				dataValue.privateVideo = "0";
			}
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
				_log.info("call js callJsPlayerStateChange error!");
			}
		}
		
		public function callJsExpand(param1:Boolean) : void
		{
			var var_10:Boolean = param1;
			this._log.debug("call js callJsExpand");
			var dataProvider:Object = new Object();
			dataProvider.type = "expand";
			var dataValue:Object = new Object();
			dataValue.value = var_10.toString();
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
			sendNotification(BodyDef.NOTIFIC_JS_EXPAND_CHANGED,var_10);
		}
		
		public function callJsRecharge(param1:String, param2:int = 0) : void
		{
			var var_11:String = param1;
			var var_12:int = param2;
			this._log.debug("call js callJsRecharge,code:" + var_11 + ",from:" + var_12);
			var dataProvider:Object = new Object();
			dataProvider.type = "recharge";
			var dataValue:Object = new Object();
			dataValue.code = var_11;
			dataValue.from = var_12;
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsAuthenticationResult(param1:Boolean) : void
		{
			var var_13:Boolean = param1;
			this._log.debug("call js callJsAuthenticationResult,isTryWatch:" + var_13);
			var dataProvider:Object = new Object();
			dataProvider.type = "authenticationResult";
			var dataValue:Object = new Object();
			dataValue.isTryWatch = var_13.toString();
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsRequestVideoList(param1:Boolean) : void
		{
			var var_14:Boolean = param1;
			this._log.debug("call js callJsRequestVideoList,isBefore:" + var_14);
			var dataProvider:Object = new Object();
			dataProvider.type = "requestVideoList";
			var dataValue:Object = new Object();
			dataValue.around = var_14?"0":"1";
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
				_log.debug("call js callJsRequestVideoList error");
			}
		}
		
		public function callJsSwitchFullScreen(param1:Boolean) : void
		{
			var var_15:Boolean = param1;
			this._log.debug("call js callJsSwitchFullScreen " + var_15);
			var dataProvider:Object = new Object();
			dataProvider.type = "switchFullScreen";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.value = var_15.toString();
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsRequestJSSendPB(param1:int) : void
		{
			var var_16:int = param1;
			this._log.debug("call js callJsRequestJSSendPB " + var_16);
			var dataProvider:Object = new Object();
			dataProvider.type = "requestJSSendPB";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.PBType = var_16.toString();
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsShowLoginPanel(param1:String) : void
		{
			var var_17:String = param1;
			this._log.debug("call js callJsShowLoginPanel, source:" + var_17);
			var dataProvider:Object = new Object();
			dataProvider.type = "showLoginPanel";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.source = var_17;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsFocusTips(param1:int) : void
		{
			var var_2:int = param1;
			this._log.debug("call js callJsFocusTips,time:" + var_2);
			var dataProvider:Object = new Object();
			dataProvider.type = "focusTips";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.time = var_2;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("Q.__callbacks__.iqiyi_player_notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsRefreshPage() : void
		{
			this._log.debug("call js callJsRefreshPage");
			var dataProvider:Object = new Object();
			dataProvider.type = "refreshPage";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsFindGoods(param1:int) : void
		{
			var var_2:int = param1;
			this._log.debug("call js callJsFindGoods,time:" + var_2);
			var dataProvider:Object = new Object();
			dataProvider.type = "findGoods";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.time = var_2;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsBarrageReply(param1:String, param2:String) : void
		{
			var var_18:String = param1;
			var var_19:String = param2;
			this._log.debug("call js callJsBarrageReply,$uid:" + var_18 + ", $name" + var_19);
			var dataProvider:Object = new Object();
			dataProvider.type = "barrageReply";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.uid = var_18;
			dataValue.name = var_19;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsSetBarrageInteractInfo(param1:Object, param2:Boolean) : void
		{
			var var_20:Object = param1;
			var var_21:Boolean = param2;
			this._log.debug("call js callJsSetBarrageInteractInfo isConnected=" + var_21);
			var dataProvider:Object = new Object();
			dataProvider.type = "setBarrageInteractInfo";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.interactInfo = var_20;
			dataValue.isConnected = var_21?"1":"0";
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsBarrageReceiveData(param1:Array) : void
		{
			var var_22:Array = param1;
			this._log.debug("call js callJsBarrageReceiveData");
			var dataProvider:Object = new Object();
			dataProvider.type = "barrageReceiveData";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.barrageData = var_22;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		public function callJsDoSomething(param1:String) : void
		{
			var var_23:String = param1;
			this._log.debug("call js setJsDoSomething : " + var_23);
			var dataProvider:Object = new Object();
			dataProvider.type = "setJsDoSomething";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataValue.handleType = var_23;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
		}
		
		private function callJsPlayerLoadSuccess() : void
		{
			this._log.debug("call js callJsPlayerLoadSuccess");
			var dataProvider:Object = new Object();
			dataProvider.type = "playerLoadSuccess";
			var dataValue:Object = new Object();
			dataValue.origin = FlashVarConfig.origin;
			dataProvider.data = dataValue;
			try
			{
				ExternalInterface.call("lib.swf.notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
			try
			{
				ExternalInterface.call("Q.__callbacks__.iqiyi_player_notice",com.adobe.serialization.json.JSON.encode(dataProvider));
			}
			catch(error:Error)
			{
			}
			this.unitTest();
		}
		
		private function loadQiyiVideo(param1:String) : void
		{
			var obj:Object = null;
			var var_24:String = param1;
			if(this._playerProxy.invalid)
			{
				return;
			}
			try
			{
				this._log.info("js call loadQiyiVideo");
				ProcessesTimeRecord.needRecord = false;
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO,obj);
			}
			catch(error:Error)
			{
				_log.info("js call loadQiyiVideo error");
			}
		}
		
		private function pauseQiyiVideo() : void
		{
			this._log.debug("js call pauseQiyiVideo!");
			sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
			sendNotification(BodyDef.NOTIFIC_JS_CALL_PAUSE);
		}
		
		private function initQiyiVideo() : void
		{
			this._log.debug("js call initQiyiVideo!");
			if(!this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
			{
				sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
			}
		}
		
		private function resumeQiyiVideo() : void
		{
			this._log.debug("js call resumeQiyiVideo!");
			if(!FlashVarConfig.autoPlay && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
			{
				sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
			}
			else
			{
				sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_RESUME);
			}
		}
		
		private function seekQiyiVideo(param1:String) : void
		{
			this._log.debug("js call seek:" + param1);
			var _loc2:int = int(param1);
			sendNotification(BodyDef.NOTIFIC_JS_CALL_SEEK,_loc2 * 1000);
		}
		
		private function replayQiyiVideo() : void
		{
			this._log.debug("js call replay");
			sendNotification(BodyDef.NOTIFIC_JS_CALL_REPLAY);
		}
		
		private function setCyclePlay(param1:String) : void
		{
			this._log.info("js call setCyclePlay:" + param1);
			var _loc2:* = param1 == "true";
			sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_CYCLE_PLAY,_loc2);
		}
		
		private function setNextQiyiVideoInfo(param1:String) : void
		{
			var obj:Object = null;
			var continuePlay:Boolean = false;
			var nextVideoTitle:String = null;
			var var_24:String = param1;
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				continuePlay = obj.continuePlay == "true";
				nextVideoTitle = obj.nextVideoTitle;
				this._log.debug("js  setNextQiyiVideoInfo:" + continuePlay + ",nextVideoTitle:" + nextVideoTitle);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO,{
					"continuePlay":continuePlay,
					"nextVideoTitle":nextVideoTitle
				});
			}
			catch(error:Error)
			{
			}
		}
		
		private function setContinuePlayState(param1:String) : void
		{
			var continuePlay:Boolean = false;
			var var_24:String = param1;
			try
			{
				continuePlay = var_24 == "true";
				this._log.debug("js  setContinuePlayState:" + continuePlay);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE,continuePlay);
			}
			catch(error:Error)
			{
			}
		}
		
		private function switchVideo(param1:String) : void
		{
			var obj:Object = null;
			var var_24:String = param1;
			if(this._playerProxy.invalid)
			{
				return;
			}
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				this._log.debug("js  switchVideo tvid:" + obj.tvid + " vid:" + obj.vid);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SWITCH_VIDEO,obj);
			}
			catch(error:Error)
			{
			}
		}
		
		private function switchNextVideo() : void
		{
			if(this._playerProxy.invalid)
			{
				return;
			}
			this._log.debug("js switchNextVideo");
			sendNotification(BodyDef.NOTIFIC_JS_CALL_SWITCH_NEXT_VIDEO);
		}
		
		private function switchPreVideo() : void
		{
			if(this._playerProxy.invalid)
			{
				return;
			}
			this._log.debug("js switchPreVideo");
			sendNotification(BodyDef.NOTIFIC_JS_CALL_SWITCH_PRE_VIDEO);
		}
		
		private function addVideoList(param1:String) : void
		{
			var obj:Object = null;
			var var_24:String = param1;
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				this._log.info("js addVideoList taid = " + obj.taid + " tcid = " + obj.tcid);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_ADD_VIDEO_LIST,obj);
			}
			catch(error:Error)
			{
			}
		}
		
		private function removeVideoList(param1:String) : void
		{
			var obj:Object = null;
			var var_24:String = param1;
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				this._log.info("js removeVideoList tvid:" + obj.tvid + " vid:" + obj.vid);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_REMOVE_FROM_LIST,obj);
			}
			catch(error:Error)
			{
			}
		}
		
		private function getQiyiPlayerInfo() : String
		{
			var movieModel:IMovieModel = null;
			var movieInfo:IMovieInfo = null;
			var info:Object = new Object();
			try
			{
				movieModel = this._playerProxy.curActor.movieModel;
				movieInfo = this._playerProxy.curActor.movieInfo;
				info.vid = movieModel.vid;
				info.tvid = movieModel.tvid;
				info.totalDuration = movieModel.duration;
				info.currentTime = this._playerProxy.curActor.currentTime;
				info.currentDefination = movieModel.curDefinitionInfo.type.id.toString();
				info.currentTrack = movieModel.curAudioTrackInfo.type.id.toString();
				info.uuid = this._playerProxy.curActor.uuid;
				info.categoryId = movieModel.channelID.toString();
				info.loadComplete = this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE)?"1":"0";
				info.isTryWatch = this._playerProxy.curActor.isTryWatch?"1":"0";
				info.width = movieModel.width;
				info.height = movieModel.height;
				info.hasBarrage = movieInfo?movieInfo.putBarrage?"1":"0":"1";
				this._log.debug("js get getQiyiPlayerInfo time :" + info.currentTime + "/" + info.totalDuration + ",loadComplete:" + info.loadComplete);
			}
			catch(error:Error)
			{
			}
			return com.adobe.serialization.json.JSON.encode(info);
		}
		
		private function getQiyiVideoInfo() : String
		{
			this._log.info("js call getQiyiVideoInfo");
			var _loc1:* = "";
			if(this._playerProxy.curActor.movieInfo)
			{
				return this._playerProxy.curActor.movieInfo.info;
			}
			return "";
		}
		
		private function getIsInMainVideo() : String
		{
			this._log.info("js call getIsInMainVideo");
			if((this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY)) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
			{
				return "1";
			}
			return "0";
		}
		
		private function getQiyuInfo() : String
		{
			this._log.info("js call getQiyuInfo");
			var _loc1:* = "";
			return com.adobe.serialization.json.JSON.encode(_loc1);
		}
		
		private function setQiyiUserLogin(param1:String) : void
		{
			var obj:Object = null;
			var totalBonus:uint = 0;
			var var_24:String = param1;
			this._log.debug("js call setQiyiUserLogin: " + var_24);
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				if(this._userProxy)
				{
					this._userProxy.isLogin = obj.login == "true";
					this._userProxy.passportID = obj.passportId?obj.passportId:"";
					this._userProxy.P00001 = obj.P00001?obj.P00001:"";
					this._userProxy.profileID = obj.profileID?obj.profileID:this._userProxy.passportID;
					this._userProxy.profileCookie = obj.profileCookie?obj.profileCookie:"";
					if((this._userProxy.isLogin) && FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
					{
						totalBonus = LSO.getInstance().takeOutTotalBonus();
						if(totalBonus != 0)
						{
							this._userProxy.saveTotalBonus(totalBonus,this._playerProxy.curActor.uuid);
						}
					}
					if(obj.source)
					{
						sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_LOGIN_SOURCE,obj.source);
					}
					this._log.debug("js call setQiyiUserLogin send notific!");
					sendNotification(BodyDef.NOTIFIC_CHECK_USER);
				}
			}
			catch(error:Error)
			{
			}
		}
		
		private function setQiyiSubscribe(param1:String) : void
		{
			var obj:Object = null;
			var canSubscribe:Boolean = false;
			var tvName:String = null;
			var var_24:String = param1;
			this._log.debug("js call setQiyiSubscribe");
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				canSubscribe = obj.canSubscribe == "true";
				tvName = obj.tvName;
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SUBSCRIBE,{
					"canSubscribe":canSubscribe,
					"tvName":tvName
				});
			}
			catch(error:Error)
			{
			}
		}
		
		private function setQiyiVisits(param1:String) : void
		{
			this._log.debug("js call setQiyiVisits:" + param1);
			this._playerProxy.curActor.visits = param1;
			this._playerProxy.preActor.visits = param1;
			PingBack.getInstance().visits = param1;
		}
		
		private function setLight(param1:String) : void
		{
			this._log.debug("js call setLight:" + param1);
			var _loc2:* = param1 == "true";
			sendNotification(BodyDef.NOTIFIC_JS_LIGHT_CHANGED,_loc2);
		}
		
		private function forceToSaveCurVideoInfo(param1:String = "") : void
		{
			var ifs:Array = null;
			var i:int = 0;
			var var_24:String = param1;
			this._log.debug("js call forceToSaveCurVideoInfo");
			var infos:Array = [];
			var movieModel:IMovieModel = this._playerProxy.curActor.movieModel;
			if(var_24 == "")
			{
				if(movieModel)
				{
					infos = [{
						"tvid":movieModel.tvid,
						"vid":movieModel.vid,
						"curtime":this._playerProxy.curActor.currentTime.toString(),
						"albumid":movieModel.albumId.toString(),
						"definition":movieModel.curDefinitionInfo.type.id.toString(),
						"member":movieModel.member.toString()
					}];
				}
			}
			else
			{
				try
				{
					ifs = com.adobe.serialization.json.JSON.decode(var_24);
					if((ifs) && (ifs.length))
					{
						i = 0;
						while(i < ifs.length)
						{
							infos.push({
								"tvid":ifs[i].tvid,
								"vid":ifs[i].vid,
								"curtime":"0",
								"albumid":ifs[i].albumid,
								"definition":(movieModel?movieModel.curDefinitionInfo.type.id.toString():""),
								"member":ifs[i].member
							});
							i++;
						}
					}
				}
				catch(e:Error)
				{
				}
			}
			if(var_24 == "")
			{
				LSO.getInstance().setClientFlashInfo(infos);
				return;
			}
			LSO.getInstance().setClientFlashInfo(infos);
		}
		
		private function expand(param1:String) : void
		{
			this._log.debug("js call expand:" + param1);
			var _loc2:* = param1 == "true";
			sendNotification(BodyDef.NOTIFIC_JS_EXPAND_CHANGED,_loc2);
		}
		
		private function setBarrageStatus(param1:String) : void
		{
			var obj:Object = null;
			var var_24:String = param1;
			this._log.debug("js call setBarrageStatus:" + var_24);
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS,obj);
			}
			catch(error:Error)
			{
			}
		}
		
		private function setSelfSendBarrageInfo(param1:String) : void
		{
			var obj:Object = null;
			var var_24:String = param1;
			this._log.debug("js call setSelfSendBarrageInfo:" + var_24);
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO,obj);
			}
			catch(error:Error)
			{
			}
		}
		
		private function setSmallWindowMode(param1:String) : void
		{
			var isSmallWindowMode:Boolean = false;
			var var_24:String = param1;
			this._log.debug("js call setSmallWindowMode:" + var_24);
			try
			{
				isSmallWindowMode = var_24 == "1";
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,isSmallWindowMode);
			}
			catch(error:Error)
			{
			}
		}
		
		private function setBarrageSetting(param1:String) : void
		{
			var obj:Object = null;
			var var_24:String = param1;
			this._log.debug("js call setBarrageSetting:" + var_24);
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_SETTING,obj);
			}
			catch(error:Error)
			{
			}
		}
		
		private function getCaptureURL(param1:String) : String
		{
			var obj:Object = null;
			var time:Number = NaN;
			var mode:int = 0;
			var var_24:String = param1;
			this._log.debug("js call getCaptureURL:" + var_24);
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				time = -1;
				mode = 1;
				if(obj.time != undefined)
				{
					time = Number(obj.time);
				}
				if(obj.mode != undefined)
				{
					mode = int(obj.mode);
				}
				return this._playerProxy.curActor.getCaptureURL(time,mode);
			}
			catch(error:Error)
			{
			}
			return "";
		}
		
		private function setActivityNoticeInfo(param1:String) : void
		{
			var obj:Object = null;
			var var_24:String = param1;
			this._log.debug("js call setActivityNoticeInfo:" + var_24);
			try
			{
				obj = com.adobe.serialization.json.JSON.decode(var_24);
				sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO,obj);
			}
			catch(error:Error)
			{
			}
		}
	}
}
