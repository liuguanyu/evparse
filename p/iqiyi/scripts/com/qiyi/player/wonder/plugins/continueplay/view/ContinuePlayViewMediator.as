package com.qiyi.player.wonder.plugins.continueplay.view
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.base.logging.ILogger;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.player.LoadMovieParams;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinueInfo;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.wonder.plugins.recommend.RecommendDef;
	import gs.TweenLite;
	import com.qiyi.player.base.pub.ProcessesTimeRecord;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.base.logging.Log;
	
	public class ContinuePlayViewMediator extends Mediator
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.continueplay.view.ContinuePlayViewMediator";
		
		private var _continuePlayProxy:ContinuePlayProxy;
		
		private var _continuePlayView:ContinuePlayView;
		
		private var _log:ILogger;
		
		public function ContinuePlayViewMediator(param1:ContinuePlayView)
		{
			this._log = Log.getLogger(NAME);
			super(NAME,param1);
			this._continuePlayView = param1;
		}
		
		override public function onRegister() : void
		{
			super.onRegister();
			this._continuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_Open,this.onContinuePlayViewOpen);
			this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_Close,this.onContinuePlayViewClose);
			this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_ListItemClick,this.onListItemClick);
			this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_ArrowClick,this.onArrowClick);
			this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_SwitchPageTriggerRequest,this.onPageTriggerRequest);
			this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_SwitchOverPage,this.onSwitchOverPage);
			this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_SwitchOverPageDone,this.onSwitchOverPageDone);
		}
		
		override public function listNotificationInterests() : Array
		{
			return [ContinuePlayDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE,BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO,BodyDef.NOTIFIC_JS_CALL_SWITCH_VIDEO,BodyDef.NOTIFIC_JS_CALL_SWITCH_NEXT_VIDEO,BodyDef.NOTIFIC_JS_CALL_SWITCH_PRE_VIDEO,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_JS_CALL_SET_CYCLE_PLAY,BodyDef.NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,ADDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO,ContinuePlayDef.NOTIFIC_REQUEST_PRE_VIDEO,ContinuePlayDef.NOTIFIC_REQUEST_SWITCH_VIDEO,ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED,ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE,SceneTileDef.NOTIFIC_REMOVE_STATUS,SettingDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_ADD_STATUS,ControllBarDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void
		{
			super.handleNotification(param1);
			var _loc2:Object = param1.getBody();
			var _loc3:String = param1.getName();
			var _loc4:String = param1.getType();
			var _loc5:PlayerProxy = null;
			var _loc6:LoadMovieParams = null;
			var _loc7:ContinueInfo = null;
			switch(_loc3)
			{
				case ContinuePlayDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == ContinuePlayDef.STATUS_OPEN)
					{
						_loc5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						this.requestVideoList(_loc5.curActor.loadMovieParams.tvid,_loc5.curActor.loadMovieParams.vid);
						this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(),true,this._continuePlayProxy.hasPreNeedLoad,this._continuePlayProxy.hasNextNeedLoad);
						this._continuePlayView.updateOpenView();
						this._continuePlayView.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
						this.onOpenDelayedCloseDock();
					}
					this._continuePlayView.onAddStatus(int(_loc2));
					break;
				case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
					if(int(_loc2) == ContinuePlayDef.STATUS_OPEN)
					{
						this._continuePlayView.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
					}
					this._continuePlayView.onRemoveStatus(int(_loc2));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._continuePlayView.onResize(_loc2.w,_loc2.h);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					if(!Boolean(_loc2) && FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
					{
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					}
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:
					this._continuePlayProxy.isContinue = Boolean(_loc2);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:
					this._continuePlayProxy.isJSContinue = Boolean(_loc2.continuePlay);
					this._continuePlayProxy.JSContinueTitle = _loc2.nextVideoTitle;
					break;
				case BodyDef.NOTIFIC_JS_CALL_SWITCH_VIDEO:
					_loc5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					_loc6 = _loc5.curActor.loadMovieParams;
					if(_loc6 == null || (_loc6) && (!(_loc6.vid == _loc2.vid)))
					{
						_loc7 = this._continuePlayProxy.findContinueInfo(_loc2.tvid,_loc2.vid);
						sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc7.cupId);
						this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_JS_LIST;
						_loc5.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
						_loc5.curActor.vfrm = _loc7.vfrm;
						this.onSwitchVideo(_loc7);
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2.currentTime,_loc2.bufferTime,_loc2.duration);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_CYCLE_PLAY:
					this._continuePlayProxy.isCyclePlay = Boolean(_loc2);
					break;
				case BodyDef.NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO:
					this.onJSCallLoadQiyiVideo(_loc2);
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2),true,_loc4);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this.onPlayerSwitchPreActor();
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2),true);
					break;
				case ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO:
					this.onRequestNextVideo(false);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SWITCH_NEXT_VIDEO:
					this.onRequestNextVideo(true);
					break;
				case ContinuePlayDef.NOTIFIC_REQUEST_PRE_VIDEO:
					this.onRequestPreVideo(false);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SWITCH_PRE_VIDEO:
					this.onRequestPreVideo(true);
					break;
				case ContinuePlayDef.NOTIFIC_REQUEST_SWITCH_VIDEO:
					_loc5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					_loc6 = _loc5.curActor.loadMovieParams;
					if(_loc6 == null || (_loc6) && (!(_loc6.vid == _loc2.vid)))
					{
						_loc7 = this._continuePlayProxy.findContinueInfo(_loc2.tvid,_loc2.vid);
						sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc7.cupId);
						if(_loc2.switchVideoType != undefined)
						{
							this._continuePlayProxy.switchVideoType = int(_loc2.switchVideoType);
						}
						else
						{
							this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PROGRAM_FREE_SWITCHING;
						}
						_loc5.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
						_loc5.curActor.vfrm = _loc7.vfrm;
						this.onSwitchVideo(_loc7);
					}
					break;
				case ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED:
					this.onInfoListChanged(_loc2);
					break;
				case ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE:
					this._continuePlayProxy.switchVideoType = int(_loc2);
					break;
				case SceneTileDef.NOTIFIC_REMOVE_STATUS:
					break;
				case SettingDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == SettingDef.STATUS_DEFINITION_OPEN)
					{
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					}
					break;
				case VideoLinkDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == VideoLinkDef.STATUS_OPEN)
					{
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					}
					break;
				case ControllBarDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2) == ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW)
					{
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					}
					break;
			}
		}
		
		private function onContinuePlayViewOpen(param1:ContinuePlayEvent) : void
		{
			if(!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN))
			{
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_OPEN);
			}
		}
		
		private function onContinuePlayViewClose(param1:ContinuePlayEvent) : void
		{
			if(this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN))
			{
				this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
		{
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
			{
				return;
			}
			var _loc4:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			switch(param1)
			{
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2)
					{
						this._continuePlayView.setCurPlaying(_loc4.curActor.loadMovieParams.tvid,_loc4.curActor.loadMovieParams.vid);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
					if(param2)
					{
						if(this._continuePlayProxy.continueInfoCount)
						{
							this.requestVideoList(_loc4.curActor.loadMovieParams.tvid,_loc4.curActor.loadMovieParams.vid);
						}
						else if(this._continuePlayProxy.isContinue)
						{
							this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
							this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
						}
						
					}
					break;
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void
		{
			switch(param1)
			{
				case ADDef.STATUS_PLAY_END:
					if(param2)
					{
						this.onADPlayEnd();
					}
					break;
			}
		}
		
		private function onPlayerSwitchPreActor() : void
		{
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
			{
				this._continuePlayView.setCurPlaying(_loc1.curActor.loadMovieParams.tvid,_loc1.curActor.loadMovieParams.vid);
			}
			if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
			{
				if(this._continuePlayProxy.continueInfoCount)
				{
					this.requestVideoList(_loc1.curActor.loadMovieParams.tvid,_loc1.curActor.loadMovieParams.vid);
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
			this._continuePlayView.onUserInfoChanged(_loc2);
		}
		
		private function onADPlayEnd() : void
		{
			var _loc3:LoadMovieParams = null;
			var _loc4:ContinueInfo = null;
			var _loc1:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			if(this._continuePlayProxy.isCyclePlay)
			{
				if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
				{
					this._log.info("ContinuePlayViewMediator >> onADPlayEnd:send request replay notifi!");
					sendNotification(ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO);
					PingBack.getInstance().cyclePlayPing(PingBackDef.PLAYER_ACTION,PingBackDef.PLAYER_ACTION);
				}
			}
			else if((this._continuePlayProxy.isContinue) && this._continuePlayProxy.continueInfoCount > 0)
			{
				if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
				{
					_loc3 = _loc1.curActor.loadMovieParams;
					_loc4 = this._continuePlayProxy.findNextContinueInfo(_loc3.tvid,_loc3.vid);
					if(_loc4)
					{
						this._log.info("ContinuePlayViewMediator >> onADPlayEnd:send load movie tvid:" + _loc4.loadMovieParams.tvid + ", vid:" + _loc4.loadMovieParams.vid);
						sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc4.cupId);
						this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO;
						_loc1.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
						_loc1.curActor.vfrm = _loc4.vfrm;
						_loc1.preActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
						_loc1.preActor.vfrm = _loc4.vfrm;
						_loc2.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
						this.onSwitchVideo(_loc4);
						PingBack.getInstance().continuityPlayPing();
					}
					else
					{
						if(SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_RECOMMEND))
						{
							this._log.info("ContinuePlayViewMediator >> onADPlayEnd:open recommend!");
							sendNotification(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE,true);
						}
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_END_PLAY);
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
						sendNotification(ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER);
					}
				}
			}
			else if(_loc1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
			{
				if(!this._continuePlayProxy.isJSContinue)
				{
					if(SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_RECOMMEND))
					{
						this._log.info("ContinuePlayViewMediator >> onADPlayEnd:open recommend!");
						sendNotification(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE,true);
					}
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_END_PLAY);
					this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					sendNotification(ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER);
				}
			}
			
			
		}
		
		private function onRequestNextVideo(param1:Boolean) : void
		{
			var _loc2:PlayerProxy = null;
			var _loc3:LoadMovieParams = null;
			var _loc4:ContinueInfo = null;
			var _loc5:JavascriptAPIProxy = null;
			if((this._continuePlayProxy.isContinue) && this._continuePlayProxy.continueInfoCount > 0)
			{
				_loc2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3 = _loc2.curActor.loadMovieParams;
				_loc4 = this._continuePlayProxy.findNextContinueInfo(_loc3.tvid,_loc3.vid);
				if(_loc4)
				{
					this._log.info("ContinuePlayViewMediator >> onRequestNextVideo,tvid:" + _loc4.loadMovieParams.tvid + ", vid:" + _loc4.loadMovieParams.vid);
					sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc4.cupId);
					this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PRE_NEXT_BTN;
					_loc2.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
					_loc2.curActor.vfrm = _loc4.vfrm;
					this.onSwitchVideo(_loc4);
				}
			}
			else if((this._continuePlayProxy.isJSContinue) && !param1)
			{
				_loc5 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
				_loc5.callJsPlayNextVideo();
			}
			
		}
		
		private function onRequestPreVideo(param1:Boolean) : void
		{
			var _loc2:PlayerProxy = null;
			var _loc3:LoadMovieParams = null;
			var _loc4:ContinueInfo = null;
			var _loc5:JavascriptAPIProxy = null;
			if((this._continuePlayProxy.isContinue) && this._continuePlayProxy.continueInfoCount > 0)
			{
				_loc2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3 = _loc2.curActor.loadMovieParams;
				_loc4 = this._continuePlayProxy.findPreContinueInfo(_loc3.tvid,_loc3.vid);
				if(_loc4)
				{
					this._log.info("ContinuePlayViewMediator >> onRequestPreVideo,tvid:" + _loc4.loadMovieParams.tvid + ", vid:" + _loc4.loadMovieParams.vid);
					sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc4.cupId);
					this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PRE_NEXT_BTN;
					_loc2.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
					_loc2.curActor.vfrm = _loc4.vfrm;
					this.onSwitchVideo(_loc4);
				}
			}
			else if((this._continuePlayProxy.isJSContinue) && !param1)
			{
				_loc5 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
				_loc5.callJsPlayPreVideo();
			}
			
		}
		
		private function onListItemClick(param1:ContinuePlayEvent) : void
		{
			var _loc4:JavascriptAPIProxy = null;
			var _loc2:ContinueInfo = param1.data as ContinueInfo;
			var _loc3:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(!(_loc2.loadMovieParams.tvid == _loc3.curActor.loadMovieParams.tvid) && !(_loc2.loadMovieParams.vid == _loc3.curActor.loadMovieParams.vid))
			{
				this._log.info("ContinuePlayViewMediator >> onListItemClick,tvid:" + _loc2.loadMovieParams.tvid + ", vid:" + _loc2.loadMovieParams.vid);
				sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc2.cupId);
				this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_FLASH_LIST;
				_loc3.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
				_loc3.curActor.vfrm = _loc2.vfrm;
				_loc4 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
				_loc4.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
				this.onSwitchVideo(_loc2);
			}
		}
		
		private function onArrowClick(param1:ContinuePlayEvent) : void
		{
			this._log.info("=====================================>onArrowClick isBefore = " + Boolean(param1.data));
			this.addVideoList(Boolean(param1.data),true);
		}
		
		private function onPageTriggerRequest(param1:ContinuePlayEvent) : void
		{
			var _loc2:Boolean = Boolean(param1.data);
			if(_loc2)
			{
				if(!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING))
				{
					this.addVideoList(true);
					this._log.info("=====================================>onPageTriggerRequest isBefore true");
				}
			}
			else if(!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING))
			{
				this.addVideoList(false);
				this._log.info("=====================================>onPageTriggerRequest isBefore false");
			}
			
		}
		
		private function addVideoList(param1:Boolean, param2:Boolean = false) : void
		{
			var _loc3:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc3.callJsRequestVideoList(param1);
			if(param1)
			{
				if(param2)
				{
					this._continuePlayView.isShowLeftTip = true;
				}
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
			}
			else
			{
				if(param2)
				{
					this._continuePlayView.isShowRightTip = true;
				}
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
			}
		}
		
		private function onSwitchOverPage(param1:ContinuePlayEvent) : void
		{
			TweenLite.killTweensOf(this.delayedCloseDock);
			var _loc2:Boolean = param1.data as Boolean;
			if(_loc2)
			{
				this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
			}
			else
			{
				this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
			}
		}
		
		private function onSwitchOverPageDone(param1:ContinuePlayEvent) : void
		{
			this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
			this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
		}
		
		private function onSwitchVideo(param1:ContinueInfo) : void
		{
			var _loc2:PlayerProxy = null;
			if((param1) && this._continuePlayProxy.continueInfoCount > 0)
			{
				ProcessesTimeRecord.needRecord = false;
				_loc2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if(_loc2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
				{
					if(_loc2.preActor.loadMovieParams.tvid == param1.loadMovieParams.tvid && _loc2.preActor.loadMovieParams.vid == param1.loadMovieParams.vid)
					{
						this._log.info("ContinuePlayViewMediator >> onSwitchVideo:switchPreActor!");
						_loc2.switchPreActor();
					}
					else
					{
						sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_STOP);
						this._log.info("ContinuePlayViewMediator >> onSwitchVideo:send load movie tvid:" + param1.loadMovieParams.tvid + ", vid:" + param1.loadMovieParams.vid);
						sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,param1.loadMovieParams,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
					}
				}
				else
				{
					this._log.info("ContinuePlayViewMediator >> onSwitchVideo:send load movie tvid:" + param1.loadMovieParams.tvid + ", vid:" + param1.loadMovieParams.vid);
					sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,param1.loadMovieParams,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
				}
			}
		}
		
		private function onJSCallLoadQiyiVideo(param1:Object) : void
		{
			var _loc2:LoadMovieParams = null;
			if(this._continuePlayProxy.continueInfoCount == 0)
			{
				_loc2 = new LoadMovieParams();
				_loc2.albumId = param1.albumId;
				_loc2.tvid = param1.tvId;
				_loc2.vid = param1.vid;
				_loc2.movieIsMember = param1.isMember == "true";
				this._log.info("ContinuePlayViewMediator >> onJSCallLoadQiyiVideo:send load movie tvid:" + _loc2.tvid + ", vid:" + _loc2.vid);
				PingBack.getInstance().continuityPlayPing();
				sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,param1.cid);
				this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_NONE;
				sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,_loc2,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
			}
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int) : void
		{
			var _loc4:PlayerProxy = null;
			var _loc5:IMovieModel = null;
			var _loc6:* = 0;
			var _loc7:LoadMovieParams = null;
			var _loc8:ContinueInfo = null;
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE && (this._continuePlayProxy.isContinue) && this._continuePlayProxy.continueInfoCount > 0)
			{
				_loc4 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if((_loc4.curActor.hasStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE)) && !_loc4.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
				{
					_loc5 = _loc4.curActor.movieModel;
					_loc6 = 0;
					if((Settings.instance.skipTrailer) && _loc5.trailerTime > 0)
					{
						_loc6 = _loc5.trailerTime;
					}
					else
					{
						_loc6 = _loc5.duration;
					}
					if(_loc6 - param1 < ContinuePlayDef.PRE_LOAD_TIME)
					{
						_loc7 = _loc4.curActor.loadMovieParams;
						_loc8 = this._continuePlayProxy.findNextContinueInfo(_loc7.tvid,_loc7.vid);
						if(_loc8)
						{
							this._log.info("start pre load,tvid:" + _loc8.loadMovieParams.tvid + ", vid:" + _loc8.loadMovieParams.vid);
							sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_LOAD_MOVIE,_loc8.loadMovieParams,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
						}
					}
				}
			}
		}
		
		private function onMouseMove(param1:MouseEvent) : void
		{
			this.onOpenDelayedCloseDock();
		}
		
		private function onOpenDelayedCloseDock() : void
		{
			TweenLite.killTweensOf(this.delayedCloseDock);
			TweenLite.delayedCall(ContinuePlayDef.AUTO_HIND_DELAY / 1000,this.delayedCloseDock);
		}
		
		private function delayedCloseDock() : void
		{
			this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
		}
		
		private function onInfoListChanged(param1:Object) : void
		{
			var _loc2:* = false;
			var _loc3:* = 0;
			if(this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN))
			{
				_loc2 = Boolean(param1.add);
				if(this._continuePlayProxy.continueInfoCount > 0)
				{
					if(_loc2)
					{
						_loc3 = int(param1.addCount);
						if(_loc3 > 0)
						{
							if((this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW)) && (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS)) || (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW)) && (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS)))
							{
								this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(),false,this._continuePlayProxy.hasPreNeedLoad,this._continuePlayProxy.hasNextNeedLoad);
								this._continuePlayView.switchPageInfo();
								this._continuePlayView.updateOpenView();
							}
							else
							{
								this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(),false,this._continuePlayProxy.hasPreNeedLoad,this._continuePlayProxy.hasNextNeedLoad);
								this._continuePlayView.updateCurrentPageIndex();
								this._continuePlayView.updateArrowBtn();
							}
						}
						else
						{
							this._continuePlayView.updateArrowBtn();
						}
					}
					else
					{
						this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(),true,this._continuePlayProxy.hasPreNeedLoad,this._continuePlayProxy.hasNextNeedLoad);
						this._continuePlayView.updateOpenView();
					}
				}
				else
				{
					this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
				}
			}
		}
		
		private function requestVideoList(param1:String, param2:String) : void
		{
			var _loc4:* = 0;
			var _loc5:* = 0;
			var _loc6:* = 0;
			var _loc7:JavascriptAPIProxy = null;
			var _loc3:ContinueInfo = this._continuePlayProxy.findContinueInfo(param1,param2);
			if(_loc3)
			{
				_loc4 = _loc3.index;
				_loc5 = _loc4;
				_loc6 = this._continuePlayProxy.continueInfoCount - _loc4 - 1;
				_loc7 = null;
				if((this._continuePlayProxy.hasPreNeedLoad) && _loc5 < ContinuePlayDef.REMAIN_NUM_TO_REQUEST && !this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING))
				{
					_loc7 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc7.callJsRequestVideoList(true);
					this._continuePlayView.isShowLeftTip = false;
					this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
				}
				if((this._continuePlayProxy.hasNextNeedLoad) && _loc6 < ContinuePlayDef.REMAIN_NUM_TO_REQUEST && !this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING))
				{
					_loc7 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc7.callJsRequestVideoList(false);
					this._continuePlayView.isShowRightTip = false;
					this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
				}
			}
		}
	}
}
