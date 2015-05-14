package com.qiyi.player.wonder.plugins.feedback.view
{
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
	
	public class FeedbackViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.feedback.view.FeedbackViewMediator";
		
		private var _feedbackProxy:FeedbackProxy;
		
		private var _feedbackView:FeedbackView;
		
		private var _log:ILogger;
		
		private var _privateVideoTvid:String = "";
		
		public function FeedbackViewMediator(param1:FeedbackView)
		{
			this._log = Log.getLogger(NAME);
			super(NAME,param1);
			this._feedbackView = param1;
		}
		
		override public function onRegister() : void
		{
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
		
		override public function listNotificationInterests() : Array
		{
			return [FeedbackDef.NOTIFIC_ADD_STATUS,FeedbackDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_CHECK_USER_COMPLETE];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			var _loc5:PlayerProxy = null;
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			switch(_loc3)
			{
				case FeedbackDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == FeedbackDef.STATUS_OPEN)
					{
						this.initFeedbackView();
					}
					this._feedbackView.onAddStatus(int(_loc2));
					break;
				case FeedbackDef.NOTIFIC_REMOVE_STATUS:
					this._feedbackView.onRemoveStatus(int(_loc2));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._feedbackView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					_loc5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(!_loc5.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
					{
						this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
					}
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
			}
		}
		
		private function onFeedbackViewOpen(param1:FeedbackEvent) : void
		{
			if(!this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
			{
				this._feedbackProxy.addStatus(FeedbackDef.STATUS_OPEN);
			}
		}
		
		private function onFeedbackViewClose(param1:FeedbackEvent) : void
		{
			if(this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
			{
				this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
		{
			var _loc4:PlayerProxy = null;
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
			{
				return;
			}
			switch(param1)
			{
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2)
					{
						this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2)
					{
						this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2)
					{
						_loc4 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						if((_loc4.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) && (this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN)))
						{
							this._feedbackView.videoName = _loc4.curActor.movieInfo.title;
						}
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
			this._feedbackView.onUserInfoChanged(_loc2);
		}
		
		private function initFeedbackView() : void
		{
			var _loc8:* = false;
			var _loc9:String = null;
			var _loc10:String = null;
			var _loc11:String = null;
			var _loc12:String = null;
			var _loc13:String = null;
			var _loc14:String = null;
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc3:String = (_loc1.curActor.movieModel) && (_loc1.curActor.movieInfo)?_loc1.curActor.movieModel.vid:"";
			var _loc4:String = (_loc1.curActor.movieModel) && (_loc1.curActor.movieInfo)?_loc1.curActor.movieInfo.title:"";
			var _loc5:String = LogManager.getLifeLogs().length <= 0?"log file is empty":LogManager.getLifeLogs().join("<br />");
			var _loc6:String = (_loc1.curActor.movieModel) && (_loc1.curActor.movieInfo)?_loc1.curActor.movieModel.channelID.toString():"";
			FeedbackInfo.instance.updataVideoInfo("fault",_loc3,_loc4,Settings.instance.volumn,_loc5,WonderVersion.VERSION_WONDER,_loc6);
			var _loc7:IUser = UserManager.getInstance().user;
			if((_loc7) && _loc7.limitationType == UserDef.USER_LIMITATION_UPPER)
			{
				if(FlashVarConfig.isMemberMovie)
				{
					PingBack.getInstance().showActionPing_4_0(PingBackDef.CONCUR_LIMIT_VIP_SHOW);
				}
				else
				{
					PingBack.getInstance().showActionPing_4_0(PingBackDef.CONCUR_LIMIT_SHOW);
				}
				this._feedbackView.createConcurrencyLimit(FlashVarConfig.isMemberMovie);
			}
			else if(_loc1.curActor.errorCode == 707 || FlashVarConfig.vid == "")
			{
				this._feedbackView.createMaliceErrorView();
			}
			else if(_loc1.curActor.errorCode == 5000)
			{
				this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_AREA);
			}
			else if(_loc1.curActor.errorCode == 708 || _loc1.curActor.errorCode == 709)
			{
				_loc8 = false;
				if((_loc2.isContinue) && (_loc1.curActor.loadMovieParams) && (_loc2.findNextContinueInfo(_loc1.curActor.loadMovieParams.tvid,_loc1.curActor.loadMovieParams.vid)))
				{
					_loc8 = true;
				}
				this._feedbackView.createPrivatevideo(_loc1.curActor.errorCode,_loc8,this._privateVideoTvid == _loc1.curActor.loadMovieParams.tvid);
				this._privateVideoTvid = _loc1.curActor.loadMovieParams.tvid;
			}
			else if((_loc1.curActor.errorCode == 104) && (_loc1.curActor.errorCodeValue) && (_loc1.curActor.errorCodeValue.st))
			{
				_loc9 = "";
				if(_loc1.curActor.errorCodeValue.hasOwnProperty("cid"))
				{
					_loc9 = _loc9 + _loc1.curActor.errorCodeValue.cid;
				}
				_loc10 = "";
				if(_loc1.curActor.errorCodeValue.hasOwnProperty("tvid"))
				{
					_loc10 = _loc10 + _loc1.curActor.errorCodeValue.tvid;
				}
				_loc11 = "";
				if(_loc1.curActor.errorCodeValue.hasOwnProperty("aid"))
				{
					_loc11 = _loc11 + _loc1.curActor.errorCodeValue.aid;
				}
				_loc12 = UserManager.getInstance().user?UserManager.getInstance().user.profileID:"";
				_loc13 = SystemConfig.RECOMMEND_URL + "area=" + SystemConfig.COPY_RIGHT_AREA + "&referenceId=" + _loc10 + "&channelId=" + _loc9 + "&albumId=" + _loc11 + "&page=1" + "&type=video" + "&withRefer=true" + "&profileId=" + _loc12 + "&size=20";
				_loc14 = "";
				if((_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)) && (_loc1.curActor.movieInfo))
				{
					_loc14 = _loc1.curActor.movieInfo.title;
				}
				if(int(_loc1.curActor.errorCodeValue.st) == 405 || int(_loc1.curActor.errorCodeValue.st) == 406 || int(_loc1.curActor.errorCodeValue.st) == 401)
				{
					this._feedbackView.createCopyrightExpiredView(_loc13,true,_loc14);
				}
				else if(int(_loc1.curActor.errorCodeValue.st) == 304)
				{
					this._feedbackView.createCopyrightExpiredView(_loc13,false,_loc14);
				}
				else if(_loc1.curActor.errorCodeValue.st == 501)
				{
					this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_PLATFORM);
				}
				else if(_loc1.curActor.errorCodeValue.st == 502)
				{
					this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_AREA);
				}
				else
				{
					this.createNetworkFaultView();
				}
				
				
				
			}
			else
			{
				this.createNetworkFaultView();
			}
			
			
			
			
		}
		
		private function onFeedbackRefresh(param1:FeedbackEvent) : void
		{
			if(this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
			{
				this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
			}
			sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
		}
		
		private function onDownClientBtnClick(param1:FeedbackEvent) : void
		{
			GlobalStage.setNormalScreen();
			PingBack.getInstance().userActionPing(PingBackDef.DOWNLOAD_CLIENT);
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:IMovieModel = _loc2.curActor.movieModel;
			if(_loc3)
			{
				LSO.getInstance().setClientFlashInfo([{
					"tvid":_loc3.tvid,
					"vid":_loc3.vid,
					"curtime":_loc2.curActor.currentTime.toString(),
					"albumid":_loc3.albumId.toString(),
					"definition":_loc3.curDefinitionInfo.type.id.toString(),
					"member":_loc3.member.toString()
				}]);
			}
			if(Capabilities.version.indexOf("WIN") == 0)
			{
				navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_FEEDBACK),"_blank");
			}
			else
			{
				navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_MAC),"_blank");
			}
		}
		
		private function onNestVideoLink(param1:FeedbackEvent) : void
		{
			if(this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
			{
				this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
			}
			sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
		}
		
		private function onConfirmBtnClick(param1:FeedbackEvent) : void
		{
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			_loc2.curActor.ugcAuthKey = String(param1.data);
			if(this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
			{
				this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
			}
			sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
		}
		
		private function onSkipMemberAuthBtnClick(param1:FeedbackEvent) : void
		{
			sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
		}
		
		private function createNetworkFaultView() : void
		{
			this._feedbackView.createNetWorkFaultView();
		}
	}
}
