package com.qiyi.player.wonder.plugins.ad.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.base.logging.ILogger;
	import com.iqiyi.components.global.GlobalStage;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import flash.utils.getTimer;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.cupid.adplayer.base.CupidParam;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.base.uuid.UUIDManager;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.base.utils.KeyUtils;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.base.utils.UGCUtils;
	import com.qiyi.player.core.model.impls.pub.Statistics;
	import com.qiyi.player.wonder.WonderVersion;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.tips.TipsDef;
	import flash.events.Event;
	import com.qiyi.player.core.player.def.PauseTypeEnum;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinueInfo;
	import flash.external.ExternalInterface;
	import gs.TweenLite;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.core.model.def.ScreenEnum;
	import com.qiyi.player.base.logging.Log;
	
	public class ADViewMediator extends Mediator {
		
		public function ADViewMediator(param1:ADView) {
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.ad.view.ADViewMediator");
			super(NAME,param1);
			this._ADView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.ad.view.ADViewMediator";
		
		private var _ADProxy:ADProxy;
		
		private var _ADView:ADView;
		
		private var _log:ILogger;
		
		override public function onRegister() : void {
			super.onRegister();
			this._ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			this._ADView.addEventListener(ADEvent.Evt_Open,this.onADViewOpen);
			this._ADView.addEventListener(ADEvent.Evt_Close,this.onADViewClose);
			this._ADView.addEventListener(ADEvent.Evt_LoadSuccess,this.onLoadSuccess);
			this._ADView.addEventListener(ADEvent.Evt_LoadFailed,this.onLoadFailed);
			this._ADView.addEventListener(ADEvent.Evt_StartPlay,this.onStartPlay);
			this._ADView.addEventListener(ADEvent.Evt_AskVideoPause,this.onAskVideoPause);
			this._ADView.addEventListener(ADEvent.Evt_AskVideoResume,this.onAskVideoResume);
			this._ADView.addEventListener(ADEvent.Evt_AskVideoStartLoad,this.onAskVideoStartLoad);
			this._ADView.addEventListener(ADEvent.Evt_AskVideoStartPlay,this.onAskVideoStartPlay);
			this._ADView.addEventListener(ADEvent.Evt_AskVideoEnd,this.onAskVideoEnd);
			this._ADView.addEventListener(ADEvent.Evt_AdBlock,this.onAdBlock);
			this._ADView.addEventListener(ADEvent.Evt_AdUnloaded,this.onAdUnloaded);
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
		}
		
		override public function listNotificationInterests() : Array {
			return [ADDef.NOTIFIC_ADD_STATUS,ADDef.NOTIFIC_REMOVE_STATUS,ADDef.NOTIFIC_PAUSE,ADDef.NOTIFIC_RESUME,ADDef.NOTIFIC_POPUP_OPEN,ADDef.NOTIFIC_POPUP_CLOSE,ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO,ADDef.NOTIFIC_AD_VOLUMN_CHANGED,ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER,ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED,ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED,BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_JS_LIGHT_CHANGED,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE,BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO,BodyDef.NOTIFIC_MOUSE_LAYER_CLICK,BodyDef.NOTIFIC_JS_CALL_PAUSE,BodyDef.NOTIFIC_JS_CALL_RESUME,BodyDef.NOTIFIC_JS_CALL_REPLAY,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc5_:Object = null;
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case ADDef.NOTIFIC_ADD_STATUS:
					this._ADView.onAddStatus(int(_loc2_));
					break;
				case ADDef.NOTIFIC_REMOVE_STATUS:
					this._ADView.onRemoveStatus(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_JS_CALL_PAUSE:
				case ADDef.NOTIFIC_PAUSE:
					if(!this.checkSkipPauseAD()) {
						PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
					}
					if(this._ADProxy.hasStatus(ADDef.STATUS_PLAYING)) {
						this._ADProxy.addStatus(ADDef.STATUS_PAUSED);
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_AD_PAUSED);
					}
					this._ADView.onPause();
					break;
				case BodyDef.NOTIFIC_JS_CALL_RESUME:
				case ADDef.NOTIFIC_RESUME:
					if(this._ADProxy.hasStatus(ADDef.STATUS_PAUSED)) {
						this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_AD_RESUMED);
					}
					this._ADView.onResume();
					break;
				case ADDef.NOTIFIC_POPUP_OPEN:
					this._ADView.onPopupOpen();
					break;
				case ADDef.NOTIFIC_POPUP_CLOSE:
					this._ADView.onPopupClose();
					break;
				case ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO:
					this.onRequestReplayVideo(_loc2_);
					break;
				case ADDef.NOTIFIC_AD_VOLUMN_CHANGED:
					this.onVolumeChanged();
					break;
				case ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID:
					this._ADProxy.cupId = _loc2_ as String;
					break;
				case ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER:
					this.unloadAdPlayer();
					this.removeAllAdStatus();
					break;
				case ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED:
					this.onContinueListChanged();
					break;
				case ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED:
					this.onNoticePrepareSwitchVideo(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._ADView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),false,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2_.currentTime,_loc2_.bufferTime,_loc2_.duration);
					break;
				case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
					this._ADView.onLightStateChanged(Boolean(_loc2_));
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					this._ADView.onFullScreenChanged(Boolean(_loc2_));
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:
					this.onJSCallSetContinuePlayState(Boolean(_loc2_));
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:
					_loc5_ = new Object();
					_loc5_.hasNext = Boolean(_loc2_.continuePlay)?"1":"0";
					this._ADView.onSendNotific(_loc5_);
					break;
				case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerDefinitionSwitched(int(_loc2_));
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this.onPlayerSwitchPreActor();
					break;
				case BodyDef.NOTIFIC_MOUSE_LAYER_CLICK:
					this.onMouseLayerClick();
					break;
				case BodyDef.NOTIFIC_JS_CALL_REPLAY:
					this.onRequestReplayVideo();
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					if(Boolean(_loc2_)) {
						this.hideDock();
					}
					break;
			}
		}
		
		private function onPlayerDefinitionSwitched(param1:int) : void {
			var _loc2_:PlayerProxy = null;
			var _loc3_:Object = null;
			if(param1 >= 0) {
				_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3_ = new Object();
				_loc3_.videoDefinitionId = _loc2_.curActor.movieModel.curDefinitionInfo.type.id;
				this._ADView.onSendNotific(_loc3_);
			}
		}
		
		private function onNoticePrepareSwitchVideo(param1:int) : void {
			this._ADProxy.switchVideoType = param1;
			if(param1 != ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO) {
				this._ADProxy.curAdContextPlayDuration = 0;
				this._ADProxy.curAdContext15PlayDuration = 0;
				this._ADProxy.curPlayCount = 0;
				this._ADProxy.preAdContextPlayDuration = 0;
				this._ADProxy.preAdContext15PlayDuration = 0;
				this._ADProxy.prePlayCount = 0;
				this.unloadAdPlayer();
				this.removeAllAdStatus();
			}
		}
		
		private function onContinueListChanged() : void {
			var _loc2_:ContinuePlayProxy = null;
			var _loc3_:String = null;
			var _loc4_:String = null;
			var _loc5_:Object = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.loadMovieParams) {
				_loc2_ = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
				_loc3_ = _loc1_.curActor.loadMovieParams.vid;
				_loc4_ = _loc1_.curActor.loadMovieParams.tvid;
				_loc5_ = new Object();
				if(_loc2_.continueInfoCount > 0 && (_loc2_.isContinue) && (_loc2_.findNextContinueInfo(_loc4_,_loc3_))) {
					_loc5_.hasNext = "1";
				} else {
					_loc5_.hasNext = "0";
				}
				this._ADView.onSendNotific(_loc5_);
			}
		}
		
		private function onJSCallSetContinuePlayState(param1:Boolean) : void {
			var _loc4_:String = null;
			var _loc5_:String = null;
			var _loc6_:ContinuePlayProxy = null;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:Object = new Object();
			if((_loc2_.curActor.loadMovieParams) && (param1)) {
				_loc4_ = _loc2_.curActor.loadMovieParams.tvid;
				_loc5_ = _loc2_.curActor.loadMovieParams.vid;
				_loc6_ = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
				if(_loc6_.continueInfoCount > 0 && (_loc6_.findNextContinueInfo(_loc4_,_loc5_))) {
					_loc3_.hasNext = "1";
				} else {
					_loc3_.hasNext = "0";
				}
			} else {
				_loc3_.hasNext = "0";
			}
			this._ADView.onSendNotific(_loc3_);
		}
		
		private function createADPlayer() : void {
			sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
			ProcessesTimeRecord.STime_adInit = getTimer();
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc3_:CupidParam = new CupidParam();
			_loc3_.playerUrl = FlashVarConfig.adPlayerURL;
			_loc3_.videoId = _loc1_.curActor.loadMovieParams.vid;
			_loc3_.tvId = _loc1_.curActor.loadMovieParams.tvid;
			_loc3_.channelId = _loc1_.curActor.movieModel.channelID;
			_loc3_.playerId = FlashVarConfig.cupId;
			_loc3_.albumId = _loc1_.curActor.movieModel.albumId;
			_loc3_.dispatcher = null;
			_loc3_.adContainer = this._ADView;
			_loc3_.stageWidth = GlobalStage.stage.stageWidth;
			_loc3_.stageHeight = GlobalStage.stage.stageHeight;
			_loc3_.userId = _loc1_.curActor.uuid;
			_loc3_.webEventId = UUIDManager.instance.getWebEventID();
			_loc3_.videoEventId = UUIDManager.instance.getVideoEventID();
			_loc3_.vipRight = _loc2_.userLevel != UserDef.USER_LEVEL_NORMAL?"1":"0";
			_loc3_.terminal = "iqiyiw";
			_loc3_.duration = _loc1_.curActor.movieModel.duration / 1000;
			_loc3_.passportId = _loc2_.passportID;
			_loc3_.passportCookie = _loc2_.P00001;
			_loc3_.passportKey = KeyUtils.getPassportKey(0);
			_loc3_.enableVideoCore = false;
			_loc3_.disableSkipAd = _loc1_.curActor.movieModel.forceAD;
			_loc3_.volume = Settings.instance.mute?0:Settings.instance.volumn;
			_loc3_.isUGC = UGCUtils.isUGC(_loc1_.curActor.movieModel.tvid);
			_loc3_.collectionId = FlashVarConfig.collectionID;
			_loc3_.videoDefinitionId = _loc1_.curActor.movieModel.curDefinitionInfo.type.id;
			_loc3_.cacheMachineIp = _loc1_.curActor.VInfoDisIP;
			_loc3_.couponCode = FlashVarConfig.couponCode;
			_loc3_.couponVer = FlashVarConfig.couponVer;
			_loc3_.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
			_loc3_.videoPlayerVersion = WonderVersion.VERSION_WONDER;
			this._ADView.createAdPlayer(_loc3_);
		}
		
		private function unloadAdPlayer() : void {
			this._ADView.unloadAdPlayer();
			this._ADProxy.blocked = false;
		}
		
		private function removeAllAdStatus() : void {
			this._ADProxy.removeStatus(ADDef.STATUS_PLAY_END,false);
			this._ADProxy.removeStatus(ADDef.STATUS_LOADING,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PLAYING,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PAUSED,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PRE_LOADING,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PRE_SUCCESS,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PRE_FAILED,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PRE_STARTED,false);
		}
		
		private function onADViewOpen(param1:ADEvent) : void {
			if(!this._ADProxy.hasStatus(ADDef.STATUS_OPEN)) {
				this._ADProxy.addStatus(ADDef.STATUS_OPEN);
			}
		}
		
		private function onADViewClose(param1:ADEvent) : void {
			if(this._ADProxy.hasStatus(ADDef.STATUS_OPEN)) {
				this._ADProxy.removeStatus(ADDef.STATUS_OPEN);
			}
		}
		
		private function onRequestReplayVideo(param1:Object = null) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED)) {
				sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAY);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
				if(param1) {
					sendNotification(BodyDef.NOTIFIC_PLAYER_SEEK,{"time":param1});
				}
			}
		}
		
		private function onCheckUserComplete() : void {
			var _loc1_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2_:UserInfoVO = new UserInfoVO();
			_loc2_.isLogin = _loc1_.isLogin;
			_loc2_.passportID = _loc1_.passportID;
			_loc2_.userID = _loc1_.userID;
			_loc2_.userName = _loc1_.userName;
			_loc2_.userLevel = _loc1_.userLevel;
			_loc2_.userType = _loc1_.userType;
			this._ADView.onUserInfoChanged(_loc2_);
			var _loc3_:Object = new Object();
			_loc3_.vipRight = _loc1_.userLevel != UserDef.USER_LEVEL_NORMAL?"1":"0";
			if(_loc1_.isLogin) {
				_loc3_.passportId = _loc1_.passportID;
				_loc3_.passportCookie = _loc1_.P00001;
			} else {
				_loc3_.passportId = "";
				_loc3_.passportCookie = "";
			}
			this._ADView.onSendNotific(_loc3_);
		}
		
		private function checkSkipTitleAD() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((_loc1_.curActor.isPlayRefreshed) || (_loc1_.curActor.movieModel.member) || _loc1_.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || _loc1_.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D) {
				return true;
			}
			return false;
		}
		
		private function checkSkipTitlePreAD() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.preActor.movieModel.member) {
				return true;
			}
			return false;
		}
		
		private function checkSkipTrailerAD() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if((_loc1_.curActor.movieModel.member) || (this._ADProxy.hasStatus(ADDef.STATUS_APPEARS)) && (_loc2_.isLogin) && !(_loc2_.userLevel == UserDef.USER_LEVEL_NORMAL) && !_loc1_.curActor.movieModel.forceAD || _loc1_.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || _loc1_.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D) {
				return true;
			}
			return false;
		}
		
		private function checkSkipPauseAD() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if(_loc1_.curActor.movieModel == null || (_loc1_.curActor.movieModel.member) || (_loc2_.isLogin) && !(_loc2_.userLevel == UserDef.USER_LEVEL_NORMAL) && !_loc1_.curActor.movieModel.forceAD || _loc1_.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || _loc1_.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D) {
				return true;
			}
			return false;
		}
		
		private function showSkipADTip() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if((_loc2_.isLogin) && !(_loc2_.userLevel == UserDef.USER_LEVEL_NORMAL) && !_loc1_.curActor.movieModel.member && !_loc1_.curActor.movieModel.forceAD) {
				sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_PRO_SKIP_AD);
			}
		}
		
		private function showCopyrightForceADTip() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if((_loc2_.isLogin) && !(_loc2_.userLevel == UserDef.USER_LEVEL_NORMAL) && !_loc1_.curActor.movieModel.member && (_loc1_.curActor.movieModel.forceAD)) {
				sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_COPYRIGHT_FORCE_AD_TIP);
			}
		}
		
		private function onPlayerSwitchPreActor() : void {
			var _loc2_:* = false;
			var _loc3_:* = false;
			var _loc4_:* = false;
			this.hideDock();
			this._ADProxy.clearADViewPoints();
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) {
				this.unloadAdPlayer();
				this.removeAllAdStatus();
			} else if((_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
				_loc2_ = this.checkSkipTitleAD();
				if(_loc2_) {
					this.unloadAdPlayer();
					this.removeAllAdStatus();
					sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
					this.trySendSkipADPingBack();
				} else if(this._ADProxy.hasStatus(ADDef.STATUS_PRE_FAILED)) {
					this.unloadAdPlayer();
					this.removeAllAdStatus();
					this._ADProxy.addStatus(ADDef.STATUS_LOADING);
					this.createADPlayer();
				} else {
					_loc3_ = this._ADProxy.hasStatus(ADDef.STATUS_PRE_LOADING);
					_loc4_ = this._ADProxy.hasStatus(ADDef.STATUS_PRE_SUCCESS);
					this.removeAllAdStatus();
					if((this._ADView.adPlayer) && ((_loc3_) || (_loc4_))) {
						if(!_loc4_) {
							sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
							this._ADProxy.addStatus(ADDef.STATUS_LOADING);
						}
						this._log.info("ad switch pre on player switch pre!");
						this._ADView.onSwitchPre();
					} else {
						this._ADProxy.addStatus(ADDef.STATUS_LOADING);
						this.createADPlayer();
					}
				}
				
				this.showSkipADTip();
			}
			
			this._ADProxy.mute = Settings.instance.mute;
		}
		
		private function onMouseLayerClick() : void {
			var _loc1_:PlayerProxy = null;
			if(!this._ADProxy.hasStatus(ADDef.STATUS_LOADING) && !this._ADProxy.hasStatus(ADDef.STATUS_PLAYING) && !this._ADProxy.hasStatus(ADDef.STATUS_PAUSED)) {
				_loc1_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)) {
					sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
					this._ADView.onResume();
					GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
				} else {
					if(!this.checkSkipPauseAD()) {
						PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
					}
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE,PauseTypeEnum.USER);
					this._ADView.onPause();
					GlobalStage.stage.dispatchEvent(new Event("tmp_dis_pause_to_p2p"));
				}
			}
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int) : void {
			this._ADView.onUpdateCurrentTime(param1);
			var _loc4_:Object = new Object();
			_loc4_.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
			this._ADView.onSendNotific(_loc4_);
			this.executeTryADPre();
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			var _loc4_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc5_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						if(param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
							this._ADProxy.clearADViewPoints();
							this.hideDock();
							this.unloadAdPlayer();
							this.removeAllAdStatus();
						} else if(param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE) {
							this._ADProxy.removeStatus(ADDef.STATUS_PRE_LOADING,false);
							this._ADProxy.removeStatus(ADDef.STATUS_PRE_SUCCESS,false);
							this._ADProxy.removeStatus(ADDef.STATUS_PRE_FAILED,false);
						}
						
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2) {
						this.onAddReady(param3);
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPPING:
					if((param2) && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.hideDock();
						this._ADProxy.curPlayCount++;
						this._ADProxy.curAdContextPlayDuration = this._ADProxy.curAdContextPlayDuration + _loc5_.curActor.playingDuration;
						this._ADProxy.curAdContext15PlayDuration = this._ADProxy.curAdContext15PlayDuration + _loc5_.curActor.playingDuration;
						this._ADProxy.prePlayCount++;
						this._ADProxy.preAdContextPlayDuration = this._ADProxy.preAdContextPlayDuration + _loc5_.curActor.playingDuration;
						this._ADProxy.preAdContext15PlayDuration = this._ADProxy.preAdContext15PlayDuration + _loc5_.curActor.playingDuration;
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPED:
					if((param2) && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this._ADProxy.removeStatus(ADDef.STATUS_PLAY_END,false);
						this._ADProxy.removeStatus(ADDef.STATUS_LOADING,false);
						this._ADProxy.removeStatus(ADDef.STATUS_PLAYING,false);
						this._ADProxy.removeStatus(ADDef.STATUS_PAUSED,false);
						if(this.checkSkipTrailerAD()) {
							this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
						} else if(this._ADView.adPlayer) {
							this.onVolumeChanged();
							this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
							this._ADView.onVideoStop();
						} else {
							this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
						}
						
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
					if((param2) && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.hideDock();
						if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && _loc5_.curActor.errorCode == 5000) {
							this.unloadAdPlayer();
							this.removeAllAdStatus();
						}
					}
					break;
			}
		}
		
		private function onAddReady(param1:String) : void {
			var _loc3_:* = false;
			var _loc4_:* = false;
			var _loc5_:* = false;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(param1 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				if((_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
					PingBack.getInstance().sendBeforeADInit();
					_loc3_ = this.checkSkipTitleAD();
					if(_loc3_) {
						this.unloadAdPlayer();
						this.removeAllAdStatus();
						sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
						this.trySendSkipADPingBack();
					} else if(this._ADProxy.hasStatus(ADDef.STATUS_PRE_FAILED)) {
						this.unloadAdPlayer();
						this.removeAllAdStatus();
						this._ADProxy.addStatus(ADDef.STATUS_LOADING);
						this.createADPlayer();
					} else {
						_loc4_ = this._ADProxy.hasStatus(ADDef.STATUS_PRE_LOADING);
						_loc5_ = this._ADProxy.hasStatus(ADDef.STATUS_PRE_SUCCESS);
						this.removeAllAdStatus();
						if((this._ADView.adPlayer) && ((_loc4_) || (_loc5_))) {
							if(!_loc5_) {
								sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
								this._ADProxy.addStatus(ADDef.STATUS_LOADING);
							}
							this._log.info("ad switch pre on player all ready");
							this._ADView.onSwitchPre();
						} else {
							this._ADProxy.addStatus(ADDef.STATUS_LOADING);
							this.createADPlayer();
						}
					}
					
					this.showSkipADTip();
				}
			} else if(param1 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE) {
				if((_loc2_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc2_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
					sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
				}
				this.executeTryADPre();
			}
			
		}
		
		private function executeTryADPre() : void {
			var _loc1_:PlayerProxy = null;
			var _loc2_:IMovieModel = null;
			var _loc3_:UserProxy = null;
			var _loc4_:* = 0;
			var _loc5_:ContinuePlayProxy = null;
			var _loc6_:ContinueInfo = null;
			var _loc7_:Object = null;
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE && !this._ADProxy.hasStatus(ADDef.STATUS_PRE_STARTED)) {
				_loc1_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc2_ = _loc1_.curActor.movieModel;
				_loc3_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				if(_loc2_) {
					_loc4_ = 0;
					if((Settings.instance.skipTrailer) && _loc2_.trailerTime > 0) {
						_loc4_ = _loc2_.trailerTime;
					} else {
						_loc4_ = _loc2_.duration;
					}
					if(_loc4_ - _loc1_.curActor.currentTime < ADDef.PRE_LOAD_TIME) {
						if((_loc1_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) && (_loc1_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc1_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
							if(!this.checkSkipTitlePreAD()) {
								sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_STOP_LOAD);
								_loc5_ = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
								_loc6_ = _loc5_.findContinueInfo(_loc1_.preActor.loadMovieParams.tvid,_loc1_.preActor.loadMovieParams.vid);
								_loc7_ = {};
								_loc7_.videoId = _loc1_.preActor.loadMovieParams.vid;
								_loc7_.tvId = _loc1_.preActor.loadMovieParams.tvid;
								_loc7_.channelId = _loc1_.preActor.movieModel.channelID.toString();
								_loc7_.albumId = _loc1_.preActor.movieModel.albumId.toString();
								if(_loc6_) {
									_loc7_.playerId = _loc6_.cupId;
								} else {
									_loc7_.playerId = "";
								}
								_loc7_.userId = UUIDManager.instance.uuid;
								_loc7_.videoEventId = _loc1_.preActor.videoEventID;
								_loc7_.duration = _loc1_.preActor.movieModel.duration / 1000;
								_loc7_.isUGC = UGCUtils.isUGC(_loc1_.preActor.movieModel.tvid);
								_loc7_.disableSkipAd = _loc1_.preActor.movieModel.forceAD;
								_loc7_.collectionId = FlashVarConfig.collectionID;
								_loc7_.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
								_loc7_.videoDefinitionId = _loc1_.preActor.movieModel.curDefinitionInfo.type.id;
								this._ADProxy.addStatus(ADDef.STATUS_PRE_LOADING);
								this._log.info("start preload next AD,tvid:" + _loc7_.tvId + ",vid:" + _loc7_.videoId + ",cupId:" + _loc7_.playerId + ",videoPlaySecondsOfDay:" + _loc7_.videoPlaySecondsOfDay + ",disablePreroll:" + _loc7_.disablePreroll);
								this._ADProxy.addStatus(ADDef.STATUS_PRE_STARTED);
								this._ADView.onPreloadNextAD(_loc7_);
							}
						}
					}
				}
			}
		}
		
		private function onLoadSuccess(param1:ADEvent) : void {
			WonderVersion.VERSION_AD_PLAYER = String(param1.data.version);
			var _loc2_:String = param1.data.tvid;
			var _loc3_:String = param1.data.vid;
			this._log.info("success to load adplayer,tvid:" + _loc2_ + ",vid:" + _loc3_);
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4_.curActor.loadMovieParams.tvid == _loc2_ && _loc4_.curActor.loadMovieParams.vid == _loc3_) {
				if((_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
					this.onCurLoadSuccess();
				}
			} else if(_loc4_.preActor.loadMovieParams) {
				if(_loc4_.preActor.loadMovieParams.tvid == _loc2_ && _loc4_.preActor.loadMovieParams.vid == _loc3_) {
					if((_loc4_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc4_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
						this.onPreLoadSuccess();
					}
				} else {
					this._log.error("success to load adplayer,but has error,tvid and vid is invalid!");
				}
			} else {
				this._log.error("success to load adplayer,but has error,loadMovieParams is null!");
			}
			
		}
		
		private function onCurLoadSuccess() : void {
			var _loc1_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc4_:Object = new Object();
			if(this._ADProxy.curPlayCount >= ADDef.AD_CONTEXT_COUNT_LIMIT) {
				_loc4_.adContext = "1";
			} else {
				_loc4_.adContext = "0";
			}
			if(this._ADProxy.curAdContext15PlayDuration >= ADDef.AD_CONTEXT_DURATION_15_LIMIT) {
				_loc4_.adContext15 = "1";
			} else {
				_loc4_.adContext15 = "0";
			}
			_loc4_.videoid = _loc2_.curActor.loadMovieParams.vid;
			_loc4_.tvid = _loc2_.curActor.loadMovieParams.tvid;
			_loc4_.channelid = _loc2_.curActor.movieModel.channelID.toString();
			_loc4_.videoname = encodeURI(_loc2_.curActor.movieInfo.title);
			_loc4_.playerid = this._ADProxy.cupId;
			_loc4_.webEventId = UUIDManager.instance.getWebEventID();
			_loc4_.videoEventId = _loc2_.curActor.videoEventID;
			_loc4_.userid = UUIDManager.instance.uuid;
			_loc4_.albumid = _loc2_.curActor.movieModel.albumId;
			_loc4_.adDepot = this._ADView.adDepot;
			_loc4_.duration = String(_loc2_.curActor.movieModel.duration / 1000);
			_loc4_.vipRight = _loc1_.userLevel != UserDef.USER_LEVEL_NORMAL?"1":"0";
			if((_loc3_.isJSContinue) || (_loc3_.continueInfoCount > 0 && _loc3_.isContinue) && (_loc3_.findNextContinueInfo(_loc4_.tvid,_loc4_.videoid))) {
				_loc4_.hasNext = "1";
			} else {
				_loc4_.hasNext = "0";
			}
			if(this._ADProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO) {
				_loc4_.continuingPlay = "1";
			} else {
				_loc4_.continuingPlay = "0";
			}
			_loc4_.passportKey = KeyUtils.getPassportKey(0);
			if(_loc1_.isLogin) {
				_loc4_.passportId = _loc1_.passportID;
				_loc4_.passportCookie = _loc1_.P00001;
			} else {
				_loc4_.passportId = "";
				_loc4_.passportCookie = "";
			}
			this._log.info("success to load cur adplayer: " + "cupId(" + _loc4_.playerid + ")," + "hasNext(" + _loc4_.hasNext + ")," + "adContext(" + _loc4_.adContext + ")," + "adContext15(" + _loc4_.adContext15 + ")," + "adDepot(" + _loc4_.adDepot + ")," + "vipRight(" + _loc4_.vipRight + ")," + "switchOperatorType(" + _loc4_.continuingPlay + "),");
			this._ADView.onCurInfoChanged(_loc4_);
			this._ADView.onFullScreenChanged(GlobalStage.isFullScreen());
			this._ADProxy.addStatus(ADDef.STATUS_APPEARS,false);
		}
		
		private function onPreLoadSuccess() : void {
			var _loc1_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc4_:int = _loc2_.curActor.playingDuration;
			var _loc5_:Object = new Object();
			if(this._ADProxy.prePlayCount + 1 >= ADDef.AD_CONTEXT_COUNT_LIMIT) {
				_loc5_.adContext = "1";
			} else {
				_loc5_.adContext = "0";
			}
			if(this._ADProxy.preAdContext15PlayDuration + _loc4_ >= ADDef.AD_CONTEXT_DURATION_15_LIMIT) {
				_loc5_.adContext15 = "1";
			} else {
				_loc5_.adContext15 = "0";
			}
			var _loc6_:ContinueInfo = _loc3_.findContinueInfo(_loc2_.preActor.loadMovieParams.tvid,_loc2_.preActor.loadMovieParams.vid);
			_loc5_.videoid = _loc2_.preActor.loadMovieParams.vid;
			_loc5_.tvid = _loc2_.preActor.loadMovieParams.tvid;
			_loc5_.channelid = _loc2_.preActor.movieModel.channelID.toString();
			_loc5_.videoname = encodeURI(_loc2_.preActor.movieInfo.title);
			if(_loc6_) {
				_loc5_.playerid = _loc6_.cupId;
			} else {
				_loc5_.playerid = "";
			}
			_loc5_.webEventId = UUIDManager.instance.getWebEventID();
			_loc5_.videoEventId = _loc2_.preActor.videoEventID;
			_loc5_.userid = UUIDManager.instance.uuid;
			_loc5_.albumid = _loc2_.preActor.movieModel.albumId;
			_loc5_.duration = String(_loc2_.preActor.movieModel.duration / 1000);
			_loc5_.vipRight = _loc1_.userLevel != UserDef.USER_LEVEL_NORMAL?"1":"0";
			if((_loc3_.isJSContinue) || (_loc3_.continueInfoCount > 0 && _loc3_.isContinue) && (_loc3_.findNextContinueInfo(_loc5_.tvid,_loc5_.videoid))) {
				_loc5_.hasNext = "1";
			} else {
				_loc5_.hasNext = "0";
			}
			_loc5_.continuingPlay = "1";
			_loc5_.passportKey = KeyUtils.getPassportKey(0);
			if(_loc1_.isLogin) {
				_loc5_.passportId = _loc1_.passportID;
				_loc5_.passportCookie = _loc1_.P00001;
			} else {
				_loc5_.passportId = "";
				_loc5_.passportCookie = "";
			}
			this._log.info("success to load pre adplayer: " + "cupId(" + _loc5_.playerid + ")," + "hasNext(" + _loc5_.hasNext + ")," + "adContext(" + _loc5_.adContext + ")," + "adContext15(" + _loc5_.adContext15 + ")," + "vipRight(" + _loc5_.vipRight + "),");
			this._ADView.onPreInfoChanged(_loc5_);
			this._ADView.onFullScreenChanged(GlobalStage.isFullScreen());
		}
		
		private function onLoadFailed(param1:ADEvent) : void {
			var _loc2_:String = param1.data.tvid;
			var _loc3_:String = param1.data.vid;
			this._log.warn("failed to load adplayer,tvid:" + _loc2_ + ",vid:" + _loc3_);
			ProcessesTimeRecord.needRecord = false;
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4_.curActor.loadMovieParams.tvid == _loc2_ && _loc4_.curActor.loadMovieParams.vid == _loc3_) {
				this._log.warn("failed to load cur adplayer!");
				this.unloadAdPlayer();
				this.removeAllAdStatus();
				sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
				this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
				this.showSkipADTip();
			} else if(_loc4_.preActor.loadMovieParams) {
				if(_loc4_.preActor.loadMovieParams.tvid == _loc2_ && _loc4_.preActor.loadMovieParams.vid == _loc3_) {
					this._log.warn("failed to load pre adplayer!");
					sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
					this._ADProxy.addStatus(ADDef.STATUS_PRE_FAILED);
				} else {
					this._log.error("failed to load adplayer,has error,tvid and vid is invalid!");
				}
			} else {
				this._log.error("failed to load adplayer,has error,loadMovieParams is null!");
			}
			
		}
		
		private function onStartPlay(param1:ADEvent) : void {
			var curDate:Date = null;
			var diff:Number = NaN;
			var event:ADEvent = param1;
			var tvid:String = event.data.tvid;
			var vid:String = event.data.vid;
			this._log.info("Adplayer start play ad,tvid:" + tvid + ",vid:" + vid);
			var playerProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(playerProxy.curActor.loadMovieParams.tvid == tvid && playerProxy.curActor.loadMovieParams.vid == vid) {
				this._log.info("Adplayer start play cur ad!");
				if(ProcessesTimeRecord.usedTime_showVideo == 0) {
					ProcessesTimeRecord.usedTime_adInit = getTimer() - ProcessesTimeRecord.STime_adInit;
					ProcessesTimeRecord.usedTime_showVideo = getTimer() - ProcessesTimeRecord.STime_showVideo;
					if(FlashVarConfig.pageCTime > 0) {
						curDate = new Date();
						diff = curDate.getTime() - FlashVarConfig.pageCTime;
						if(diff > 0) {
							ProcessesTimeRecord.usedTime_pageShowVideo = diff;
						}
					}
				}
				if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT) {
					try {
						ExternalInterface.call("adStartPlay");
					}
					catch(error:Error) {
					}
				}
				this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
				this.onVolumeChanged();
				playerProxy.curActor.startLoadMeta();
				playerProxy.curActor.startLoadHistory();
				playerProxy.curActor.startLoadP2P();
				if((playerProxy.curActor.movieModel) && (playerProxy.curActor.movieModel.forceAD)) {
					this.showCopyrightForceADTip();
				}
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_AD_PLAYING);
			} else {
				this._log.error("Adplayer start play pre ad!");
			}
		}
		
		private function onAskVideoPause(param1:ADEvent) : void {
			var _loc2_:String = param1.data.tvid;
			var _loc3_:String = param1.data.vid;
			this._log.info("ADPlayer ask Video Pause,tvid:" + _loc2_ + ",vid:" + _loc3_);
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4_.curActor.loadMovieParams.tvid == _loc2_ && _loc4_.curActor.loadMovieParams.vid == _loc3_) {
				this._log.info("ADPlayer cur ask Video Pause!");
				this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				this._ADView.onVolumeChanged(Settings.instance.mute?0:Settings.instance.volumn);
				sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
			} else {
				this._log.error("ADPlayer pre ask Video Pause!");
			}
		}
		
		private function onAskVideoResume(param1:ADEvent) : void {
			var _loc2_:String = param1.data.tvid;
			var _loc3_:String = param1.data.vid;
			this._log.info("Adplayer ask Video Resume,tvid:" + _loc2_ + ",vid:" + _loc3_);
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4_.curActor.loadMovieParams.tvid == _loc2_ && _loc4_.curActor.loadMovieParams.vid == _loc3_) {
				this._log.info("Adplayer cur ask Video Resume!");
				this.onVolumeChanged();
				sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
				this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
			} else {
				this._log.error("Adplayer pre ask Video Resume!");
			}
		}
		
		private function onAskVideoStartLoad(param1:ADEvent) : void {
			var _loc2_:String = param1.data.tvid;
			var _loc3_:String = param1.data.vid;
			this._log.info("Adplayer ask Video StartLoad,tvid:" + _loc2_ + ",vid:" + _loc3_);
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4_.curActor.loadMovieParams.tvid == _loc2_ && _loc4_.curActor.loadMovieParams.vid == _loc3_) {
				this._log.info("Adplayer cur ask Video StartLoad!");
				_loc4_.curActor.setADRemainTime(int(param1.data.delay) * 1000);
				sendNotification(BodyDef.NOTIFIC_PLAYER_START_LOAD);
			} else if(_loc4_.preActor.loadMovieParams) {
				if(_loc4_.preActor.loadMovieParams.tvid == _loc2_ && _loc4_.preActor.loadMovieParams.vid == _loc3_) {
					this._log.info("Adplayer pre ask Video StartLoad!");
					_loc4_.preActor.setADRemainTime(int(param1.data.delay) * 1000);
					this._ADProxy.addStatus(ADDef.STATUS_PRE_SUCCESS);
					sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
				} else {
					this._log.error("Adplayer ask Video StartLoad,has error,tvid and vid is invalid!");
				}
			} else {
				this._log.error("Adplayer ask Video StartLoad,has error,loadMovieParams is null!");
			}
			
		}
		
		private function onAskVideoStartPlay(param1:ADEvent) : void {
			var _loc2_:String = param1.data.tvid;
			var _loc3_:String = param1.data.vid;
			var _loc4_:Array = param1.data.viewPoints as Array;
			this._log.info("Adplayer ask Video StartPlay,tvid:" + _loc2_ + ",vid:" + _loc3_);
			var _loc5_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc5_.curActor.loadMovieParams.tvid == _loc2_ && _loc5_.curActor.loadMovieParams.vid == _loc3_) {
				this._log.info("Adplayer cur ask Video StartPlay!");
				this._ADProxy.setADViewPoints(_loc4_);
				this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
				if(!_loc5_.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) {
					sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
					this.trySendSkipADPingBack();
					this.showSkipADTip();
					if(this._ADProxy.blocked) {
						this._log.info("Adplayer blocked,unload ad player on ask video start player!");
						this.unloadAdPlayer();
						this.removeAllAdStatus();
					}
				}
			} else {
				this._log.error("Adplayer pre ask Video StartPlay!");
			}
		}
		
		private function onAskVideoEnd(param1:ADEvent) : void {
			var _loc5_:Object = null;
			var _loc2_:String = param1.data.tvid;
			var _loc3_:String = param1.data.vid;
			this._log.info("Adplayer ask Video VideoEnd,tvid:" + _loc2_ + ",vid:" + _loc3_);
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4_.curActor.loadMovieParams.tvid == _loc2_ && _loc4_.curActor.loadMovieParams.vid == _loc3_) {
				this._log.info("Adplayer cur Video VideoEnd!");
				_loc5_ = new Object();
				_loc5_.adDepot = this._ADView.adDepot;
				this._ADView.onSendNotific(_loc5_);
				this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
			} else {
				this._log.error("Adplayer pre Video VideoEnd!");
			}
		}
		
		private function onAdBlock(param1:ADEvent) : void {
			var _loc2_:String = param1.data.tvid;
			var _loc3_:String = param1.data.vid;
			var _loc4_:Boolean = param1.data.isCidErr;
			this._log.info("Adplayer ask AD Block,tvid:" + _loc2_ + ",vid:" + _loc3_ + ",isCidErr:" + _loc4_);
			var _loc5_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			_loc5_.invalid = _loc4_;
			ProcessesTimeRecord.needRecord = false;
			if(_loc5_.curActor.loadMovieParams.tvid == _loc2_ && _loc5_.curActor.loadMovieParams.vid == _loc3_) {
				this._log.info("Adplayer cur AD Block!");
				this._ADProxy.blocked = true;
				this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_AD_PLAYING);
			} else if(_loc5_.preActor.loadMovieParams) {
				if(_loc5_.preActor.loadMovieParams.tvid == _loc2_ && _loc5_.preActor.loadMovieParams.vid == _loc3_) {
					this._log.info("Adplayer pre AD Block!");
					this._ADProxy.addStatus(ADDef.STATUS_PRE_SUCCESS);
				} else {
					this._log.error("Adplayer ask AD Block,has error,tvid and vid is invalid!");
				}
			} else {
				this._log.error("Adplayer ask AD Block,has error,loadMovieParams is null!");
			}
			
		}
		
		private function onAdUnloaded(param1:ADEvent) : void {
			sendNotification(ADDef.NOTIFIC_AD_UNLOADED);
		}
		
		private function onVolumeChanged() : void {
			if((this._ADProxy.mute) || (Settings.instance.mute)) {
				this._ADView.onVolumeChanged(0);
			} else {
				this._ADView.onVolumeChanged(Settings.instance.volumn);
			}
		}
		
		private function trySendSkipADPingBack() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if((_loc2_.isLogin && !(_loc2_.userLevel == UserDef.USER_LEVEL_NORMAL)) && (_loc1_.curActor.movieModel) && !_loc1_.curActor.movieModel.forceAD) {
				PingBack.getInstance().skipAD(_loc2_.passportID,_loc1_.curActor.uuid,_loc1_.curActor.movieModel.tvid,_loc1_.curActor.movieModel.albumId);
			}
		}
		
		private function onMouseMove(param1:MouseEvent) : void {
			if(this.checkDockShowStatus()) {
				this._ADView.onDockShowChanged(true);
				TweenLite.killTweensOf(this.hideDock);
				TweenLite.delayedCall(ADDef.DOCK_HIND_DELAY / 1000,this.hideDock);
			}
		}
		
		private function hideDock() : void {
			this._ADView.onDockShowChanged(false);
		}
		
		private function checkDockShowStatus() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK) && _loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || _loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) || _loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) && !this._ADProxy.hasStatus(ADDef.STATUS_LOADING) && !this._ADProxy.hasStatus(ADDef.STATUS_PLAYING) && !this._ADProxy.hasStatus(ADDef.STATUS_PAUSED) && _loc1_.curActor.movieModel) && (!(_loc1_.curActor.movieModel.screenType == ScreenEnum.THREE_D)) && !_loc1_.curActor.smallWindowMode) {
				return true;
			}
			return false;
		}
	}
}
