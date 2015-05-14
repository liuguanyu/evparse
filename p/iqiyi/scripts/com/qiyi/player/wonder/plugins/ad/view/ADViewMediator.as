package com.qiyi.player.wonder.plugins.ad.view
{
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
	
	public class ADViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.ad.view.ADViewMediator";
		
		private var _ADProxy:ADProxy;
		
		private var _ADView:ADView;
		
		private var _log:ILogger;
		
		public function ADViewMediator(param1:ADView)
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.plugins.ad.view.ADViewMediator");
			super(NAME,param1);
			this._ADView = param1;
		}
		
		override public function onRegister() : void
		{
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
		
		override public function listNotificationInterests() : Array
		{
			return [ADDef.NOTIFIC_ADD_STATUS,ADDef.NOTIFIC_REMOVE_STATUS,ADDef.NOTIFIC_PAUSE,ADDef.NOTIFIC_RESUME,ADDef.NOTIFIC_POPUP_OPEN,ADDef.NOTIFIC_POPUP_CLOSE,ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO,ADDef.NOTIFIC_AD_VOLUMN_CHANGED,ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER,ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED,ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED,BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_JS_LIGHT_CHANGED,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE,BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO,BodyDef.NOTIFIC_MOUSE_LAYER_CLICK,BodyDef.NOTIFIC_JS_CALL_PAUSE,BodyDef.NOTIFIC_JS_CALL_RESUME,BodyDef.NOTIFIC_JS_CALL_REPLAY,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			var _loc5:Object = null;
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case ADDef.NOTIFIC_ADD_STATUS:
					this._ADView.onAddStatus(int(_loc2));
					break;
				case ADDef.NOTIFIC_REMOVE_STATUS:
					this._ADView.onRemoveStatus(int(_loc2));
					break;
				case BodyDef.NOTIFIC_JS_CALL_PAUSE:
				case ADDef.NOTIFIC_PAUSE:
					if(!this.checkSkipPauseAD())
					{
						PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
					}
					if(this._ADProxy.hasStatus(ADDef.STATUS_PLAYING))
					{
						this._ADProxy.addStatus(ADDef.STATUS_PAUSED);
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_AD_PAUSED);
					}
					this._ADView.onPause();
					break;
				case BodyDef.NOTIFIC_JS_CALL_RESUME:
				case ADDef.NOTIFIC_RESUME:
					if(this._ADProxy.hasStatus(ADDef.STATUS_PAUSED))
					{
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
					this.onRequestReplayVideo(_loc2);
					break;
				case ADDef.NOTIFIC_AD_VOLUMN_CHANGED:
					this.onVolumeChanged();
					break;
				case ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID:
					this._ADProxy.cupId = _loc2 as String;
					break;
				case ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER:
					this.unloadAdPlayer();
					this.removeAllAdStatus();
					break;
				case ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED:
					this.onContinueListChanged();
					break;
				case ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED:
					this.onNoticePrepareSwitchVideo(int(_loc2));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._ADView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS:
					this.onPlayerStatusChanged(int(_loc2),false,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2.currentTime,_loc2.bufferTime,_loc2.duration);
					break;
				case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
					this._ADView.onLightStateChanged(Boolean(_loc2));
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					this._ADView.onFullScreenChanged(Boolean(_loc2));
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:
					this.onJSCallSetContinuePlayState(Boolean(_loc2));
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:
					_loc5 = new Object();
					_loc5.hasNext = Boolean(_loc2.continuePlay)?"1":"0";
					this._ADView.onSendNotific(_loc5);
					break;
				case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
					if(_loc4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						this.onPlayerDefinitionSwitched(int(_loc2));
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
					if(Boolean(_loc2))
					{
						this.hideDock();
					}
					break;
			}
		}
		
		private function onPlayerDefinitionSwitched(param1:int) : void
		{
			var _loc2:PlayerProxy = null;
			var _loc3:Object = null;
			if(param1 >= 0)
			{
				_loc2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3 = new Object();
				_loc3.videoDefinitionId = _loc2.curActor.movieModel.curDefinitionInfo.type.id;
				this._ADView.onSendNotific(_loc3);
			}
		}
		
		private function onNoticePrepareSwitchVideo(param1:int) : void
		{
			this._ADProxy.switchVideoType = param1;
			if(param1 != ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO)
			{
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
		
		private function onContinueListChanged() : void
		{
			var _loc2:ContinuePlayProxy = null;
			var _loc3:String = null;
			var _loc4:String = null;
			var _loc5:Object = null;
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1.curActor.loadMovieParams)
			{
				_loc2 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
				_loc3 = _loc1.curActor.loadMovieParams.vid;
				_loc4 = _loc1.curActor.loadMovieParams.tvid;
				_loc5 = new Object();
				if(_loc2.continueInfoCount > 0 && (_loc2.isContinue) && (_loc2.findNextContinueInfo(_loc4,_loc3)))
				{
					_loc5.hasNext = "1";
				}
				else
				{
					_loc5.hasNext = "0";
				}
				this._ADView.onSendNotific(_loc5);
			}
		}
		
		private function onJSCallSetContinuePlayState(param1:Boolean) : void
		{
			var _loc4:String = null;
			var _loc5:String = null;
			var _loc6:ContinuePlayProxy = null;
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:Object = new Object();
			if((_loc2.curActor.loadMovieParams) && (param1))
			{
				_loc4 = _loc2.curActor.loadMovieParams.tvid;
				_loc5 = _loc2.curActor.loadMovieParams.vid;
				_loc6 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
				if(_loc6.continueInfoCount > 0 && (_loc6.findNextContinueInfo(_loc4,_loc5)))
				{
					_loc3.hasNext = "1";
				}
				else
				{
					_loc3.hasNext = "0";
				}
			}
			else
			{
				_loc3.hasNext = "0";
			}
			this._ADView.onSendNotific(_loc3);
		}
		
		private function createADPlayer() : void
		{
			sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
			ProcessesTimeRecord.STime_adInit = getTimer();
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc3:CupidParam = new CupidParam();
			_loc3.playerUrl = FlashVarConfig.adPlayerURL;
			_loc3.videoId = _loc1.curActor.loadMovieParams.vid;
			_loc3.tvId = _loc1.curActor.loadMovieParams.tvid;
			_loc3.channelId = _loc1.curActor.movieModel.channelID;
			_loc3.playerId = FlashVarConfig.cupId;
			_loc3.albumId = _loc1.curActor.movieModel.albumId;
			_loc3.dispatcher = null;
			_loc3.adContainer = this._ADView;
			_loc3.stageWidth = GlobalStage.stage.stageWidth;
			_loc3.stageHeight = GlobalStage.stage.stageHeight;
			_loc3.userId = _loc1.curActor.uuid;
			_loc3.webEventId = UUIDManager.instance.getWebEventID();
			_loc3.videoEventId = UUIDManager.instance.getVideoEventID();
			_loc3.vipRight = _loc2.userLevel != UserDef.USER_LEVEL_NORMAL?"1":"0";
			_loc3.terminal = "iqiyiw";
			_loc3.duration = _loc1.curActor.movieModel.duration / 1000;
			_loc3.passportId = _loc2.passportID;
			_loc3.passportCookie = _loc2.P00001;
			_loc3.passportKey = KeyUtils.getPassportKey(0);
			_loc3.enableVideoCore = false;
			_loc3.disableSkipAd = _loc1.curActor.movieModel.forceAD;
			_loc3.volume = Settings.instance.mute?0:Settings.instance.volumn;
			_loc3.isUGC = UGCUtils.isUGC(_loc1.curActor.movieModel.tvid);
			_loc3.collectionId = FlashVarConfig.collectionID;
			_loc3.videoDefinitionId = _loc1.curActor.movieModel.curDefinitionInfo.type.id;
			_loc3.cacheMachineIp = _loc1.curActor.VInfoDisIP;
			_loc3.couponCode = FlashVarConfig.couponCode;
			_loc3.couponVer = FlashVarConfig.couponVer;
			_loc3.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
			_loc3.videoPlayerVersion = WonderVersion.VERSION_WONDER;
			this._ADView.createAdPlayer(_loc3);
		}
		
		private function unloadAdPlayer() : void
		{
			this._ADView.unloadAdPlayer();
			this._ADProxy.blocked = false;
		}
		
		private function removeAllAdStatus() : void
		{
			this._ADProxy.removeStatus(ADDef.STATUS_PLAY_END,false);
			this._ADProxy.removeStatus(ADDef.STATUS_LOADING,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PLAYING,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PAUSED,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PRE_LOADING,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PRE_SUCCESS,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PRE_FAILED,false);
			this._ADProxy.removeStatus(ADDef.STATUS_PRE_STARTED,false);
		}
		
		private function onADViewOpen(param1:ADEvent) : void
		{
			if(!this._ADProxy.hasStatus(ADDef.STATUS_OPEN))
			{
				this._ADProxy.addStatus(ADDef.STATUS_OPEN);
			}
		}
		
		private function onADViewClose(param1:ADEvent) : void
		{
			if(this._ADProxy.hasStatus(ADDef.STATUS_OPEN))
			{
				this._ADProxy.removeStatus(ADDef.STATUS_OPEN);
			}
		}
		
		private function onRequestReplayVideo(param1:Object = null) : void
		{
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
			{
				sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAY);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
				if(param1)
				{
					sendNotification(BodyDef.NOTIFIC_PLAYER_SEEK,{"time":param1});
				}
			}
		}
		
		private function onCheckUserComplete() : void
		{
			var _loc1:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2:UserInfoVO = new UserInfoVO();
			_loc2.isLogin = _loc1.isLogin;
			_loc2.passportID = _loc1.passportID;
			_loc2.userID = _loc1.userID;
			_loc2.userName = _loc1.userName;
			_loc2.userLevel = _loc1.userLevel;
			_loc2.userType = _loc1.userType;
			this._ADView.onUserInfoChanged(_loc2);
			var _loc3:Object = new Object();
			_loc3.vipRight = _loc1.userLevel != UserDef.USER_LEVEL_NORMAL?"1":"0";
			if(_loc1.isLogin)
			{
				_loc3.passportId = _loc1.passportID;
				_loc3.passportCookie = _loc1.P00001;
			}
			else
			{
				_loc3.passportId = "";
				_loc3.passportCookie = "";
			}
			this._ADView.onSendNotific(_loc3);
		}
		
		private function checkSkipTitleAD() : Boolean
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((_loc1.curActor.isPlayRefreshed) || (_loc1.curActor.movieModel.member) || _loc1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || _loc1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D)
			{
				return true;
			}
			return false;
		}
		
		private function checkSkipTitlePreAD() : Boolean
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1.preActor.movieModel.member)
			{
				return true;
			}
			return false;
		}
		
		private function checkSkipTrailerAD() : Boolean
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if((_loc1.curActor.movieModel.member) || (this._ADProxy.hasStatus(ADDef.STATUS_APPEARS)) && (_loc2.isLogin) && !(_loc2.userLevel == UserDef.USER_LEVEL_NORMAL) && !_loc1.curActor.movieModel.forceAD || _loc1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || _loc1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D)
			{
				return true;
			}
			return false;
		}
		
		private function checkSkipPauseAD() : Boolean
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if(_loc1.curActor.movieModel == null || (_loc1.curActor.movieModel.member) || (_loc2.isLogin) && !(_loc2.userLevel == UserDef.USER_LEVEL_NORMAL) && !_loc1.curActor.movieModel.forceAD || _loc1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || _loc1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D)
			{
				return true;
			}
			return false;
		}
		
		private function showSkipADTip() : void
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if((_loc2.isLogin) && !(_loc2.userLevel == UserDef.USER_LEVEL_NORMAL) && !_loc1.curActor.movieModel.member && !_loc1.curActor.movieModel.forceAD)
			{
				sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_PRO_SKIP_AD);
			}
		}
		
		private function showCopyrightForceADTip() : void
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if((_loc2.isLogin) && !(_loc2.userLevel == UserDef.USER_LEVEL_NORMAL) && !_loc1.curActor.movieModel.member && (_loc1.curActor.movieModel.forceAD))
			{
				sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_COPYRIGHT_FORCE_AD_TIP);
			}
		}
		
		private function onPlayerSwitchPreActor() : void
		{
			var _loc2:* = false;
			var _loc3:* = false;
			var _loc4:* = false;
			this.hideDock();
			this._ADProxy.clearADViewPoints();
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
			{
				this.unloadAdPlayer();
				this.removeAllAdStatus();
			}
			else if((_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
			{
				_loc2 = this.checkSkipTitleAD();
				if(_loc2)
				{
					this.unloadAdPlayer();
					this.removeAllAdStatus();
					sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
					this.trySendSkipADPingBack();
				}
				else if(this._ADProxy.hasStatus(ADDef.STATUS_PRE_FAILED))
				{
					this.unloadAdPlayer();
					this.removeAllAdStatus();
					this._ADProxy.addStatus(ADDef.STATUS_LOADING);
					this.createADPlayer();
				}
				else
				{
					_loc3 = this._ADProxy.hasStatus(ADDef.STATUS_PRE_LOADING);
					_loc4 = this._ADProxy.hasStatus(ADDef.STATUS_PRE_SUCCESS);
					this.removeAllAdStatus();
					if((this._ADView.adPlayer) && ((_loc3) || (_loc4)))
					{
						if(!_loc4)
						{
							sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
							this._ADProxy.addStatus(ADDef.STATUS_LOADING);
						}
						this._log.info("ad switch pre on player switch pre!");
						this._ADView.onSwitchPre();
					}
					else
					{
						this._ADProxy.addStatus(ADDef.STATUS_LOADING);
						this.createADPlayer();
					}
				}
				
				this.showSkipADTip();
			}
			
			this._ADProxy.mute = Settings.instance.mute;
		}
		
		private function onMouseLayerClick() : void
		{
			var _loc1:PlayerProxy = null;
			if(!this._ADProxy.hasStatus(ADDef.STATUS_LOADING) && !this._ADProxy.hasStatus(ADDef.STATUS_PLAYING) && !this._ADProxy.hasStatus(ADDef.STATUS_PAUSED))
			{
				_loc1 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
				{
					sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
					this._ADView.onResume();
					GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
				}
				else
				{
					if(!this.checkSkipPauseAD())
					{
						PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
					}
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE,PauseTypeEnum.USER);
					this._ADView.onPause();
					GlobalStage.stage.dispatchEvent(new Event("tmp_dis_pause_to_p2p"));
				}
			}
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int) : void
		{
			this._ADView.onUpdateCurrentTime(param1);
			var _loc4:Object = new Object();
			_loc4.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
			this._ADView.onSendNotific(_loc4);
			this.executeTryADPre();
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
		{
			var _loc4:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc5:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			switch(param1)
			{
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2)
					{
						if(param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
						{
							this._ADProxy.clearADViewPoints();
							this.hideDock();
							this.unloadAdPlayer();
							this.removeAllAdStatus();
						}
						else if(param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE)
						{
							this._ADProxy.removeStatus(ADDef.STATUS_PRE_LOADING,false);
							this._ADProxy.removeStatus(ADDef.STATUS_PRE_SUCCESS,false);
							this._ADProxy.removeStatus(ADDef.STATUS_PRE_FAILED,false);
						}
						
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2)
					{
						this.onAddReady(param3);
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPPING:
					if((param2) && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						this.hideDock();
						this._ADProxy.curPlayCount++;
						this._ADProxy.curAdContextPlayDuration = this._ADProxy.curAdContextPlayDuration + _loc5.curActor.playingDuration;
						this._ADProxy.curAdContext15PlayDuration = this._ADProxy.curAdContext15PlayDuration + _loc5.curActor.playingDuration;
						this._ADProxy.prePlayCount++;
						this._ADProxy.preAdContextPlayDuration = this._ADProxy.preAdContextPlayDuration + _loc5.curActor.playingDuration;
						this._ADProxy.preAdContext15PlayDuration = this._ADProxy.preAdContext15PlayDuration + _loc5.curActor.playingDuration;
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPED:
					if((param2) && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						this._ADProxy.removeStatus(ADDef.STATUS_PLAY_END,false);
						this._ADProxy.removeStatus(ADDef.STATUS_LOADING,false);
						this._ADProxy.removeStatus(ADDef.STATUS_PLAYING,false);
						this._ADProxy.removeStatus(ADDef.STATUS_PAUSED,false);
						if(this.checkSkipTrailerAD())
						{
							this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
						}
						else if(this._ADView.adPlayer)
						{
							this.onVolumeChanged();
							this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
							this._ADView.onVideoStop();
						}
						else
						{
							this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
						}
						
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
					if((param2) && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						this.hideDock();
						if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && _loc5.curActor.errorCode == 5000)
						{
							this.unloadAdPlayer();
							this.removeAllAdStatus();
						}
					}
					break;
			}
		}
		
		private function onAddReady(param1:String) : void
		{
			var _loc3:* = false;
			var _loc4:* = false;
			var _loc5:* = false;
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(param1 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
			{
				if((_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
				{
					PingBack.getInstance().sendBeforeADInit();
					_loc3 = this.checkSkipTitleAD();
					if(_loc3)
					{
						this.unloadAdPlayer();
						this.removeAllAdStatus();
						sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
						this.trySendSkipADPingBack();
					}
					else if(this._ADProxy.hasStatus(ADDef.STATUS_PRE_FAILED))
					{
						this.unloadAdPlayer();
						this.removeAllAdStatus();
						this._ADProxy.addStatus(ADDef.STATUS_LOADING);
						this.createADPlayer();
					}
					else
					{
						_loc4 = this._ADProxy.hasStatus(ADDef.STATUS_PRE_LOADING);
						_loc5 = this._ADProxy.hasStatus(ADDef.STATUS_PRE_SUCCESS);
						this.removeAllAdStatus();
						if((this._ADView.adPlayer) && ((_loc4) || (_loc5)))
						{
							if(!_loc5)
							{
								sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
								this._ADProxy.addStatus(ADDef.STATUS_LOADING);
							}
							this._log.info("ad switch pre on player all ready");
							this._ADView.onSwitchPre();
						}
						else
						{
							this._ADProxy.addStatus(ADDef.STATUS_LOADING);
							this.createADPlayer();
						}
					}
					
					this.showSkipADTip();
				}
			}
			else if(param1 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE)
			{
				if((_loc2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
				{
					sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
				}
				this.executeTryADPre();
			}
			
		}
		
		private function executeTryADPre() : void
		{
			var _loc1:PlayerProxy = null;
			var _loc2:IMovieModel = null;
			var _loc3:UserProxy = null;
			var _loc4:* = 0;
			var _loc5:ContinuePlayProxy = null;
			var _loc6:ContinueInfo = null;
			var _loc7:Object = null;
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE && !this._ADProxy.hasStatus(ADDef.STATUS_PRE_STARTED))
			{
				_loc1 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc2 = _loc1.curActor.movieModel;
				_loc3 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				if(_loc2)
				{
					_loc4 = 0;
					if((Settings.instance.skipTrailer) && _loc2.trailerTime > 0)
					{
						_loc4 = _loc2.trailerTime;
					}
					else
					{
						_loc4 = _loc2.duration;
					}
					if(_loc4 - _loc1.curActor.currentTime < ADDef.PRE_LOAD_TIME)
					{
						if((_loc1.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) && (_loc1.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc1.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
						{
							if(!this.checkSkipTitlePreAD())
							{
								sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_STOP_LOAD);
								_loc5 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
								_loc6 = _loc5.findContinueInfo(_loc1.preActor.loadMovieParams.tvid,_loc1.preActor.loadMovieParams.vid);
								_loc7 = {};
								_loc7.videoId = _loc1.preActor.loadMovieParams.vid;
								_loc7.tvId = _loc1.preActor.loadMovieParams.tvid;
								_loc7.channelId = _loc1.preActor.movieModel.channelID.toString();
								_loc7.albumId = _loc1.preActor.movieModel.albumId.toString();
								if(_loc6)
								{
									_loc7.playerId = _loc6.cupId;
								}
								else
								{
									_loc7.playerId = "";
								}
								_loc7.userId = UUIDManager.instance.uuid;
								_loc7.videoEventId = _loc1.preActor.videoEventID;
								_loc7.duration = _loc1.preActor.movieModel.duration / 1000;
								_loc7.isUGC = UGCUtils.isUGC(_loc1.preActor.movieModel.tvid);
								_loc7.disableSkipAd = _loc1.preActor.movieModel.forceAD;
								_loc7.collectionId = FlashVarConfig.collectionID;
								_loc7.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
								_loc7.videoDefinitionId = _loc1.preActor.movieModel.curDefinitionInfo.type.id;
								this._ADProxy.addStatus(ADDef.STATUS_PRE_LOADING);
								this._log.info("start preload next AD,tvid:" + _loc7.tvId + ",vid:" + _loc7.videoId + ",cupId:" + _loc7.playerId + ",videoPlaySecondsOfDay:" + _loc7.videoPlaySecondsOfDay + ",disablePreroll:" + _loc7.disablePreroll);
								this._ADProxy.addStatus(ADDef.STATUS_PRE_STARTED);
								this._ADView.onPreloadNextAD(_loc7);
							}
						}
					}
				}
			}
		}
		
		private function onLoadSuccess(param1:ADEvent) : void
		{
			WonderVersion.VERSION_AD_PLAYER = String(param1.data.version);
			var _loc2:String = param1.data.tvid;
			var _loc3:String = param1.data.vid;
			this._log.info("success to load adplayer,tvid:" + _loc2 + ",vid:" + _loc3);
			var _loc4:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4.curActor.loadMovieParams.tvid == _loc2 && _loc4.curActor.loadMovieParams.vid == _loc3)
			{
				if((_loc4.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc4.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
				{
					this.onCurLoadSuccess();
				}
			}
			else if(_loc4.preActor.loadMovieParams)
			{
				if(_loc4.preActor.loadMovieParams.tvid == _loc2 && _loc4.preActor.loadMovieParams.vid == _loc3)
				{
					if((_loc4.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc4.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
					{
						this.onPreLoadSuccess();
					}
				}
				else
				{
					this._log.error("success to load adplayer,but has error,tvid and vid is invalid!");
				}
			}
			else
			{
				this._log.error("success to load adplayer,but has error,loadMovieParams is null!");
			}
			
		}
		
		private function onCurLoadSuccess() : void
		{
			var _loc1:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc4:Object = new Object();
			if(this._ADProxy.curPlayCount >= ADDef.AD_CONTEXT_COUNT_LIMIT)
			{
				_loc4.adContext = "1";
			}
			else
			{
				_loc4.adContext = "0";
			}
			if(this._ADProxy.curAdContext15PlayDuration >= ADDef.AD_CONTEXT_DURATION_15_LIMIT)
			{
				_loc4.adContext15 = "1";
			}
			else
			{
				_loc4.adContext15 = "0";
			}
			_loc4.videoid = _loc2.curActor.loadMovieParams.vid;
			_loc4.tvid = _loc2.curActor.loadMovieParams.tvid;
			_loc4.channelid = _loc2.curActor.movieModel.channelID.toString();
			_loc4.videoname = encodeURI(_loc2.curActor.movieInfo.title);
			_loc4.playerid = this._ADProxy.cupId;
			_loc4.webEventId = UUIDManager.instance.getWebEventID();
			_loc4.videoEventId = _loc2.curActor.videoEventID;
			_loc4.userid = UUIDManager.instance.uuid;
			_loc4.albumid = _loc2.curActor.movieModel.albumId;
			_loc4.adDepot = this._ADView.adDepot;
			_loc4.duration = String(_loc2.curActor.movieModel.duration / 1000);
			_loc4.vipRight = _loc1.userLevel != UserDef.USER_LEVEL_NORMAL?"1":"0";
			if((_loc3.isJSContinue) || (_loc3.continueInfoCount > 0 && _loc3.isContinue) && (_loc3.findNextContinueInfo(_loc4.tvid,_loc4.videoid)))
			{
				_loc4.hasNext = "1";
			}
			else
			{
				_loc4.hasNext = "0";
			}
			if(this._ADProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO)
			{
				_loc4.continuingPlay = "1";
			}
			else
			{
				_loc4.continuingPlay = "0";
			}
			_loc4.passportKey = KeyUtils.getPassportKey(0);
			if(_loc1.isLogin)
			{
				_loc4.passportId = _loc1.passportID;
				_loc4.passportCookie = _loc1.P00001;
			}
			else
			{
				_loc4.passportId = "";
				_loc4.passportCookie = "";
			}
			this._log.info("success to load cur adplayer: " + "cupId(" + _loc4.playerid + ")," + "hasNext(" + _loc4.hasNext + ")," + "adContext(" + _loc4.adContext + ")," + "adContext15(" + _loc4.adContext15 + ")," + "adDepot(" + _loc4.adDepot + ")," + "vipRight(" + _loc4.vipRight + ")," + "switchOperatorType(" + _loc4.continuingPlay + "),");
			this._ADView.onCurInfoChanged(_loc4);
			this._ADView.onFullScreenChanged(GlobalStage.isFullScreen());
			this._ADProxy.addStatus(ADDef.STATUS_APPEARS,false);
		}
		
		private function onPreLoadSuccess() : void
		{
			var _loc1:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc4:int = _loc2.curActor.playingDuration;
			var _loc5:Object = new Object();
			if(this._ADProxy.prePlayCount + 1 >= ADDef.AD_CONTEXT_COUNT_LIMIT)
			{
				_loc5.adContext = "1";
			}
			else
			{
				_loc5.adContext = "0";
			}
			if(this._ADProxy.preAdContext15PlayDuration + _loc4 >= ADDef.AD_CONTEXT_DURATION_15_LIMIT)
			{
				_loc5.adContext15 = "1";
			}
			else
			{
				_loc5.adContext15 = "0";
			}
			var _loc6:ContinueInfo = _loc3.findContinueInfo(_loc2.preActor.loadMovieParams.tvid,_loc2.preActor.loadMovieParams.vid);
			_loc5.videoid = _loc2.preActor.loadMovieParams.vid;
			_loc5.tvid = _loc2.preActor.loadMovieParams.tvid;
			_loc5.channelid = _loc2.preActor.movieModel.channelID.toString();
			_loc5.videoname = encodeURI(_loc2.preActor.movieInfo.title);
			if(_loc6)
			{
				_loc5.playerid = _loc6.cupId;
			}
			else
			{
				_loc5.playerid = "";
			}
			_loc5.webEventId = UUIDManager.instance.getWebEventID();
			_loc5.videoEventId = _loc2.preActor.videoEventID;
			_loc5.userid = UUIDManager.instance.uuid;
			_loc5.albumid = _loc2.preActor.movieModel.albumId;
			_loc5.duration = String(_loc2.preActor.movieModel.duration / 1000);
			_loc5.vipRight = _loc1.userLevel != UserDef.USER_LEVEL_NORMAL?"1":"0";
			if((_loc3.isJSContinue) || (_loc3.continueInfoCount > 0 && _loc3.isContinue) && (_loc3.findNextContinueInfo(_loc5.tvid,_loc5.videoid)))
			{
				_loc5.hasNext = "1";
			}
			else
			{
				_loc5.hasNext = "0";
			}
			_loc5.continuingPlay = "1";
			_loc5.passportKey = KeyUtils.getPassportKey(0);
			if(_loc1.isLogin)
			{
				_loc5.passportId = _loc1.passportID;
				_loc5.passportCookie = _loc1.P00001;
			}
			else
			{
				_loc5.passportId = "";
				_loc5.passportCookie = "";
			}
			this._log.info("success to load pre adplayer: " + "cupId(" + _loc5.playerid + ")," + "hasNext(" + _loc5.hasNext + ")," + "adContext(" + _loc5.adContext + ")," + "adContext15(" + _loc5.adContext15 + ")," + "vipRight(" + _loc5.vipRight + "),");
			this._ADView.onPreInfoChanged(_loc5);
			this._ADView.onFullScreenChanged(GlobalStage.isFullScreen());
		}
		
		private function onLoadFailed(param1:ADEvent) : void
		{
			var _loc2:String = param1.data.tvid;
			var _loc3:String = param1.data.vid;
			this._log.warn("failed to load adplayer,tvid:" + _loc2 + ",vid:" + _loc3);
			ProcessesTimeRecord.needRecord = false;
			var _loc4:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4.curActor.loadMovieParams.tvid == _loc2 && _loc4.curActor.loadMovieParams.vid == _loc3)
			{
				this._log.warn("failed to load cur adplayer!");
				this.unloadAdPlayer();
				this.removeAllAdStatus();
				sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
				this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
				this.showSkipADTip();
			}
			else if(_loc4.preActor.loadMovieParams)
			{
				if(_loc4.preActor.loadMovieParams.tvid == _loc2 && _loc4.preActor.loadMovieParams.vid == _loc3)
				{
					this._log.warn("failed to load pre adplayer!");
					sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
					this._ADProxy.addStatus(ADDef.STATUS_PRE_FAILED);
				}
				else
				{
					this._log.error("failed to load adplayer,has error,tvid and vid is invalid!");
				}
			}
			else
			{
				this._log.error("failed to load adplayer,has error,loadMovieParams is null!");
			}
			
		}
		
		private function onStartPlay(param1:ADEvent) : void
		{
			var curDate:Date = null;
			var diff:Number = NaN;
			var event:ADEvent = param1;
			var tvid:String = event.data.tvid;
			var vid:String = event.data.vid;
			this._log.info("Adplayer start play ad,tvid:" + tvid + ",vid:" + vid);
			var playerProxy:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(playerProxy.curActor.loadMovieParams.tvid == tvid && playerProxy.curActor.loadMovieParams.vid == vid)
			{
				this._log.info("Adplayer start play cur ad!");
				if(ProcessesTimeRecord.usedTime_showVideo == 0)
				{
					ProcessesTimeRecord.usedTime_adInit = getTimer() - ProcessesTimeRecord.STime_adInit;
					ProcessesTimeRecord.usedTime_showVideo = getTimer() - ProcessesTimeRecord.STime_showVideo;
					if(FlashVarConfig.pageCTime > 0)
					{
						curDate = new Date();
						diff = curDate.getTime() - FlashVarConfig.pageCTime;
						if(diff > 0)
						{
							ProcessesTimeRecord.usedTime_pageShowVideo = diff;
						}
					}
				}
				if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
				{
					try
					{
						ExternalInterface.call("adStartPlay");
					}
					catch(error:Error)
					{
					}
				}
				this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
				this.onVolumeChanged();
				playerProxy.curActor.startLoadMeta();
				playerProxy.curActor.startLoadHistory();
				playerProxy.curActor.startLoadP2P();
				if((playerProxy.curActor.movieModel) && (playerProxy.curActor.movieModel.forceAD))
				{
					this.showCopyrightForceADTip();
				}
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_AD_PLAYING);
			}
			else
			{
				this._log.error("Adplayer start play pre ad!");
			}
		}
		
		private function onAskVideoPause(param1:ADEvent) : void
		{
			var _loc2:String = param1.data.tvid;
			var _loc3:String = param1.data.vid;
			this._log.info("ADPlayer ask Video Pause,tvid:" + _loc2 + ",vid:" + _loc3);
			var _loc4:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4.curActor.loadMovieParams.tvid == _loc2 && _loc4.curActor.loadMovieParams.vid == _loc3)
			{
				this._log.info("ADPlayer cur ask Video Pause!");
				this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
				PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
				this._ADView.onVolumeChanged(Settings.instance.mute?0:Settings.instance.volumn);
				sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
			}
			else
			{
				this._log.error("ADPlayer pre ask Video Pause!");
			}
		}
		
		private function onAskVideoResume(param1:ADEvent) : void
		{
			var _loc2:String = param1.data.tvid;
			var _loc3:String = param1.data.vid;
			this._log.info("Adplayer ask Video Resume,tvid:" + _loc2 + ",vid:" + _loc3);
			var _loc4:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4.curActor.loadMovieParams.tvid == _loc2 && _loc4.curActor.loadMovieParams.vid == _loc3)
			{
				this._log.info("Adplayer cur ask Video Resume!");
				this.onVolumeChanged();
				sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
				this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
			}
			else
			{
				this._log.error("Adplayer pre ask Video Resume!");
			}
		}
		
		private function onAskVideoStartLoad(param1:ADEvent) : void
		{
			var _loc2:String = param1.data.tvid;
			var _loc3:String = param1.data.vid;
			this._log.info("Adplayer ask Video StartLoad,tvid:" + _loc2 + ",vid:" + _loc3);
			var _loc4:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4.curActor.loadMovieParams.tvid == _loc2 && _loc4.curActor.loadMovieParams.vid == _loc3)
			{
				this._log.info("Adplayer cur ask Video StartLoad!");
				_loc4.curActor.setADRemainTime(int(param1.data.delay) * 1000);
				sendNotification(BodyDef.NOTIFIC_PLAYER_START_LOAD);
			}
			else if(_loc4.preActor.loadMovieParams)
			{
				if(_loc4.preActor.loadMovieParams.tvid == _loc2 && _loc4.preActor.loadMovieParams.vid == _loc3)
				{
					this._log.info("Adplayer pre ask Video StartLoad!");
					_loc4.preActor.setADRemainTime(int(param1.data.delay) * 1000);
					this._ADProxy.addStatus(ADDef.STATUS_PRE_SUCCESS);
					sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
				}
				else
				{
					this._log.error("Adplayer ask Video StartLoad,has error,tvid and vid is invalid!");
				}
			}
			else
			{
				this._log.error("Adplayer ask Video StartLoad,has error,loadMovieParams is null!");
			}
			
		}
		
		private function onAskVideoStartPlay(param1:ADEvent) : void
		{
			var _loc2:String = param1.data.tvid;
			var _loc3:String = param1.data.vid;
			var _loc4:Array = param1.data.viewPoints as Array;
			this._log.info("Adplayer ask Video StartPlay,tvid:" + _loc2 + ",vid:" + _loc3);
			var _loc5:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc5.curActor.loadMovieParams.tvid == _loc2 && _loc5.curActor.loadMovieParams.vid == _loc3)
			{
				this._log.info("Adplayer cur ask Video StartPlay!");
				this._ADProxy.setADViewPoints(_loc4);
				this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
				if(!_loc5.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
				{
					sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_READY);
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_START_PLAY);
					this.trySendSkipADPingBack();
					this.showSkipADTip();
					if(this._ADProxy.blocked)
					{
						this._log.info("Adplayer blocked,unload ad player on ask video start player!");
						this.unloadAdPlayer();
						this.removeAllAdStatus();
					}
				}
			}
			else
			{
				this._log.error("Adplayer pre ask Video StartPlay!");
			}
		}
		
		private function onAskVideoEnd(param1:ADEvent) : void
		{
			var _loc5:Object = null;
			var _loc2:String = param1.data.tvid;
			var _loc3:String = param1.data.vid;
			this._log.info("Adplayer ask Video VideoEnd,tvid:" + _loc2 + ",vid:" + _loc3);
			var _loc4:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc4.curActor.loadMovieParams.tvid == _loc2 && _loc4.curActor.loadMovieParams.vid == _loc3)
			{
				this._log.info("Adplayer cur Video VideoEnd!");
				_loc5 = new Object();
				_loc5.adDepot = this._ADView.adDepot;
				this._ADView.onSendNotific(_loc5);
				this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
			}
			else
			{
				this._log.error("Adplayer pre Video VideoEnd!");
			}
		}
		
		private function onAdBlock(param1:ADEvent) : void
		{
			var _loc2:String = param1.data.tvid;
			var _loc3:String = param1.data.vid;
			var _loc4:Boolean = param1.data.isCidErr;
			this._log.info("Adplayer ask AD Block,tvid:" + _loc2 + ",vid:" + _loc3 + ",isCidErr:" + _loc4);
			var _loc5:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			_loc5.invalid = _loc4;
			ProcessesTimeRecord.needRecord = false;
			if(_loc5.curActor.loadMovieParams.tvid == _loc2 && _loc5.curActor.loadMovieParams.vid == _loc3)
			{
				this._log.info("Adplayer cur AD Block!");
				this._ADProxy.blocked = true;
				this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_AD_PLAYING);
			}
			else if(_loc5.preActor.loadMovieParams)
			{
				if(_loc5.preActor.loadMovieParams.tvid == _loc2 && _loc5.preActor.loadMovieParams.vid == _loc3)
				{
					this._log.info("Adplayer pre AD Block!");
					this._ADProxy.addStatus(ADDef.STATUS_PRE_SUCCESS);
				}
				else
				{
					this._log.error("Adplayer ask AD Block,has error,tvid and vid is invalid!");
				}
			}
			else
			{
				this._log.error("Adplayer ask AD Block,has error,loadMovieParams is null!");
			}
			
		}
		
		private function onAdUnloaded(param1:ADEvent) : void
		{
			sendNotification(ADDef.NOTIFIC_AD_UNLOADED);
		}
		
		private function onVolumeChanged() : void
		{
			if((this._ADProxy.mute) || (Settings.instance.mute))
			{
				this._ADView.onVolumeChanged(0);
			}
			else
			{
				this._ADView.onVolumeChanged(Settings.instance.volumn);
			}
		}
		
		private function trySendSkipADPingBack() : void
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			if((_loc2.isLogin && !(_loc2.userLevel == UserDef.USER_LEVEL_NORMAL)) && (_loc1.curActor.movieModel) && !_loc1.curActor.movieModel.forceAD)
			{
				PingBack.getInstance().skipAD(_loc2.passportID,_loc1.curActor.uuid,_loc1.curActor.movieModel.tvid,_loc1.curActor.movieModel.albumId);
			}
		}
		
		private function onMouseMove(param1:MouseEvent) : void
		{
			if(this.checkDockShowStatus())
			{
				this._ADView.onDockShowChanged(true);
				TweenLite.killTweensOf(this.hideDock);
				TweenLite.delayedCall(ADDef.DOCK_HIND_DELAY / 1000,this.hideDock);
			}
		}
		
		private function hideDock() : void
		{
			this._ADView.onDockShowChanged(false);
		}
		
		private function checkDockShowStatus() : Boolean
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK) && _loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && (_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || _loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) || _loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) && !this._ADProxy.hasStatus(ADDef.STATUS_LOADING) && !this._ADProxy.hasStatus(ADDef.STATUS_PLAYING) && !this._ADProxy.hasStatus(ADDef.STATUS_PAUSED) && _loc1.curActor.movieModel) && (!(_loc1.curActor.movieModel.screenType == ScreenEnum.THREE_D)) && !_loc1.curActor.smallWindowMode)
			{
				return true;
			}
			return false;
		}
	}
}
