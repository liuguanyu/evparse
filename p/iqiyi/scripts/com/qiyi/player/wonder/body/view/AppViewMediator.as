package com.qiyi.player.wonder.body.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.qiyi.player.base.logging.ILogger;
	import flash.ui.ContextMenu;
	import com.qiyi.player.wonder.WonderVersion;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.iqiyi.components.global.GlobalStage;
	import com.iqiyi.components.global.ICustomStage;
	import flash.events.ContextMenuEvent;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.plugins.dock.DockDef;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	import com.qiyi.player.wonder.plugins.loading.LoadingDef;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchDef;
	import com.qiyi.player.wonder.plugins.recommend.RecommendDef;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.plugins.share.ShareDef;
	import com.qiyi.player.wonder.plugins.tips.TipsDef;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.core.model.impls.FocusTip;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.user.IUser;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.core.model.def.ChannelEnum;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.wonder.plugins.tips.model.TipsProxy;
	import com.qiyi.player.wonder.common.status.IStatus;
	import com.qiyi.player.wonder.plugins.tips.TipsPlugins;
	import com.qiyi.player.wonder.plugins.tips.view.TipsViewMediator;
	import com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarPlugins;
	import com.qiyi.player.wonder.plugins.controllbar.view.ControllBarViewMediator;
	import com.qiyi.player.wonder.plugins.dock.model.DockProxy;
	import com.qiyi.player.wonder.plugins.dock.DockPlugins;
	import com.qiyi.player.wonder.plugins.dock.view.DockViewMediator;
	import com.qiyi.player.wonder.plugins.feedback.model.FeedbackProxy;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackPlugins;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackViewMediator;
	import com.qiyi.player.wonder.plugins.loading.model.LoadingProxy;
	import com.qiyi.player.wonder.plugins.loading.LoadingPlugins;
	import com.qiyi.player.wonder.plugins.loading.view.LoadingViewMediator;
	import com.qiyi.player.wonder.plugins.offlinewatch.model.OfflineWatchProxy;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchPlugins;
	import com.qiyi.player.wonder.plugins.offlinewatch.view.OfflineWatchViewMediator;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy;
	import com.qiyi.player.wonder.plugins.recommend.RecommendPlugins;
	import com.qiyi.player.wonder.plugins.recommend.view.RecommendViewMediator;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTilePlugins;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileToolViewMediator;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileBarrageViewMediator;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileScoreViewMediator;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileStreamLimitViewMediator;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import com.qiyi.player.wonder.plugins.setting.SettingPlugins;
	import com.qiyi.player.wonder.plugins.setting.view.SettingViewMediator;
	import com.qiyi.player.wonder.plugins.setting.view.FilterViewMediator;
	import com.qiyi.player.wonder.plugins.setting.view.DefinitionViewMediator;
	import com.qiyi.player.wonder.plugins.share.model.ShareProxy;
	import com.qiyi.player.wonder.plugins.share.SharePlugins;
	import com.qiyi.player.wonder.plugins.share.view.ShareViewMediator;
	import com.qiyi.player.wonder.plugins.topbar.model.TopBarProxy;
	import com.qiyi.player.wonder.plugins.topbar.TopBarPlugins;
	import com.qiyi.player.wonder.plugins.topbar.view.TopBarViewMediator;
	import com.qiyi.player.wonder.plugins.videolink.model.VideoLinkProxy;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkPlugins;
	import com.qiyi.player.wonder.plugins.videolink.view.VideoLinkViewMediator;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.wonder.plugins.ad.ADPlugins;
	import com.qiyi.player.wonder.plugins.ad.view.ADViewMediator;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayPlugins;
	import com.qiyi.player.wonder.plugins.continueplay.view.ContinuePlayViewMediator;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import flash.ui.ContextMenuItem;
	import com.qiyi.player.core.Version;
	import com.qiyi.player.core.video.def.VideoAccEnum;
	import flash.system.System;
	import com.qiyi.player.base.logging.Log;
	
	public class AppViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.body.view.AppViewMediator";
		
		private var _appView:AppView;
		
		private var _playerProxy:PlayerProxy;
		
		private var _userProxy:UserProxy;
		
		private var _javascriptAPIProxy:JavascriptAPIProxy;
		
		private var _log:ILogger;
		
		private var _isNoticeJSCollectionGoods:Boolean = false;
		
		public function AppViewMediator(param1:AppView)
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.body.view.AppViewMediator");
			super(NAME,param1);
			this._appView = param1;
		}
		
		override public function onRegister() : void
		{
			var key:String = null;
			var cm:ContextMenu = null;
			super.onRegister();
			this._log.info("wonder version : " + WonderVersion.VERSION_WONDER);
			var flashVarLog:String = "Flash Vars:";
			for(key in FlashVarConfig.flashVarSource)
			{
				flashVarLog = flashVarLog + (", " + key + " = " + FlashVarConfig.flashVarSource[key]);
			}
			this._log.info(flashVarLog);
			this._playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			this._userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			this._javascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
			{
				GlobalStage.initCustomStage(this._playerProxy.curActor.corePlayer as ICustomStage);
			}
			this._appView.addEventListener(BodyEvent.Evt_StageResize,this.onStageResize);
			this._appView.addEventListener(BodyEvent.Evt_FullScreen,this.onFullScreen);
			this._appView.addEventListener(BodyEvent.Evt_LeaveStage,this.onLeaveStage);
			this._appView.addEventListener(BodyEvent.Evt_MouseLayerClick,this.onMouseLayerClick);
			this._appView.addEventListener(BodyEvent.Evt_MouseLayerDoubleClick,this.onMouseLayerDoubleClick);
			this.checkInitTipsPluginsView();
			this.checkInitControllBarPluginsView();
			this.checkInitDockPluginsView();
			this.checkInitFeedbackPluginsView();
			this.checkInitLoadingPluginsView();
			this.checkInitOfflineWatchPluginsView();
			this.checkInitRecommendPluginsView();
			this.checkInitSceneTilePluginsToolView();
			this.checkInitBarragePluginsView();
			this.checkInitScorePluginsView();
			this.checkInitStreamLimitPluginsView();
			this.checkInitSettingPluginsView();
			this.checkInitFilterPluginsView();
			this.checkInitDefinitionPluginsView();
			this.checkInitSharePluginsView();
			this.checkInitTopBarPluginsView();
			this.checkInitVideoLinkPluginsView();
			this.checkInitADPluginsView();
			this.checkInitContinuePlayPluginsView();
			try
			{
				cm = new ContextMenu();
				cm.hideBuiltInItems();
				cm.addEventListener(ContextMenuEvent.MENU_SELECT,this.onOpenMenu);
				this._appView.contextMenu = cm;
			}
			catch(error:Error)
			{
			}
		}
		
		override public function listNotificationInterests() : Array
		{
			return [BodyDef.NOTIFIC_REQUEST_INIT_PLAYER,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_PLAYER_UPDATE_OVER_BONUS,BodyDef.NOTIFIC_PLAYER_REPLAYED,BodyDef.NOTIFIC_PLAYER_TO_FOCUS_TIP,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,BodyDef.NOTIFIC_PLAYER_ARRIVE_TRYWATCH_TIME,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,ADDef.NOTIFIC_ADD_STATUS,ADDef.NOTIFIC_REMOVE_STATUS,ContinuePlayDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_REMOVE_STATUS,ControllBarDef.NOTIFIC_ADD_STATUS,ControllBarDef.NOTIFIC_REMOVE_STATUS,DockDef.NOTIFIC_ADD_STATUS,DockDef.NOTIFIC_REMOVE_STATUS,FeedbackDef.NOTIFIC_ADD_STATUS,FeedbackDef.NOTIFIC_REMOVE_STATUS,LoadingDef.NOTIFIC_ADD_STATUS,LoadingDef.NOTIFIC_REMOVE_STATUS,OfflineWatchDef.NOTIFIC_ADD_STATUS,OfflineWatchDef.NOTIFIC_REMOVE_STATUS,RecommendDef.NOTIFIC_ADD_STATUS,RecommendDef.NOTIFIC_REMOVE_STATUS,SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.NOTIFIC_REMOVE_STATUS,SettingDef.NOTIFIC_ADD_STATUS,SettingDef.NOTIFIC_REMOVE_STATUS,ShareDef.NOTIFIC_ADD_STATUS,ShareDef.NOTIFIC_REMOVE_STATUS,TipsDef.NOTIFIC_ADD_STATUS,TipsDef.NOTIFIC_REMOVE_STATUS,TopBarDef.NOTIFIC_ADD_STATUS,TopBarDef.NOTIFIC_REMOVE_STATUS,VideoLinkDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_REMOVE_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			var _loc5:UserProxy = null;
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case BodyDef.NOTIFIC_REQUEST_INIT_PLAYER:
					sendNotification(BodyDef.NOTIFIC_INIT_PLAYER,this._appView);
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS:
					this.onPlayerStatusChanged(int(_loc2),false,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this.onPlayerSwitchPreActor();
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2.currentTime,_loc2.bufferTime,_loc2.duration,_loc2.playingDuration);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					this._playerProxy.preActor.smallWindowMode = this._playerProxy.curActor.smallWindowMode = _loc2;
					this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					if(this._playerProxy.curActor.smallWindowMode)
					{
						PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_ARRIVE_TRYWATCH_TIME:
					GlobalStage.setNormalScreen();
					this._javascriptAPIProxy.callJsRecharge("Q00304");
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
					break;
				case BodyDef.NOTIFIC_PLAYER_UPDATE_OVER_BONUS:
					if(_loc4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
						{
							_loc5 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
							_loc5.savePlayOverBonus(this._playerProxy.curActor.playingDuration,int(_loc2));
						}
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_REPLAYED:
					if(_loc4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						this.sendPlayListPing();
						this._userProxy.bonusCompleted = false;
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_TO_FOCUS_TIP:
					this._javascriptAPIProxy.callJsFocusTips(FocusTip(_loc2).timestamp);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2),true);
					break;
				case ADDef.NOTIFIC_REMOVE_STATUS:
					this.onADStatusChanged(int(_loc2),false);
					break;
				case ContinuePlayDef.NOTIFIC_ADD_STATUS:
					this.onContinuePlayStatusChanged(int(_loc2),true);
					break;
				case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
					this.onContinuePlayStatusChanged(int(_loc2),false);
					break;
				case ControllBarDef.NOTIFIC_ADD_STATUS:
					this.onControllBarStatusChanged(int(_loc2),true);
					break;
				case ControllBarDef.NOTIFIC_REMOVE_STATUS:
					this.onControllBarStatusChanged(int(_loc2),false);
					break;
				case DockDef.NOTIFIC_ADD_STATUS:
					this.onDockStatusChanged(int(_loc2),true);
					break;
				case DockDef.NOTIFIC_REMOVE_STATUS:
					this.onDockStatusChanged(int(_loc2),false);
					break;
				case FeedbackDef.NOTIFIC_ADD_STATUS:
					this.onFeedbackStatusChanged(int(_loc2),true);
					break;
				case FeedbackDef.NOTIFIC_REMOVE_STATUS:
					this.onFeedbackStatusChanged(int(_loc2),false);
					break;
				case LoadingDef.NOTIFIC_ADD_STATUS:
					this.onLoadingStatusChanged(int(_loc2),true);
					break;
				case LoadingDef.NOTIFIC_REMOVE_STATUS:
					this.onLoadingStatusChanged(int(_loc2),false);
					break;
				case OfflineWatchDef.NOTIFIC_ADD_STATUS:
					this.onOfflineWatchStatusChanged(int(_loc2),true);
					break;
				case OfflineWatchDef.NOTIFIC_REMOVE_STATUS:
					this.onOfflineWatchStatusChanged(int(_loc2),false);
					break;
				case RecommendDef.NOTIFIC_ADD_STATUS:
					this.onRecommendStatusChanged(int(_loc2),true);
					break;
				case RecommendDef.NOTIFIC_REMOVE_STATUS:
					this.onRecommendStatusChanged(int(_loc2),false);
					break;
				case SceneTileDef.NOTIFIC_ADD_STATUS:
					this.onSceneTileStatusChanged(int(_loc2),true);
					break;
				case SceneTileDef.NOTIFIC_REMOVE_STATUS:
					this.onSceneTileStatusChanged(int(_loc2),false);
					break;
				case SettingDef.NOTIFIC_ADD_STATUS:
					this.onSettingStatusChanged(int(_loc2),true);
					break;
				case SettingDef.NOTIFIC_REMOVE_STATUS:
					this.onSettingStatusChanged(int(_loc2),false);
					break;
				case ShareDef.NOTIFIC_ADD_STATUS:
					this.onShareStatusChanged(int(_loc2),true);
					break;
				case ShareDef.NOTIFIC_REMOVE_STATUS:
					this.onShareStatusChanged(int(_loc2),false);
					break;
				case TipsDef.NOTIFIC_ADD_STATUS:
					this.onTipsStatusChanged(int(_loc2),true);
					break;
				case TipsDef.NOTIFIC_REMOVE_STATUS:
					this.onTipsStatusChanged(int(_loc2),false);
					break;
				case TopBarDef.NOTIFIC_ADD_STATUS:
					this.onTopBarStatusChanged(int(_loc2),true);
					break;
				case TopBarDef.NOTIFIC_REMOVE_STATUS:
					this.onTopBarStatusChanged(int(_loc2),false);
					break;
				case VideoLinkDef.NOTIFIC_ADD_STATUS:
					this.onVideoLinkStatusChanged(int(_loc2),true);
					break;
				case VideoLinkDef.NOTIFIC_REMOVE_STATUS:
					this.onVideoLinkStatusChanged(int(_loc2),false);
					break;
			}
		}
		
		private function onResize(param1:int, param2:int) : void
		{
			var _loc3:int = (GlobalStage.isFullScreen()) || (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE)) || (this._playerProxy.curActor.smallWindowMode)?param2:param2 - BodyDef.VIDEO_BOTTOM_RESERVE;
			this._playerProxy.curActor.setArea(0,0,param1,_loc3);
			this._playerProxy.preActor.setArea(0,0,param1,_loc3);
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
		{
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
			{
				return;
			}
			var _loc4:IUser = UserManager.getInstance().user;
			switch(param1)
			{
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if((param2) && (_loc4))
					{
						_loc4.tvid = this._playerProxy.curActor.loadMovieParams.tvid;
						_loc4.closeHeartBeat();
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2)
					{
						if((this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
						{
							this._isNoticeJSCollectionGoods = false;
							this._userProxy.bonusCompleted = false;
							if(this._playerProxy.curActor.movieModel.member)
							{
								this._javascriptAPIProxy.callJsAuthenticationResult(this._playerProxy.curActor.isTryWatch);
							}
							this.sendPlayListPing();
							sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_DATA_READY);
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_LOAD_COMPLETE:
					if(param2)
					{
						this._javascriptAPIProxy.callJsLoadComplete();
					}
					break;
				case BodyDef.PLAYER_STATUS_SEEKING:
					if(param2)
					{
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_SEEKING);
					}
					break;
				case BodyDef.PLAYER_STATUS_WAITING:
					if(param2)
					{
						if(_loc4)
						{
							_loc4.closeHeartBeat();
						}
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_WAITING);
					}
					break;
				case BodyDef.PLAYER_STATUS_PAUSED:
					if(param2)
					{
						if(_loc4)
						{
							_loc4.closeHeartBeat();
						}
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_PAUSED);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2)
					{
						if(_loc4)
						{
							_loc4.openHeartBeat();
						}
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_PLAYING);
						PingBack.getInstance().sendVideoStart();
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPED:
					if(param2)
					{
						if(_loc4)
						{
							_loc4.closeHeartBeat();
						}
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_STOPED);
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2)
					{
						if(_loc4)
						{
							_loc4.closeHeartBeat();
						}
						this.showError();
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
					if(param2)
					{
					}
					break;
			}
		}
		
		private function onPlayerSwitchPreActor() : void
		{
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
			{
				GlobalStage.initCustomStage(this._playerProxy.curActor.corePlayer as ICustomStage);
			}
			var _loc1:IUser = UserManager.getInstance().user;
			if((_loc1) && (this._playerProxy.curActor.loadMovieParams))
			{
				_loc1.tvid = this._playerProxy.curActor.loadMovieParams.tvid;
			}
			this._appView.switchPreLayer();
			if((this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)))
			{
				this._isNoticeJSCollectionGoods = false;
				this._userProxy.bonusCompleted = false;
				if(this._playerProxy.curActor.movieModel.member)
				{
					this._javascriptAPIProxy.callJsAuthenticationResult(this._playerProxy.curActor.isTryWatch);
				}
				sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_DATA_READY);
			}
			if(this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
			{
				this.showError();
			}
			this.sendPlayListPing();
		}
		
		private function showError() : void
		{
			if((this._playerProxy.curActor.authenticationError) && (this._playerProxy.curActor.authenticationResult))
			{
				try
				{
					GlobalStage.setNormalScreen();
				}
				catch(error:Error)
				{
				}
				this._javascriptAPIProxy.callJsRecharge(this._playerProxy.curActor.authenticationResult.code);
			}
			else
			{
				sendNotification(FeedbackDef.NOTIFIC_OPEN_CLOSE,true);
			}
			sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_ERROR);
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void
		{
			var _loc6:* = NaN;
			var _loc5:SceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
			{
				this._userProxy.saveOneMinusBonus(param4);
			}
			if(!_loc5.isScored && !this._playerProxy.curActor.smallWindowMode && this._playerProxy.curActor.movieModel.channelID == ChannelEnum.FILM.id && param4 >= SceneTileDef.SCORE_PLAYING_DURATION)
			{
				if(!_loc5.isOpenAtMidway && param1 >= param3 * SceneTileDef.SCORE_PLAYING_POINT - 500 && param1 <= param3 * SceneTileDef.SCORE_PLAYING_POINT + 500)
				{
					_loc5.isOpenAtMidway = true;
					sendNotification(SceneTileDef.NOTIFIC_OPEN_CLOSE_SCORE);
				}
				if(!_loc5.isOpenAtFinish && param1 >= param3 - SceneTileDef.SCORE_PLAYING_END_POINT - 500 && param1 <= param3 - SceneTileDef.SCORE_PLAYING_END_POINT + 500)
				{
					_loc5.isOpenAtFinish = true;
					sendNotification(SceneTileDef.NOTIFIC_OPEN_CLOSE_SCORE);
				}
			}
			if((Settings.instance.skipTrailer) && this._playerProxy.curActor.movieModel.trailerTime > 0)
			{
				_loc6 = this._playerProxy.curActor.movieModel.trailerTime;
			}
			else
			{
				_loc6 = param3;
			}
			if(!this._isNoticeJSCollectionGoods && param3 > 30 * 1000 && _loc6 - param1 <= 30 * 1000)
			{
				this._isNoticeJSCollectionGoods = true;
				this._javascriptAPIProxy.callJsDoSomething(BodyDef.JS_DOSAMETHING_SHOW_COLLECTION_GOODS);
			}
		}
		
		private function checkInitTipsPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(TipsProxy.NAME) as IStatus;
			if(_loc1.hasStatus(TipsDef.STATUS_VIEW_INIT))
			{
				TipsPlugins.getInstance().initView(this._appView.fixSub1Layer,Vector.<String>([TipsViewMediator.NAME]));
			}
		}
		
		private function checkInitControllBarPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(ControllBarProxy.NAME) as IStatus;
			if(_loc1.hasStatus(ControllBarDef.STATUS_VIEW_INIT))
			{
				ControllBarPlugins.getInstance().initView(this._appView.fixLayer,Vector.<String>([ControllBarViewMediator.NAME]));
			}
		}
		
		private function checkInitDockPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(DockProxy.NAME) as IStatus;
			if(_loc1.hasStatus(DockDef.STATUS_VIEW_INIT))
			{
				DockPlugins.getInstance().initView(this._appView.fixLayer,Vector.<String>([DockViewMediator.NAME]));
			}
		}
		
		private function checkInitFeedbackPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(FeedbackProxy.NAME) as IStatus;
			if(_loc1.hasStatus(FeedbackDef.STATUS_VIEW_INIT))
			{
				FeedbackPlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([FeedbackViewMediator.NAME]));
			}
		}
		
		private function checkInitLoadingPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(LoadingProxy.NAME) as IStatus;
			if(_loc1.hasStatus(LoadingDef.STATUS_VIEW_INIT))
			{
				LoadingPlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([LoadingViewMediator.NAME]));
			}
		}
		
		private function checkInitOfflineWatchPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(OfflineWatchProxy.NAME) as IStatus;
			if(_loc1.hasStatus(OfflineWatchDef.STATUS_VIEW_INIT))
			{
				OfflineWatchPlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([OfflineWatchViewMediator.NAME]));
			}
		}
		
		private function checkInitRecommendPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(RecommendProxy.NAME) as IStatus;
			if(_loc1.hasStatus(RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT))
			{
				RecommendPlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([RecommendViewMediator.NAME]));
			}
		}
		
		private function checkInitSceneTilePluginsToolView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(SceneTileProxy.NAME) as IStatus;
			if(_loc1.hasStatus(SceneTileDef.STATUS_TOOL_VIEW_INIT))
			{
				SceneTilePlugins.getInstance().initView(this._appView.sceneTileToolLayer,Vector.<String>([SceneTileToolViewMediator.NAME]));
			}
		}
		
		private function checkInitBarragePluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(SceneTileProxy.NAME) as IStatus;
			if(_loc1.hasStatus(SceneTileDef.STATUS_BARRAGE_VIEW_INIT))
			{
				SceneTilePlugins.getInstance().initView(this._appView.barrageLayer,Vector.<String>([SceneTileBarrageViewMediator.NAME]));
			}
		}
		
		private function checkInitScorePluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(SceneTileProxy.NAME) as IStatus;
			if(_loc1.hasStatus(SceneTileDef.STATUS_SCORE_VIEW_INIT))
			{
				SceneTilePlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([SceneTileScoreViewMediator.NAME]));
			}
		}
		
		private function checkInitStreamLimitPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(SceneTileProxy.NAME) as IStatus;
			if(_loc1.hasStatus(SceneTileDef.STATUS_STREAM_LIMIT_VIEW_INIT))
			{
				SceneTilePlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([SceneTileStreamLimitViewMediator.NAME]));
			}
		}
		
		private function checkInitSettingPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(SettingProxy.NAME) as IStatus;
			if(_loc1.hasStatus(SettingDef.STATUS_VIEW_INIT))
			{
				SettingPlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([SettingViewMediator.NAME]));
			}
		}
		
		private function checkInitFilterPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(SettingProxy.NAME) as IStatus;
			if(_loc1.hasStatus(SettingDef.STATUS_FILTER_VIEW_INIT))
			{
				SettingPlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([FilterViewMediator.NAME]));
			}
		}
		
		private function checkInitDefinitionPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(SettingProxy.NAME) as IStatus;
			if(_loc1.hasStatus(SettingDef.STATUS_DEFINITION_VIEW_INIT))
			{
				SettingPlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([DefinitionViewMediator.NAME]));
			}
		}
		
		private function checkInitSharePluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(ShareProxy.NAME) as IStatus;
			if(_loc1.hasStatus(ShareDef.STATUS_VIEW_INIT))
			{
				SharePlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([ShareViewMediator.NAME]));
			}
		}
		
		private function checkInitTopBarPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(TopBarProxy.NAME) as IStatus;
			if(_loc1.hasStatus(TopBarDef.STATUS_VIEW_INIT))
			{
				TopBarPlugins.getInstance().initView(this._appView.fixLayer,Vector.<String>([TopBarViewMediator.NAME]));
			}
		}
		
		private function checkInitVideoLinkPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(VideoLinkProxy.NAME) as IStatus;
			if(_loc1.hasStatus(VideoLinkDef.STATUS_VIEW_INIT))
			{
				VideoLinkPlugins.getInstance().initView(this._appView.popupLayer,Vector.<String>([VideoLinkViewMediator.NAME]));
			}
		}
		
		private function checkInitADPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(ADProxy.NAME) as IStatus;
			if(_loc1.hasStatus(ADDef.STATUS_VIEW_INIT))
			{
				ADPlugins.getInstance().initView(this._appView.ADLayer,Vector.<String>([ADViewMediator.NAME]));
			}
		}
		
		private function checkInitContinuePlayPluginsView() : void
		{
			var _loc1:IStatus = facade.retrieveProxy(ContinuePlayProxy.NAME) as IStatus;
			if(_loc1.hasStatus(ContinuePlayDef.STATUS_VIEW_INIT))
			{
				ContinuePlayPlugins.getInstance().initView(this._appView.fixLayer,Vector.<String>([ContinuePlayViewMediator.NAME]));
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case ADDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitADPluginsView();
					}
					break;
			}
		}
		
		private function onContinuePlayStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case ContinuePlayDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitContinuePlayPluginsView();
					}
					break;
			}
		}
		
		private function onControllBarStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case ControllBarDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitControllBarPluginsView();
					}
					break;
			}
		}
		
		private function onDockStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case DockDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitDockPluginsView();
					}
					break;
			}
		}
		
		private function onFeedbackStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case FeedbackDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitFeedbackPluginsView();
					}
					break;
			}
		}
		
		private function onLoadingStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case LoadingDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitLoadingPluginsView();
					}
					break;
			}
		}
		
		private function onOfflineWatchStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case OfflineWatchDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitOfflineWatchPluginsView();
					}
					break;
			}
		}
		
		private function onRecommendStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT:
					if(param2)
					{
						this.checkInitRecommendPluginsView();
					}
					break;
			}
		}
		
		private function onSceneTileStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case SceneTileDef.STATUS_TOOL_VIEW_INIT:
					if(param2)
					{
						this.checkInitSceneTilePluginsToolView();
					}
					break;
				case SceneTileDef.STATUS_BARRAGE_VIEW_INIT:
					if(param2)
					{
						this.checkInitBarragePluginsView();
					}
					break;
				case SceneTileDef.STATUS_SCORE_VIEW_INIT:
					if(param2)
					{
						this.checkInitScorePluginsView();
					}
					break;
				case SceneTileDef.STATUS_STREAM_LIMIT_VIEW_INIT:
					if(param2)
					{
						this.checkInitStreamLimitPluginsView();
					}
					break;
			}
		}
		
		private function onSettingStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case SettingDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitSettingPluginsView();
					}
					break;
				case SettingDef.STATUS_DEFINITION_VIEW_INIT:
					if(param2)
					{
						this.checkInitDefinitionPluginsView();
					}
					break;
				case SettingDef.STATUS_FILTER_VIEW_INIT:
					if(param2)
					{
						this.checkInitFilterPluginsView();
					}
					break;
			}
		}
		
		private function onShareStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case ShareDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitSharePluginsView();
					}
					break;
			}
		}
		
		private function onTipsStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case TipsDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitTipsPluginsView();
					}
					break;
			}
		}
		
		private function onTopBarStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case TopBarDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitTopBarPluginsView();
					}
					break;
			}
		}
		
		private function onVideoLinkStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case VideoLinkDef.STATUS_VIEW_INIT:
					if(param2)
					{
						this.checkInitVideoLinkPluginsView();
					}
					break;
			}
		}
		
		private function onStageResize(param1:BodyEvent) : void
		{
			sendNotification(BodyDef.NOTIFIC_RESIZE,{
				"w":GlobalStage.stage.stageWidth,
				"h":GlobalStage.stage.stageHeight
			});
		}
		
		private function onFullScreen(param1:BodyEvent) : void
		{
			if(Boolean(param1.data))
			{
				PingBack.getInstance().userActionPing(PingBackDef.FULL_SCREEN,this._playerProxy.curActor.currentTime);
			}
			this._javascriptAPIProxy.callJsSwitchFullScreen(Boolean(param1.data));
			sendNotification(BodyDef.NOTIFIC_FULL_SCREEN,param1.data);
		}
		
		private function onLeaveStage(param1:BodyEvent) : void
		{
			sendNotification(BodyDef.NOTIFIC_LEAVE_STAGE);
		}
		
		private function onMouseLayerClick(param1:BodyEvent) : void
		{
			if(this._playerProxy.curActor.smallWindowMode)
			{
				return;
			}
			sendNotification(BodyDef.NOTIFIC_MOUSE_LAYER_CLICK);
		}
		
		private function onMouseLayerDoubleClick(param1:BodyEvent) : void
		{
			if(this._playerProxy.curActor.smallWindowMode)
			{
				return;
			}
			if(!GlobalStage.isFullScreen())
			{
				GlobalStage.setFullScreen();
			}
			else
			{
				GlobalStage.setNormalScreen();
			}
		}
		
		private function onOpenMenu(param1:ContextMenuEvent) : void
		{
			var cm:ContextMenu = null;
			var wonderMenuItem:ContextMenuItem = null;
			var kernelVersion:String = null;
			var coreMenuItem:ContextMenuItem = null;
			var copyVideoSwfUrl:ContextMenuItem = null;
			var copyVideoHtmlUrl:ContextMenuItem = null;
			var isShowCopyUrl:Boolean = false;
			var videoInfoMenuItem:ContextMenuItem = null;
			var GPUMenuItem:ContextMenuItem = null;
			var adMenuItem:ContextMenuItem = null;
			var event:ContextMenuEvent = param1;
			try
			{
				cm = this._appView.contextMenu;
				cm.customItems = [];
				wonderMenuItem = new ContextMenuItem("iQiyiPlayer " + WonderVersion.VERSION_WONDER + "-" + WonderVersion.VERSION_AD_PLUGINS);
				cm.customItems.push(wonderMenuItem);
				kernelVersion = "Kernel " + Version.VERSION;
				if(Version.VERSION_FLASH_P2P)
				{
					kernelVersion = kernelVersion + ("_" + Version.VERSION_FLASH_P2P);
				}
				coreMenuItem = new ContextMenuItem(kernelVersion);
				cm.customItems.push(coreMenuItem);
				if(WonderVersion.VERSION_AD_PLAYER)
				{
					adMenuItem = new ContextMenuItem(WonderVersion.VERSION_AD_PLAYER);
					cm.customItems.push(adMenuItem);
				}
				copyVideoSwfUrl = new ContextMenuItem("复制视频swf地址",true);
				copyVideoSwfUrl.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onCopyVideoSwfUrl);
				copyVideoHtmlUrl = new ContextMenuItem("复制视频html地址");
				copyVideoHtmlUrl.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onCopyVideoHtmlUrl);
				isShowCopyUrl = true;
				if((this._playerProxy.curActor && this._playerProxy.curActor.movieInfo && this._playerProxy.curActor.movieInfo.infoJSON && this._playerProxy.curActor.movieInfo.infoJSON.plc && this._playerProxy.curActor.movieInfo.infoJSON.plc[14]) && (!(this._playerProxy.curActor.movieInfo.infoJSON.plc[14].coa == 1)) || this._playerProxy.curActor.getSwfUrl() == "")
				{
					isShowCopyUrl = false;
				}
				if(isShowCopyUrl)
				{
					cm.customItems.push(copyVideoSwfUrl);
					cm.customItems.push(copyVideoHtmlUrl);
				}
				videoInfoMenuItem = new ContextMenuItem("显示视频信息",true);
				videoInfoMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onToggleVideoInfo);
				cm.customItems.push(videoInfoMenuItem);
				GPUMenuItem = null;
				if(this._playerProxy.curActor.accStatus == VideoAccEnum.GPU_ACCELERATED || this._playerProxy.curActor.accStatus == VideoAccEnum.GPU_RENDERING)
				{
					GPUMenuItem = new ContextMenuItem("关闭硬件加速");
				}
				else
				{
					GPUMenuItem = new ContextMenuItem("尝试开启硬件加速");
				}
				GPUMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.onSettingGPU);
				GPUMenuItem.enabled = true;
				cm.customItems.push(GPUMenuItem);
				this._appView.contextMenu = cm;
			}
			catch(error:Error)
			{
			}
		}
		
		private function onToggleVideoInfo(param1:ContextMenuEvent) : void
		{
			this._playerProxy.curActor.floatLayer.toggleVideoInfo();
		}
		
		private function onSettingGPU(param1:ContextMenuEvent) : void
		{
			Settings.instance.useGPU = !Settings.instance.useGPU;
		}
		
		private function onCopyVideoSwfUrl(param1:ContextMenuEvent) : void
		{
			System.setClipboard(this._playerProxy.curActor.getSwfUrl());
		}
		
		private function onCopyVideoHtmlUrl(param1:ContextMenuEvent) : void
		{
			System.setClipboard(this._playerProxy.curActor.getHtmlUrl());
		}
		
		private function sendPlayListPing() : void
		{
			if(FlashVarConfig.isFloatPlayer != "")
			{
				PingBack.getInstance().floatPlayerPing();
			}
			if(FlashVarConfig.isheadmap != "")
			{
				PingBack.getInstance().headmapPing();
			}
		}
		
		private function onCheckUserComplete() : void
		{
			var _loc1:IUser = UserManager.getInstance().user;
			if((this._userProxy.isLogin) && (_loc1) && (this._playerProxy.curActor.loadMovieParams))
			{
				_loc1.tvid = this._playerProxy.curActor.loadMovieParams.tvid;
				if(this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING))
				{
					_loc1.openHeartBeat();
				}
			}
		}
	}
}
