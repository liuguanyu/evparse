package com.qiyi.player.wonder.plugins.continueplay.view {
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
	
	public class ContinuePlayViewMediator extends Mediator {
		
		public function ContinuePlayViewMediator(param1:ContinuePlayView) {
			this._log = Log.getLogger(NAME);
			super(NAME,param1);
			this._continuePlayView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.continueplay.view.ContinuePlayViewMediator";
		
		private var _continuePlayProxy:ContinuePlayProxy;
		
		private var _continuePlayView:ContinuePlayView;
		
		private var _log:ILogger;
		
		override public function onRegister() : void {
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
		
		override public function listNotificationInterests() : Array {
			return [ContinuePlayDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE,BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO,BodyDef.NOTIFIC_JS_CALL_SWITCH_VIDEO,BodyDef.NOTIFIC_JS_CALL_SWITCH_NEXT_VIDEO,BodyDef.NOTIFIC_JS_CALL_SWITCH_PRE_VIDEO,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_JS_CALL_SET_CYCLE_PLAY,BodyDef.NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,ADDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO,ContinuePlayDef.NOTIFIC_REQUEST_PRE_VIDEO,ContinuePlayDef.NOTIFIC_REQUEST_SWITCH_VIDEO,ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED,ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE,SceneTileDef.NOTIFIC_REMOVE_STATUS,SettingDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_ADD_STATUS,ControllBarDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			var _loc5_:PlayerProxy = null;
			var _loc6_:LoadMovieParams = null;
			var _loc7_:ContinueInfo = null;
			switch(_loc3_) {
				case ContinuePlayDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == ContinuePlayDef.STATUS_OPEN) {
						_loc5_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						this.requestVideoList(_loc5_.curActor.loadMovieParams.tvid,_loc5_.curActor.loadMovieParams.vid);
						this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(),true,this._continuePlayProxy.hasPreNeedLoad,this._continuePlayProxy.hasNextNeedLoad);
						this._continuePlayView.updateOpenView();
						this._continuePlayView.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
						this.onOpenDelayedCloseDock();
					}
					this._continuePlayView.onAddStatus(int(_loc2_));
					break;
				case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
					if(int(_loc2_) == ContinuePlayDef.STATUS_OPEN) {
						this._continuePlayView.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
					}
					this._continuePlayView.onRemoveStatus(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._continuePlayView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					if(!Boolean(_loc2_) && FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE) {
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					}
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:
					this._continuePlayProxy.isContinue = Boolean(_loc2_);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:
					this._continuePlayProxy.isJSContinue = Boolean(_loc2_.continuePlay);
					this._continuePlayProxy.JSContinueTitle = _loc2_.nextVideoTitle;
					break;
				case BodyDef.NOTIFIC_JS_CALL_SWITCH_VIDEO:
					_loc5_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					_loc6_ = _loc5_.curActor.loadMovieParams;
					if(_loc6_ == null || (_loc6_) && (!(_loc6_.vid == _loc2_.vid))) {
						_loc7_ = this._continuePlayProxy.findContinueInfo(_loc2_.tvid,_loc2_.vid);
						sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc7_.cupId);
						this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_JS_LIST;
						_loc5_.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
						_loc5_.curActor.vfrm = _loc7_.vfrm;
						this.onSwitchVideo(_loc7_);
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_RUNNING:
					this.onPlayerRunning(_loc2_.currentTime,_loc2_.bufferTime,_loc2_.duration);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_CYCLE_PLAY:
					this._continuePlayProxy.isCyclePlay = Boolean(_loc2_);
					break;
				case BodyDef.NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO:
					this.onJSCallLoadQiyiVideo(_loc2_);
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this.onPlayerSwitchPreActor();
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2_),true);
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
					_loc5_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					_loc6_ = _loc5_.curActor.loadMovieParams;
					if(_loc6_ == null || (_loc6_) && (!(_loc6_.vid == _loc2_.vid))) {
						_loc7_ = this._continuePlayProxy.findContinueInfo(_loc2_.tvid,_loc2_.vid);
						sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc7_.cupId);
						if(_loc2_.switchVideoType != undefined) {
							this._continuePlayProxy.switchVideoType = int(_loc2_.switchVideoType);
						} else {
							this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PROGRAM_FREE_SWITCHING;
						}
						_loc5_.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
						_loc5_.curActor.vfrm = _loc7_.vfrm;
						this.onSwitchVideo(_loc7_);
					}
					break;
				case ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED:
					this.onInfoListChanged(_loc2_);
					break;
				case ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE:
					this._continuePlayProxy.switchVideoType = int(_loc2_);
					break;
				case SceneTileDef.NOTIFIC_REMOVE_STATUS:
					break;
				case SettingDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == SettingDef.STATUS_DEFINITION_OPEN) {
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					}
					break;
				case VideoLinkDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == VideoLinkDef.STATUS_OPEN) {
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					}
					break;
				case ControllBarDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW) {
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					}
					break;
			}
		}
		
		private function onContinuePlayViewOpen(param1:ContinuePlayEvent) : void {
			if(!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN)) {
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_OPEN);
			}
		}
		
		private function onContinuePlayViewClose(param1:ContinuePlayEvent) : void {
			if(this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN)) {
				this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						this._continuePlayView.setCurPlaying(_loc4_.curActor.loadMovieParams.tvid,_loc4_.curActor.loadMovieParams.vid);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
					if(param2) {
						if(this._continuePlayProxy.continueInfoCount) {
							this.requestVideoList(_loc4_.curActor.loadMovieParams.tvid,_loc4_.curActor.loadMovieParams.vid);
						} else if(this._continuePlayProxy.isContinue) {
							this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
							this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
						}
						
					}
					break;
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ADDef.STATUS_PLAY_END:
					if(param2) {
						this.onADPlayEnd();
					}
					break;
			}
		}
		
		private function onPlayerSwitchPreActor() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) {
				this._continuePlayView.setCurPlaying(_loc1_.curActor.loadMovieParams.tvid,_loc1_.curActor.loadMovieParams.vid);
			}
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				if(this._continuePlayProxy.continueInfoCount) {
					this.requestVideoList(_loc1_.curActor.loadMovieParams.tvid,_loc1_.curActor.loadMovieParams.vid);
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
			this._continuePlayView.onUserInfoChanged(_loc2_);
		}
		
		private function onADPlayEnd() : void {
			var _loc3_:LoadMovieParams = null;
			var _loc4_:ContinueInfo = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			if(this._continuePlayProxy.isCyclePlay) {
				if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED)) {
					this._log.info("ContinuePlayViewMediator >> onADPlayEnd:send request replay notifi!");
					sendNotification(ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO);
					PingBack.getInstance().cyclePlayPing(PingBackDef.PLAYER_ACTION,PingBackDef.PLAYER_ACTION);
				}
			} else if((this._continuePlayProxy.isContinue) && this._continuePlayProxy.continueInfoCount > 0) {
				if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED)) {
					_loc3_ = _loc1_.curActor.loadMovieParams;
					_loc4_ = this._continuePlayProxy.findNextContinueInfo(_loc3_.tvid,_loc3_.vid);
					if(_loc4_) {
						this._log.info("ContinuePlayViewMediator >> onADPlayEnd:send load movie tvid:" + _loc4_.loadMovieParams.tvid + ", vid:" + _loc4_.loadMovieParams.vid);
						sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc4_.cupId);
						this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO;
						_loc1_.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
						_loc1_.curActor.vfrm = _loc4_.vfrm;
						_loc1_.preActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
						_loc1_.preActor.vfrm = _loc4_.vfrm;
						_loc2_.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
						this.onSwitchVideo(_loc4_);
						PingBack.getInstance().continuityPlayPing();
					} else {
						if(SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_RECOMMEND)) {
							this._log.info("ContinuePlayViewMediator >> onADPlayEnd:open recommend!");
							sendNotification(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE,true);
						}
						sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_END_PLAY);
						this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
						sendNotification(ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER);
					}
				}
			} else if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED)) {
				if(!this._continuePlayProxy.isJSContinue) {
					if(SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_RECOMMEND)) {
						this._log.info("ContinuePlayViewMediator >> onADPlayEnd:open recommend!");
						sendNotification(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE,true);
					}
					sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS,BodyDef.JS_STATUS_END_PLAY);
					this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
					sendNotification(ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER);
				}
			}
			
			
		}
		
		private function onRequestNextVideo(param1:Boolean) : void {
			var _loc2_:PlayerProxy = null;
			var _loc3_:LoadMovieParams = null;
			var _loc4_:ContinueInfo = null;
			var _loc5_:JavascriptAPIProxy = null;
			if((this._continuePlayProxy.isContinue) && this._continuePlayProxy.continueInfoCount > 0) {
				_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3_ = _loc2_.curActor.loadMovieParams;
				_loc4_ = this._continuePlayProxy.findNextContinueInfo(_loc3_.tvid,_loc3_.vid);
				if(_loc4_) {
					this._log.info("ContinuePlayViewMediator >> onRequestNextVideo,tvid:" + _loc4_.loadMovieParams.tvid + ", vid:" + _loc4_.loadMovieParams.vid);
					sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc4_.cupId);
					this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PRE_NEXT_BTN;
					_loc2_.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
					_loc2_.curActor.vfrm = _loc4_.vfrm;
					this.onSwitchVideo(_loc4_);
				}
			} else if((this._continuePlayProxy.isJSContinue) && !param1) {
				_loc5_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
				_loc5_.callJsPlayNextVideo();
			}
			
		}
		
		private function onRequestPreVideo(param1:Boolean) : void {
			var _loc2_:PlayerProxy = null;
			var _loc3_:LoadMovieParams = null;
			var _loc4_:ContinueInfo = null;
			var _loc5_:JavascriptAPIProxy = null;
			if((this._continuePlayProxy.isContinue) && this._continuePlayProxy.continueInfoCount > 0) {
				_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3_ = _loc2_.curActor.loadMovieParams;
				_loc4_ = this._continuePlayProxy.findPreContinueInfo(_loc3_.tvid,_loc3_.vid);
				if(_loc4_) {
					this._log.info("ContinuePlayViewMediator >> onRequestPreVideo,tvid:" + _loc4_.loadMovieParams.tvid + ", vid:" + _loc4_.loadMovieParams.vid);
					sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc4_.cupId);
					this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PRE_NEXT_BTN;
					_loc2_.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
					_loc2_.curActor.vfrm = _loc4_.vfrm;
					this.onSwitchVideo(_loc4_);
				}
			} else if((this._continuePlayProxy.isJSContinue) && !param1) {
				_loc5_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
				_loc5_.callJsPlayPreVideo();
			}
			
		}
		
		private function onListItemClick(param1:ContinuePlayEvent) : void {
			var _loc4_:JavascriptAPIProxy = null;
			var _loc2_:ContinueInfo = param1.data as ContinueInfo;
			var _loc3_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(!(_loc2_.loadMovieParams.tvid == _loc3_.curActor.loadMovieParams.tvid) && !(_loc2_.loadMovieParams.vid == _loc3_.curActor.loadMovieParams.vid)) {
				this._log.info("ContinuePlayViewMediator >> onListItemClick,tvid:" + _loc2_.loadMovieParams.tvid + ", vid:" + _loc2_.loadMovieParams.vid);
				sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,_loc2_.cupId);
				this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_FLASH_LIST;
				_loc3_.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO?PingBackDef.VVPING_AUTO_PLAY:PingBackDef.VVPING_USER_CLICK;
				_loc3_.curActor.vfrm = _loc2_.vfrm;
				_loc4_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
				_loc4_.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
				this.onSwitchVideo(_loc2_);
			}
		}
		
		private function onArrowClick(param1:ContinuePlayEvent) : void {
			this._log.info("=====================================>onArrowClick isBefore = " + Boolean(param1.data));
			this.addVideoList(Boolean(param1.data),true);
		}
		
		private function onPageTriggerRequest(param1:ContinuePlayEvent) : void {
			var _loc2_:Boolean = Boolean(param1.data);
			if(_loc2_) {
				if(!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING)) {
					this.addVideoList(true);
					this._log.info("=====================================>onPageTriggerRequest isBefore true");
				}
			} else if(!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING)) {
				this.addVideoList(false);
				this._log.info("=====================================>onPageTriggerRequest isBefore false");
			}
			
		}
		
		private function addVideoList(param1:Boolean, param2:Boolean = false) : void {
			var _loc3_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc3_.callJsRequestVideoList(param1);
			if(param1) {
				if(param2) {
					this._continuePlayView.isShowLeftTip = true;
				}
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
			} else {
				if(param2) {
					this._continuePlayView.isShowRightTip = true;
				}
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
			}
		}
		
		private function onSwitchOverPage(param1:ContinuePlayEvent) : void {
			TweenLite.killTweensOf(this.delayedCloseDock);
			var _loc2_:Boolean = param1.data as Boolean;
			if(_loc2_) {
				this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
			} else {
				this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
				this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
			}
		}
		
		private function onSwitchOverPageDone(param1:ContinuePlayEvent) : void {
			this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
			this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
		}
		
		private function onSwitchVideo(param1:ContinueInfo) : void {
			var _loc2_:PlayerProxy = null;
			if((param1) && this._continuePlayProxy.continueInfoCount > 0) {
				ProcessesTimeRecord.needRecord = false;
				_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if(_loc2_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) {
					if(_loc2_.preActor.loadMovieParams.tvid == param1.loadMovieParams.tvid && _loc2_.preActor.loadMovieParams.vid == param1.loadMovieParams.vid) {
						this._log.info("ContinuePlayViewMediator >> onSwitchVideo:switchPreActor!");
						_loc2_.switchPreActor();
					} else {
						sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_STOP);
						this._log.info("ContinuePlayViewMediator >> onSwitchVideo:send load movie tvid:" + param1.loadMovieParams.tvid + ", vid:" + param1.loadMovieParams.vid);
						sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,param1.loadMovieParams,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
					}
				} else {
					this._log.info("ContinuePlayViewMediator >> onSwitchVideo:send load movie tvid:" + param1.loadMovieParams.tvid + ", vid:" + param1.loadMovieParams.vid);
					sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,param1.loadMovieParams,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
				}
			}
		}
		
		private function onJSCallLoadQiyiVideo(param1:Object) : void {
			var _loc2_:LoadMovieParams = null;
			if(this._continuePlayProxy.continueInfoCount == 0) {
				_loc2_ = new LoadMovieParams();
				_loc2_.albumId = param1.albumId;
				_loc2_.tvid = param1.tvId;
				_loc2_.vid = param1.vid;
				_loc2_.movieIsMember = param1.isMember == "true";
				this._log.info("ContinuePlayViewMediator >> onJSCallLoadQiyiVideo:send load movie tvid:" + _loc2_.tvid + ", vid:" + _loc2_.vid);
				PingBack.getInstance().continuityPlayPing();
				sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID,param1.cid);
				this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_NONE;
				sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,_loc2_,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
			}
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int) : void {
			var _loc4_:PlayerProxy = null;
			var _loc5_:IMovieModel = null;
			var _loc6_:* = 0;
			var _loc7_:LoadMovieParams = null;
			var _loc8_:ContinueInfo = null;
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE && (this._continuePlayProxy.isContinue) && this._continuePlayProxy.continueInfoCount > 0) {
				_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if((_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE)) && !_loc4_.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) {
					_loc5_ = _loc4_.curActor.movieModel;
					_loc6_ = 0;
					if((Settings.instance.skipTrailer) && _loc5_.trailerTime > 0) {
						_loc6_ = _loc5_.trailerTime;
					} else {
						_loc6_ = _loc5_.duration;
					}
					if(_loc6_ - param1 < ContinuePlayDef.PRE_LOAD_TIME) {
						_loc7_ = _loc4_.curActor.loadMovieParams;
						_loc8_ = this._continuePlayProxy.findNextContinueInfo(_loc7_.tvid,_loc7_.vid);
						if(_loc8_) {
							this._log.info("start pre load,tvid:" + _loc8_.loadMovieParams.tvid + ", vid:" + _loc8_.loadMovieParams.vid);
							sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_LOAD_MOVIE,_loc8_.loadMovieParams,BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
						}
					}
				}
			}
		}
		
		private function onMouseMove(param1:MouseEvent) : void {
			this.onOpenDelayedCloseDock();
		}
		
		private function onOpenDelayedCloseDock() : void {
			TweenLite.killTweensOf(this.delayedCloseDock);
			TweenLite.delayedCall(ContinuePlayDef.AUTO_HIND_DELAY / 1000,this.delayedCloseDock);
		}
		
		private function delayedCloseDock() : void {
			this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
		}
		
		private function onInfoListChanged(param1:Object) : void {
			var _loc2_:* = false;
			var _loc3_:* = 0;
			if(this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN)) {
				_loc2_ = Boolean(param1.add);
				if(this._continuePlayProxy.continueInfoCount > 0) {
					if(_loc2_) {
						_loc3_ = int(param1.addCount);
						if(_loc3_ > 0) {
							if((this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW)) && (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS)) || (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW)) && (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS))) {
								this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(),false,this._continuePlayProxy.hasPreNeedLoad,this._continuePlayProxy.hasNextNeedLoad);
								this._continuePlayView.switchPageInfo();
								this._continuePlayView.updateOpenView();
							} else {
								this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(),false,this._continuePlayProxy.hasPreNeedLoad,this._continuePlayProxy.hasNextNeedLoad);
								this._continuePlayView.updateCurrentPageIndex();
								this._continuePlayView.updateArrowBtn();
							}
						} else {
							this._continuePlayView.updateArrowBtn();
						}
					} else {
						this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(),true,this._continuePlayProxy.hasPreNeedLoad,this._continuePlayProxy.hasNextNeedLoad);
						this._continuePlayView.updateOpenView();
					}
				} else {
					this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
				}
			}
		}
		
		private function requestVideoList(param1:String, param2:String) : void {
			var _loc4_:* = 0;
			var _loc5_:* = 0;
			var _loc6_:* = 0;
			var _loc7_:JavascriptAPIProxy = null;
			var _loc3_:ContinueInfo = this._continuePlayProxy.findContinueInfo(param1,param2);
			if(_loc3_) {
				_loc4_ = _loc3_.index;
				_loc5_ = _loc4_;
				_loc6_ = this._continuePlayProxy.continueInfoCount - _loc4_ - 1;
				_loc7_ = null;
				if((this._continuePlayProxy.hasPreNeedLoad) && _loc5_ < ContinuePlayDef.REMAIN_NUM_TO_REQUEST && !this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING)) {
					_loc7_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc7_.callJsRequestVideoList(true);
					this._continuePlayView.isShowLeftTip = false;
					this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
				}
				if((this._continuePlayProxy.hasNextNeedLoad) && _loc6_ < ContinuePlayDef.REMAIN_NUM_TO_REQUEST && !this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING)) {
					_loc7_ = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
					_loc7_.callJsRequestVideoList(false);
					this._continuePlayView.isShowRightTip = false;
					this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
				}
			}
		}
	}
}
