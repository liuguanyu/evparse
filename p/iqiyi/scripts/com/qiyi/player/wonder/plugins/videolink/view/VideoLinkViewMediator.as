package com.qiyi.player.wonder.plugins.videolink.view {
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
	
	public class VideoLinkViewMediator extends Mediator {
		
		public function VideoLinkViewMediator(param1:VideoLinkView) {
			super(NAME,param1);
			this._videoLinkView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.videolink.view.VideoLinkViewMediator";
		
		private var _videoLinkProxy:VideoLinkProxy;
		
		private var _videoLinkView:VideoLinkView;
		
		private var _noticeID:String = "";
		
		override public function onRegister() : void {
			super.onRegister();
			this._videoLinkProxy = facade.retrieveProxy(VideoLinkProxy.NAME) as VideoLinkProxy;
			this._videoLinkView.addEventListener(VideoLinkEvent.Evt_Open,this.onVideoLinkViewOpen);
			this._videoLinkView.addEventListener(VideoLinkEvent.Evt_Close,this.onVideoLinkViewClose);
			this._videoLinkView.addEventListener(VideoLinkEvent.Evt_BtnAndIconClick,this.onWatchVideoLinkBtnClick);
		}
		
		override public function listNotificationInterests() : Array {
			return [ADDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_PLAYER_STUCK,BodyDef.NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,ContinuePlayDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_REMOVE_STATUS,ControllBarDef.NOTIFIC_ADD_STATUS,ControllBarDef.NOTIFIC_REMOVE_STATUS,SceneTileDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc5_:PlayerProxy = null;
			var _loc6_:VideoLinkInfo = null;
			var _loc7_:ADProxy = null;
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case VideoLinkDef.NOTIFIC_ADD_STATUS:
					this._videoLinkView.onAddStatus(int(_loc2_));
					break;
				case VideoLinkDef.NOTIFIC_REMOVE_STATUS:
					_loc5_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					_loc6_ = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(_loc5_.curActor.currentTime / 1000));
					if(_loc6_ == null && int(_loc2_) == VideoLinkDef.STATUS_OPEN) {
						this._videoLinkProxy.resetIsShow();
					}
					this._videoLinkView.onRemoveStatus(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._videoLinkView.onResize(_loc2_.w,_loc2_.h);
					if(!GlobalStage.isFullScreen() && this._videoLinkView.panelType == VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE) {
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this.onPlayerSwitchPreActor();
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2_.currentTime,_loc2_.bufferTime,_loc2_.duration,_loc2_.playingDuration);
					break;
				case BodyDef.NOTIFIC_PLAYER_STUCK:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerStuck();
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO:
					this.onReceiveActivityNotice(_loc2_);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					if(Boolean(_loc2_)) {
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case ContinuePlayDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == ContinuePlayDef.STATUS_OPEN) {
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
					break;
				case ControllBarDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW) {
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case ControllBarDef.NOTIFIC_REMOVE_STATUS:
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					_loc7_ = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
					if((_loc7_.hasStatus(ADDef.STATUS_LOADING)) || (_loc7_.hasStatus(ADDef.STATUS_PLAYING)) || (_loc7_.hasStatus(ADDef.STATUS_PAUSED))) {
						this._videoLinkView.visible = false;
					}
					break;
				case SceneTileDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == SceneTileDef.STATUS_SCORE_OPEN) {
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
			}
		}
		
		private function onVideoLinkViewOpen(param1:VideoLinkEvent) : void {
			if(!this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN)) {
				this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function onVideoLinkViewClose(param1:VideoLinkEvent) : void {
			if(this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN)) {
				this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						TweenLite.killTweensOf(this.onWaitingTimeOut);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
					if(param2) {
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2) {
						this.getVideoLinkInfo();
					}
					break;
				case BodyDef.PLAYER_STATUS_WAITING:
					if(param2) {
						TweenLite.delayedCall(VideoLinkDef.WAITING_TIME / 1000,this.onWaitingTimeOut);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2) {
						TweenLite.killTweensOf(this.onWaitingTimeOut);
						this._videoLinkView.visible = true;
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2) {
						TweenLite.killTweensOf(this.onWaitingTimeOut);
					}
					break;
			}
		}
		
		private function onPlayerSwitchPreActor() : void {
			this.getVideoLinkInfo();
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void {
			var _loc5_:VideoLinkInfo = null;
			var _loc6_:PlayerProxy = null;
			if((this._videoLinkProxy.isHasLink) && !SwitchManager.getInstance().getStatus(SwitchDef.ID_HIDE_VIDEO_LINK)) {
				_loc5_ = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(param1 / 1000));
				if(_loc5_) {
					_loc6_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(!_loc5_.isShow && !_loc6_.curActor.smallWindowMode) {
						this._videoLinkProxy.resetIsShow();
						_loc5_.isShow = true;
						this._videoLinkView.initVideoLinkPanel(VideoLinkDef.PANEL_TYPE_VIDEOLINK,_loc5_);
						PingBack.getInstance().videoLinkShowPing();
						this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
					}
				} else {
					this._videoLinkProxy.resetIsShow();
					if(this._videoLinkView.panelType == VideoLinkDef.PANEL_TYPE_VIDEOLINK) {
						this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
					}
				}
			}
		}
		
		private function onPlayerStuck() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((this._videoLinkProxy.lagDownClient(VideoLinkDef.LAG_TIME_SWAP_PRO_ACCELERATE)) && !_loc1_.curActor.smallWindowMode) {
				PingBack.getInstance().playerActionPing(PingBackDef.SHOW_DOWNLOAD_ACC_TIPS);
				this._videoLinkView.initClientDownloadPanel(VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT);
				this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function onWaitingTimeOut() : void {
			TweenLite.killTweensOf(this.onWaitingTimeOut);
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(!this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY)) && !_loc1_.curActor.smallWindowMode && !_loc2_.hasStatus(ADDef.STATUS_PLAYING) && !_loc2_.hasStatus(ADDef.STATUS_PAUSED) && !_loc2_.hasStatus(ADDef.STATUS_LOADING)) {
				PingBack.getInstance().playerActionPing(PingBackDef.SHOW_DOWNLOAD_ACC_TIPS);
				this._videoLinkView.initClientDownloadPanel(VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT);
				this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function onReceiveActivityNotice(param1:Object) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((!this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN) && GlobalStage.isFullScreen() && _loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !_loc2_.curActor.smallWindowMode && !_loc3_.hasStatus(ADDef.STATUS_PLAYING) && !_loc3_.hasStatus(ADDef.STATUS_PAUSED) && !_loc3_.hasStatus(ADDef.STATUS_LOADING)) && (param1.activityContent) && (param1.linkUrl)) {
				this._noticeID = param1.noticeid;
				PingBack.getInstance().noticeShowActionPing_4_0(PingBackDef.ACTIVITY_NOTICE_PANEL_SHOW,this._noticeID);
				this._videoLinkView.initActivityNoticePanel(VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE,param1.activityContent,param1.linkUrl);
				this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
			}
		}
		
		private function getVideoLinkInfo() : void {
			var _loc3_:Object = null;
			var _loc4_:VideoLinkInfo = null;
			var _loc5_:Object = null;
			TweenLite.killTweensOf(this.onWaitingTimeOut);
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:Vector.<VideoLinkInfo> = new Vector.<VideoLinkInfo>();
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)) {
				_loc3_ = _loc1_.curActor.movieInfo.infoJSON;
				if(_loc3_.tpl != undefined) {
					for each(_loc5_ in _loc3_.tpl as Array) {
						if(!(_loc5_.tp == undefined) && _loc5_.tp == 2) {
							_loc4_ = new VideoLinkInfo(_loc5_);
							_loc2_.push(_loc4_);
						}
					}
				}
			}
			this._videoLinkProxy.addVideoLinkInfo(_loc2_);
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
			this._videoLinkView.onUserInfoChanged(_loc2_);
		}
		
		private function onWatchVideoLinkBtnClick(param1:VideoLinkEvent) : void {
			var _loc2_:PlayerProxy = null;
			var _loc3_:VideoLinkInfo = null;
			switch(this._videoLinkView.panelType) {
				case VideoLinkDef.PANEL_TYPE_VIDEOLINK:
					_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					_loc3_ = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(_loc2_.curActor.currentTime / 1000));
					if(_loc3_) {
						GlobalStage.setNormalScreen();
						sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
						PingBack.getInstance().videoLinkUserClickPing();
						navigateToURL(new URLRequest(_loc3_.titleUrl),"_blank");
					}
					break;
				case VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT:
					GlobalStage.setNormalScreen();
					PingBack.getInstance().userActionPing(PingBackDef.CLICK_DOWNLOAD_ACC_TIPS);
					if(Capabilities.version.indexOf("WIN") == 0) {
						navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_FULL),"_blank");
					} else {
						navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_MAC),"_blank");
					}
					break;
				case VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE:
					GlobalStage.setNormalScreen();
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
					PingBack.getInstance().noticeUserActionPing_4_0(PingBackDef.ACTIVITY_NOTICE_PANEL_CLICK,this._noticeID);
					if(this._videoLinkView.activityNoticeLink != "") {
						navigateToURL(new URLRequest(this._videoLinkView.activityNoticeLink),"_blank");
					}
					break;
			}
		}
		
		private function checkIsShowVideoLink(param1:VideoLinkInfo) : Boolean {
			var _loc2_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc3_:ControllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
			if((param1 && !param1.isShow) && (!_loc2_.hasStatus(ContinuePlayDef.STATUS_OPEN)) && !_loc3_.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW)) {
				return true;
			}
			return false;
		}
	}
}
