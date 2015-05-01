package com.qiyi.player.wonder.plugins.feedback.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.feedback.model.FeedbackProxy;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.plugins.feedback.FeedbackDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.core.model.utils.LogManager;
	import com.qiyi.player.wonder.plugins.feedback.model.FeedbackInfo;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.wonder.WonderVersion;
	import com.qiyi.player.user.impls.UserManager;
	import com.qiyi.player.user.IUser;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.wonder.common.lso.LSO;
	import flash.system.Capabilities;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.base.logging.Log;
	
	public class FeedbackViewMediator extends Mediator {
		
		public function FeedbackViewMediator(param1:FeedbackView) {
			this._log = Log.getLogger(NAME);
			super(NAME,param1);
			this._feedbackView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.feedback.view.FeedbackViewMediator";
		
		private var _feedbackProxy:FeedbackProxy;
		
		private var _feedbackView:FeedbackView;
		
		private var _log:ILogger;
		
		private var _privateVideoTvid:String = "";
		
		override public function onRegister() : void {
			super.onRegister();
			this._feedbackProxy = facade.retrieveProxy(FeedbackProxy.NAME) as FeedbackProxy;
			this._feedbackView.addEventListener(FeedbackEvent.Evt_Open,this.onFeedbackViewOpen);
			this._feedbackView.addEventListener(FeedbackEvent.Evt_Close,this.onFeedbackViewClose);
			this._feedbackView.addEventListener(FeedbackEvent.Evt_Refresh,this.onFeedbackRefresh);
			this._feedbackView.addEventListener(FeedbackEvent.Evt_DownloadBtnClick,this.onDownClientBtnClick);
			this._feedbackView.addEventListener(FeedbackEvent.Evt_PrivateNestVideo,this.onNestVideoLink);
			this._feedbackView.addEventListener(FeedbackEvent.Evt_PrivateConfirmBtnClick,this.onConfirmBtnClick);
			this._feedbackView.addEventListener(FeedbackEvent.Evt_SkipMemberAuthBtnClick,this.onSkipMemberAuthBtnClick);
		}
		
		override public function listNotificationInterests() : Array {
			return [FeedbackDef.NOTIFIC_ADD_STATUS,FeedbackDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_CHECK_USER_COMPLETE];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc5_:PlayerProxy = null;
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case FeedbackDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == FeedbackDef.STATUS_OPEN) {
						this.initFeedbackView();
					}
					this._feedbackView.onAddStatus(int(_loc2_));
					break;
				case FeedbackDef.NOTIFIC_REMOVE_STATUS:
					this._feedbackView.onRemoveStatus(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._feedbackView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					_loc5_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(!_loc5_.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) {
						this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
					}
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
			}
		}
		
		private function onFeedbackViewOpen(param1:FeedbackEvent) : void {
			if(!this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN)) {
				this._feedbackProxy.addStatus(FeedbackDef.STATUS_OPEN);
			}
		}
		
		private function onFeedbackViewClose(param1:FeedbackEvent) : void {
			if(this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN)) {
				this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			var _loc4_:PlayerProxy = null;
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2) {
						this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2) {
						_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						if((_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) && (this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))) {
							this._feedbackView.videoName = _loc4_.curActor.movieInfo.title;
						}
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
			this._feedbackView.onUserInfoChanged(_loc2_);
		}
		
		private function initFeedbackView() : void {
			var _loc8_:* = false;
			var _loc9_:String = null;
			var _loc10_:String = null;
			var _loc11_:String = null;
			var _loc12_:String = null;
			var _loc13_:String = null;
			var _loc14_:String = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc3_:String = (_loc1_.curActor.movieModel) && (_loc1_.curActor.movieInfo)?_loc1_.curActor.movieModel.vid:"";
			var _loc4_:String = (_loc1_.curActor.movieModel) && (_loc1_.curActor.movieInfo)?_loc1_.curActor.movieInfo.title:"";
			var _loc5_:String = LogManager.getLifeLogs().length <= 0?"log file is empty":LogManager.getLifeLogs().join("<br />");
			var _loc6_:String = (_loc1_.curActor.movieModel) && (_loc1_.curActor.movieInfo)?_loc1_.curActor.movieModel.channelID.toString():"";
			FeedbackInfo.instance.updataVideoInfo("fault",_loc3_,_loc4_,Settings.instance.volumn,_loc5_,WonderVersion.VERSION_WONDER,_loc6_);
			var _loc7_:IUser = UserManager.getInstance().user;
			if((_loc7_) && _loc7_.limitationType == UserDef.USER_LIMITATION_UPPER) {
				if(FlashVarConfig.isMemberMovie) {
					PingBack.getInstance().showActionPing_4_0(PingBackDef.CONCUR_LIMIT_VIP_SHOW);
				} else {
					PingBack.getInstance().showActionPing_4_0(PingBackDef.CONCUR_LIMIT_SHOW);
				}
				this._feedbackView.createConcurrencyLimit(FlashVarConfig.isMemberMovie);
			} else if(_loc1_.curActor.errorCode == 707 || FlashVarConfig.vid == "") {
				this._feedbackView.createMaliceErrorView();
			} else if(_loc1_.curActor.errorCode == 5000) {
				this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_AREA);
			} else if(_loc1_.curActor.errorCode == 708 || _loc1_.curActor.errorCode == 709) {
				_loc8_ = false;
				if((_loc2_.isContinue) && (_loc1_.curActor.loadMovieParams) && (_loc2_.findNextContinueInfo(_loc1_.curActor.loadMovieParams.tvid,_loc1_.curActor.loadMovieParams.vid))) {
					_loc8_ = true;
				}
				this._feedbackView.createPrivatevideo(_loc1_.curActor.errorCode,_loc8_,this._privateVideoTvid == _loc1_.curActor.loadMovieParams.tvid);
				this._privateVideoTvid = _loc1_.curActor.loadMovieParams.tvid;
			} else if((_loc1_.curActor.errorCode == 104) && (_loc1_.curActor.errorCodeValue) && (_loc1_.curActor.errorCodeValue.st)) {
				_loc9_ = "";
				if(_loc1_.curActor.errorCodeValue.hasOwnProperty("cid")) {
					_loc9_ = _loc9_ + _loc1_.curActor.errorCodeValue.cid;
				}
				_loc10_ = "";
				if(_loc1_.curActor.errorCodeValue.hasOwnProperty("tvid")) {
					_loc10_ = _loc10_ + _loc1_.curActor.errorCodeValue.tvid;
				}
				_loc11_ = "";
				if(_loc1_.curActor.errorCodeValue.hasOwnProperty("aid")) {
					_loc11_ = _loc11_ + _loc1_.curActor.errorCodeValue.aid;
				}
				_loc12_ = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
				_loc13_ = SystemConfig.RECOMMEND_URL + "area=" + SystemConfig.COPY_RIGHT_AREA + "&referenceId=" + _loc10_ + "&channelId=" + _loc9_ + "&albumId=" + _loc11_ + "&page=1" + "&type=video" + "&withRefer=true" + "&profileId=" + _loc12_ + "&size=20";
				_loc14_ = "";
				if((_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)) && (_loc1_.curActor.movieInfo)) {
					_loc14_ = _loc1_.curActor.movieInfo.title;
				}
				if(int(_loc1_.curActor.errorCodeValue.st) == 405 || int(_loc1_.curActor.errorCodeValue.st) == 406 || int(_loc1_.curActor.errorCodeValue.st) == 401) {
					this._feedbackView.createCopyrightExpiredView(_loc13_,true,_loc14_);
				} else if(int(_loc1_.curActor.errorCodeValue.st) == 304) {
					this._feedbackView.createCopyrightExpiredView(_loc13_,false,_loc14_);
				} else if(_loc1_.curActor.errorCodeValue.st == 501) {
					this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_PLATFORM);
				} else if(_loc1_.curActor.errorCodeValue.st == 502) {
					this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_AREA);
				} else {
					this.createNetworkFaultView();
				}
				
				
				
			} else {
				this.createNetworkFaultView();
			}
			
			
			
			
		}
		
		private function onFeedbackRefresh(param1:FeedbackEvent) : void {
			if(this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN)) {
				this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
			}
			sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
		}
		
		private function onDownClientBtnClick(param1:FeedbackEvent) : void {
			GlobalStage.setNormalScreen();
			PingBack.getInstance().userActionPing(PingBackDef.DOWNLOAD_CLIENT);
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:IMovieModel = _loc2_.curActor.movieModel;
			if(_loc3_) {
				LSO.getInstance().setClientFlashInfo([{
					"tvid":_loc3_.tvid,
					"vid":_loc3_.vid,
					"curtime":_loc2_.curActor.currentTime.toString(),
					"albumid":_loc3_.albumId.toString(),
					"definition":_loc3_.curDefinitionInfo.type.id.toString(),
					"member":_loc3_.member.toString()
				}]);
			}
			if(Capabilities.version.indexOf("WIN") == 0) {
				navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_FEEDBACK),"_blank");
			} else {
				navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_MAC),"_blank");
			}
		}
		
		private function onNestVideoLink(param1:FeedbackEvent) : void {
			if(this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN)) {
				this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
			}
			sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
		}
		
		private function onConfirmBtnClick(param1:FeedbackEvent) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			_loc2_.curActor.ugcAuthKey = String(param1.data);
			if(this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN)) {
				this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
			}
			sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
		}
		
		private function onSkipMemberAuthBtnClick(param1:FeedbackEvent) : void {
			sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
		}
		
		private function createNetworkFaultView() : void {
			this._feedbackView.createNetWorkFaultView();
		}
	}
}
