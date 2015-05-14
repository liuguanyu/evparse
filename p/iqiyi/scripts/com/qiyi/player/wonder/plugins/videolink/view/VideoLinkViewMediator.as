package com.qiyi.player.wonder.plugins.videolink.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.videolink.model.VideoLinkProxy;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.plugins.videolink.model.VideoLinkInfo;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.iqiyi.components.global.GlobalStage;
	import gs.TweenLite;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy;
	
	public class VideoLinkViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.videolink.view.VideoLinkViewMediator";
		
		private var _videoLinkProxy:VideoLinkProxy;
		
		private var _videoLinkView:VideoLinkView;
		
		private var _noticeID:String = "";
		
		public function VideoLinkViewMediator(param1:VideoLinkView)
		{
			super(NAME,param1);
			this._videoLinkView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._videoLinkProxy = facade.retrieveProxy(VideoLinkProxy.NAME) as VideoLinkProxy;
			this._videoLinkView.addEventListener(VideoLinkEvent.Evt_Open,this.onVideoLinkViewOpen);
			this._videoLinkView.addEventListener(VideoLinkEvent.Evt_Close,this.onVideoLinkViewClose);
			this._videoLinkView.addEventListener(VideoLinkEvent.Evt_BtnAndIconClick,this.onWatchVideoLinkBtnClick);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [ADDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_PLAYER_STUCK,BodyDef.NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,ContinuePlayDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_REMOVE_STATUS,ControllBarDef.NOTIFIC_ADD_STATUS,ControllBarDef.NOTIFIC_REMOVE_STATUS,SceneTileDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			var _loc5:PlayerProxy = null;
			var _loc6:VideoLinkInfo = null;
			var _loc7:ADProxy = null;
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case VideoLinkDef.NOTIFIC_ADD_STATUS:
					this._videoLinkView.onAddStatus(int(_loc2));
					break;
				case VideoLinkDef.NOTIFIC_REMOVE_STATUS:
					_loc5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					_loc6 = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(_loc5.curActor.currentTime / 1000));
					if(_loc6 == null && int(_loc2) == VideoLinkDef.STATUS_OPEN)
					{
						this._videoLinkProxy.resetIsShow();
					}
					this._videoLinkView.onRemoveStatus(int(_loc2));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._videoLinkView.onResize(_loc2.w,_loc2.h);
					if(!GlobalStage.isFullScreen() && this._videoLinkView.panelType == VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE)
					{
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this.onPlayerSwitchPreActor();
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2.currentTime,_loc2.bufferTime,_loc2.duration,_loc2.playingDuration);
					break;
				case BodyDef.NOTIFIC_PLAYER_STUCK:
					if(_loc4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
					{
						this.onPlayerStuck();
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO:
					this.onReceiveActivityNotice(_loc2);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					if(Boolean(_loc2))
					{
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case ContinuePlayDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == ContinuePlayDef.STATUS_OPEN)
					{
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
					break;
				case ControllBarDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW)
					{
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case ControllBarDef.NOTIFIC_REMOVE_STATUS:
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					_loc7 = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
					if((_loc7.hasStatus(ADDef.STATUS_LOADING)) || (_loc7.hasStatus(ADDef.STATUS_PLAYING)) || (_loc7.hasStatus(ADDef.STATUS_PAUSED)))
					{
						this._videoLinkView.visible = false;
					}
					break;
				case SceneTileDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == SceneTileDef.STATUS_SCORE_OPEN)
					{
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
			}
		}
		
		private function onVideoLinkViewOpen(param1:VideoLinkEvent) : void
		{
			if(!this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN))
			{
				this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function onVideoLinkViewClose(param1:VideoLinkEvent) : void
		{
			if(this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN))
			{
				this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
		{
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
			{
				return;
			}
			switch(param1)
			{
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2)
					{
						TweenLite.killTweensOf(this.onWaitingTimeOut);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
					if(param2)
					{
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2)
					{
						this.getVideoLinkInfo();
					}
					break;
				case BodyDef.PLAYER_STATUS_WAITING:
					if(param2)
					{
						TweenLite.delayedCall(VideoLinkDef.WAITING_TIME / 1000,this.onWaitingTimeOut);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2)
					{
						TweenLite.killTweensOf(this.onWaitingTimeOut);
						this._videoLinkView.visible = true;
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2)
					{
						TweenLite.killTweensOf(this.onWaitingTimeOut);
					}
					break;
			}
		}
		
		private function onPlayerSwitchPreActor() : void
		{
			this.getVideoLinkInfo();
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void
		{
			var _loc5:VideoLinkInfo = null;
			var _loc6:PlayerProxy = null;
			if((this._videoLinkProxy.isHasLink) && !SwitchManager.getInstance().getStatus(SwitchDef.ID_HIDE_VIDEO_LINK))
			{
				_loc5 = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(param1 / 1000));
				if(_loc5)
				{
					_loc6 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(!_loc5.isShow && !_loc6.curActor.smallWindowMode)
					{
						this._videoLinkProxy.resetIsShow();
						_loc5.isShow = true;
						this._videoLinkView.initVideoLinkPanel(VideoLinkDef.PANEL_TYPE_VIDEOLINK,_loc5);
						PingBack.getInstance().videoLinkShowPing();
						this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
					}
				}
				else
				{
					this._videoLinkProxy.resetIsShow();
					if(this._videoLinkView.panelType == VideoLinkDef.PANEL_TYPE_VIDEOLINK)
					{
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
				}
			}
		}
		
		private function onPlayerStuck() : void
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((this._videoLinkProxy.lagDownClient(VideoLinkDef.LAG_TIME_SWAP_PRO_ACCELERATE)) && !_loc1.curActor.smallWindowMode)
			{
				PingBack.getInstance().playerActionPing(PingBackDef.SHOW_DOWNLOAD_ACC_TIPS);
				this._videoLinkView.initClientDownloadPanel(VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT);
				this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function onWaitingTimeOut() : void
		{
			TweenLite.killTweensOf(this.onWaitingTimeOut);
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(!this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN) && (_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY)) && !_loc1.curActor.smallWindowMode && !_loc2.hasStatus(ADDef.STATUS_PLAYING) && !_loc2.hasStatus(ADDef.STATUS_PAUSED) && !_loc2.hasStatus(ADDef.STATUS_LOADING))
			{
				PingBack.getInstance().playerActionPing(PingBackDef.SHOW_DOWNLOAD_ACC_TIPS);
				this._videoLinkView.initClientDownloadPanel(VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT);
				this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function onReceiveActivityNotice(param1:Object) : void
		{
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((!this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN) && GlobalStage.isFullScreen() && _loc2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !_loc2.curActor.smallWindowMode && !_loc3.hasStatus(ADDef.STATUS_PLAYING) && !_loc3.hasStatus(ADDef.STATUS_PAUSED) && !_loc3.hasStatus(ADDef.STATUS_LOADING)) && (param1.activityContent) && (param1.linkUrl))
			{
				this._noticeID = param1.noticeid;
				PingBack.getInstance().noticeShowActionPing_4_0(PingBackDef.ACTIVITY_NOTICE_PANEL_SHOW,this._noticeID);
				this._videoLinkView.initActivityNoticePanel(VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE,param1.activityContent,param1.linkUrl);
				this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function getVideoLinkInfo() : void
		{
			var _loc3:Object = null;
			var _loc4:VideoLinkInfo = null;
			var _loc5:Object = null;
			TweenLite.killTweensOf(this.onWaitingTimeOut);
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:Vector.<VideoLinkInfo> = new Vector.<VideoLinkInfo>();
			if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
			{
				_loc3 = _loc1.curActor.movieInfo.infoJSON;
				if(_loc3.tpl != undefined)
				{
					for each(_loc5 in _loc3.tpl as Array)
					{
						if(!(_loc5.tp == undefined) && _loc5.tp == 2)
						{
							_loc4 = new VideoLinkInfo(_loc5);
							_loc2.push(_loc4);
						}
					}
				}
			}
			this._videoLinkProxy.addVideoLinkInfo(_loc2);
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
			this._videoLinkView.onUserInfoChanged(_loc2);
		}
		
		private function onWatchVideoLinkBtnClick(param1:VideoLinkEvent) : void
		{
			var _loc2:PlayerProxy = null;
			var _loc3:VideoLinkInfo = null;
			switch(this._videoLinkView.panelType)
			{
				case VideoLinkDef.PANEL_TYPE_VIDEOLINK:
					_loc2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					_loc3 = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(_loc2.curActor.currentTime / 1000));
					if(_loc3)
					{
						GlobalStage.setNormalScreen();
						sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
						PingBack.getInstance().videoLinkUserClickPing();
						navigateToURL(new URLRequest(_loc3.titleUrl),"_blank");
					}
					break;
				case VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT:
					GlobalStage.setNormalScreen();
					PingBack.getInstance().userActionPing(PingBackDef.CLICK_DOWNLOAD_ACC_TIPS);
					if(Capabilities.version.indexOf("WIN") == 0)
					{
						navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_FULL),"_blank");
					}
					else
					{
						navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_MAC),"_blank");
					}
					break;
				case VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE:
					GlobalStage.setNormalScreen();
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
					PingBack.getInstance().noticeUserActionPing_4_0(PingBackDef.ACTIVITY_NOTICE_PANEL_CLICK,this._noticeID);
					if(this._videoLinkView.activityNoticeLink != "")
					{
						navigateToURL(new URLRequest(this._videoLinkView.activityNoticeLink),"_blank");
					}
					break;
			}
		}
		
		private function checkIsShowVideoLink(param1:VideoLinkInfo) : Boolean
		{
			var _loc2:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc3:ControllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
			if((param1 && !param1.isShow) && (!_loc2.hasStatus(ContinuePlayDef.STATUS_OPEN)) && !_loc3.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW))
			{
				return true;
			}
			return false;
		}
	}
}
