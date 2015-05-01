package com.qiyi.player.wonder.plugins.tips.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.common.sw.ISwitch;
	import com.qiyi.player.wonder.plugins.tips.model.TipsProxy;
	import com.qiyi.player.core.model.impls.FocusTip;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.plugins.tips.view.parts.TipManager;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.plugins.tips.view.parts.TipEvent;
	import com.qiyi.player.wonder.plugins.tips.TipsDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.model.def.TryWatchEnum;
	import gs.TweenLite;
	import com.qiyi.player.core.model.def.DefinitionControlTypeEnum;
	import com.qiyi.player.wonder.common.utils.ChineseNameOfLangAudioDef;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.core.model.IMovieInfo;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinueInfo;
	import com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import com.qiyi.player.wonder.plugins.topbar.model.TopBarProxy;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	import com.qiyi.player.core.model.IAudioTrackInfo;
	import com.qiyi.player.base.utils.Strings;
	import com.qiyi.player.wonder.common.utils.ConstUtils;
	import com.qiyi.player.core.model.impls.pub.Statistics;
	import flash.external.ExternalInterface;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class TipsViewMediator extends Mediator implements ISwitch {
		
		public function TipsViewMediator(param1:TipsView) {
			super(NAME,param1);
			this._tipsView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.tips.view.TipsViewMediator";
		
		private var _tipsProxy:TipsProxy;
		
		private var _tipsView:TipsView;
		
		private var _isTyrWatchTipShown:Boolean;
		
		private var _curFocusTip:FocusTip;
		
		override public function onRegister() : void {
			super.onRegister();
			SwitchManager.getInstance().register(this);
			this._tipsProxy = facade.retrieveProxy(TipsProxy.NAME) as TipsProxy;
			this._tipsView.addEventListener(TipsEvent.Evt_Open,this.onTipsViewOpen);
			this._tipsView.addEventListener(TipsEvent.Evt_Close,this.onTipsViewClose);
			TipManager.setDataUrl(FlashVarConfig.tipDataURL);
			TipManager.initialize(this._tipsView.tipBar);
			TipManager.addEventListener(TipEvent.All,this.onTipEvent);
			TipManager.setSubscribed(false);
		}
		
		override public function listNotificationInterests() : Array {
			return [TipsDef.NOTIFIC_ADD_STATUS,TipsDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_JS_CALL_SUBSCRIBE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_PLAYER_RUNNING,BodyDef.NOTIFIC_PLAYER_SKIP_TITLE,BodyDef.NOTIFIC_PLAYER_PREPARE_PLAY_END,BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED,BodyDef.NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED,BodyDef.NOTIFIC_PLAYER_STUCK,BodyDef.NOTIFIC_PLAYER_START_FROM_HISTORY,BodyDef.NOTIFIC_PLAYER_REPLAYED,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,ADDef.NOTIFIC_ADD_STATUS,ADDef.NOTIFIC_AD_UNLOADED,ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED,TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.NOTIFIC_REQUEST_HIDE_TIP,TipsDef.NOTIFIC_UPDATE_TIP_ATTR,ControllBarDef.NOTIFIC_ADD_STATUS,ControllBarDef.NOTIFIC_REMOVE_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc2_:Object = null;
			var _loc5_:uint = 0;
			super.handleNotification(param1);
			_loc2_ = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case TipsDef.NOTIFIC_ADD_STATUS:
					this._tipsView.onAddStatus(int(_loc2_));
					break;
				case TipsDef.NOTIFIC_REMOVE_STATUS:
					this._tipsView.onRemoveStatus(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._tipsView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_JS_CALL_SUBSCRIBE:
					TipManager.setCanSubscribe(_loc2_.canSubscribe);
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
				case BodyDef.NOTIFIC_PLAYER_SKIP_TITLE:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						PingBack.getInstance().userActionPing(PingBackDef.PASS_HEAD_TILE);
						this.showTip(TipsDef.TIP_ID_SKIPPED_HEAD);
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_PREPARE_PLAY_END:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerPreparePlayEnd();
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerDefinitionSwitched(int(_loc2_));
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerAudioTrackSwitched(int(_loc2_));
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_STUCK:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerStuck();
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_START_FROM_HISTORY:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerStartFromHistory(int(_loc2_));
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_REPLAYED:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						if(this.checkShowStatus()) {
							this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
						}
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					if(_loc2_) {
						this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
					} else if(this.checkShowStatus()) {
						this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
					}
					
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2_),true);
					break;
				case ADDef.NOTIFIC_AD_UNLOADED:
					TipManager.setADState(false);
					break;
				case ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED:
					break;
				case TipsDef.NOTIFIC_REQUEST_SHOW_TIP:
					_loc5_ = this.showTip(String(_loc2_));
					break;
				case TipsDef.NOTIFIC_REQUEST_HIDE_TIP:
					this.hideTip();
					break;
				case TipsDef.NOTIFIC_UPDATE_TIP_ATTR:
					this.updateTipAttr(_loc2_.attr,_loc2_.value);
					break;
				case ControllBarDef.NOTIFIC_ADD_STATUS:
					this.onControllBarStatusChanged(int(_loc2_),true);
					break;
				case ControllBarDef.NOTIFIC_REMOVE_STATUS:
					this.onControllBarStatusChanged(int(_loc2_),false);
					break;
			}
		}
		
		public function getSwitchID() : Vector.<int> {
			return Vector.<int>([SwitchDef.ID_SHOW_TIPS]);
		}
		
		public function onSwitchStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case SwitchDef.ID_SHOW_TIPS:
					if(param2) {
						if(this.checkShowStatus()) {
							this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
						}
					} else {
						this.hideTip();
						this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
					}
					break;
			}
		}
		
		private function showTip(param1:String) : int {
			return TipManager.showTip(param1);
		}
		
		private function hideTip(param1:String = "") : void {
			TipManager.hideTip(param1);
		}
		
		private function updateTipAttr(param1:String, param2:String) : void {
			TipManager.updateAttribute(param1,param2);
		}
		
		private function onTipsViewOpen(param1:TipsEvent) : void {
			if(!this._tipsProxy.hasStatus(TipsDef.STATUS_OPEN)) {
				this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
			}
		}
		
		private function onTipsViewClose(param1:TipsEvent) : void {
			if(this._tipsProxy.hasStatus(TipsDef.STATUS_OPEN)) {
				this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
			}
		}
		
		private function onCheckUserComplete() : void {
			var _loc1_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			TipManager.setIsMember(!(_loc1_.userLevel == UserDef.USER_LEVEL_NORMAL));
			TipManager.setIsLogin(_loc1_.isLogin);
			TipManager.setPassportId(_loc1_.passportID);
			var _loc2_:UserInfoVO = new UserInfoVO();
			_loc2_.isLogin = _loc1_.isLogin;
			_loc2_.passportID = _loc1_.passportID;
			_loc2_.userID = _loc1_.userID;
			_loc2_.userName = _loc1_.userName;
			_loc2_.userLevel = _loc1_.userLevel;
			_loc2_.userType = _loc1_.userType;
			this._tipsView.onUserInfoChanged(_loc2_);
			this.updateTipAttr(TipsDef.TIP_ATTR_NAME_LOGIN,_loc1_.isLogin?"":"登录提示");
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			var _loc5_:UserProxy = null;
			var _loc6_:EnumItem = null;
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			var _loc4_:PlayerProxy = null;
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2) {
						_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						this._tipsProxy.clearHotChatTipsTimes();
						if((_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
							if(this.checkShowStatus()) {
								this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
							}
							this.onReady();
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(_loc4_.curActor.isTryWatch) {
						if(!this._isTyrWatchTipShown) {
							if(_loc4_.curActor.tryWatchType == TryWatchEnum.TOTAL) {
								this.showTip(TipsDef.TIP_ID_TRY_WATCH_TOTAL);
							} else if(_loc4_.curActor.authenticationTipType == TipsDef.AUTH_TIP_TYPE_NOT_TICKET) {
								this.showTip(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET);
							} else if(_loc4_.curActor.authenticationTipType == TipsDef.AUTH_TIP_TYPE_TICKET) {
								this.showTip(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET);
							} else {
								this.showTip(TipsDef.TIP_ID_TRY_WATCH);
							}
							
							
							this._isTyrWatchTipShown = true;
						}
					} else if((TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH)) || (TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET)) || (TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET))) {
						this.hideTip(TipsDef.TIP_ID_TRY_WATCH);
						this.hideTip(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET);
						this.hideTip(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET);
					} else if(TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_TOTAL)) {
						this.hideTip(TipsDef.TIP_ID_TRY_WATCH_TOTAL);
					}
					
					
					break;
				case BodyDef.PLAYER_STATUS_STOPPING:
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						this.hideTip();
						this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
						TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
						TweenLite.killTweensOf(this.onPlayerAudioTrackSwitchComplete);
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPED:
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2) {
						this.hideTip();
						this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
						TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
						TweenLite.killTweensOf(this.onPlayerAudioTrackSwitchComplete);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
					if(param2) {
						_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						_loc5_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
						if(!(_loc5_.userLevel == UserDef.USER_LEVEL_NORMAL) && !(_loc4_.curActor.movieModel.qualityDefinitionControlType == DefinitionControlTypeEnum.NONE)) {
							for each(_loc6_ in _loc4_.curActor.movieModel.qualityDefinitionControlList) {
								if(_loc6_ == _loc4_.curActor.movieModel.curDefinitionInfo.type) {
									this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION,ChineseNameOfLangAudioDef.getDefinitionName(_loc6_));
									this.showTip(TipsDef.TIP_ID_DEFINITION_LIMIT_TIPS);
								}
							}
						}
					}
					break;
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ADDef.STATUS_LOADING:
				case ADDef.STATUS_PLAYING:
					if(param2) {
						TipManager.setADState(true);
					}
					break;
				case ADDef.STATUS_PLAY_END:
					if(param2) {
						TipManager.setADState(false);
					}
					break;
			}
		}
		
		private function onControllBarStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ControllBarDef.STATUS_SHOW:
					this.checkTipsLocation();
					break;
				case ControllBarDef.STATUS_SEEK_BAR_SHOW:
					this.checkTipsLocation();
					break;
				case ControllBarDef.STATUS_SEEK_BAR_THICK:
					this.checkTipsLocation();
					break;
			}
		}
		
		private function onPlayerSwitchPreActor() : void {
			this.hideTip();
			this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
			this._tipsProxy.clearHotChatTipsTimes();
			TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
			TweenLite.killTweensOf(this.onPlayerAudioTrackSwitchComplete);
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))) {
				this._isTyrWatchTipShown = false;
				if(this.checkShowStatus()) {
					this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
				}
				this.onReady();
			}
		}
		
		private function onReady() : void {
			var _loc4_:String = null;
			var _loc5_:Date = null;
			var _loc6_:String = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:IMovieModel = _loc1_.curActor.movieModel;
			var _loc3_:IMovieInfo = _loc1_.curActor.movieInfo;
			TipManager.setPlayerModel(_loc1_.curActor.corePlayer);
			TipManager.setStartTime(Math.floor(_loc1_.curActor.strategy.getStartTime() / 1000));
			TipManager.setTotalTime(Math.floor(_loc2_.duration / 1000));
			if((Settings.instance.skipTrailer) && _loc2_.trailerTime > 0) {
				TipManager.setEndTime(Math.floor(_loc2_.trailerTime / 1000));
			} else {
				TipManager.setEndTime(Math.floor(_loc2_.duration / 1000));
			}
			if(_loc3_.infoJSON.hasOwnProperty("etm")) {
				_loc4_ = _loc3_.infoJSON["etm"];
				_loc5_ = new Date();
				_loc5_.fullYear = Number(_loc4_.substr(0,4));
				_loc5_.month = Number(_loc4_.substr(4,2)) - 1;
				_loc5_.date = Number(_loc4_.substr(6,2));
				_loc6_ = _loc5_.fullYear + "年" + (_loc5_.month + 1) + "月" + _loc5_.date + "日";
				this.updateTipAttr(TipsDef.TIP_ATTR_NAME_VIDEO_NAME,_loc3_.albumName);
				this.updateTipAttr(TipsDef.TIP_ATTR_NAME_EXPIRED_TIME,_loc6_);
			}
			this._isTyrWatchTipShown = false;
		}
		
		private function checkShowStatus() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_TIPS)) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)) && !_loc1_.curActor.smallWindowMode) {
				return true;
			}
			return false;
		}
		
		private function onPlayerPreparePlayEnd() : void {
			var _loc4_:ContinuePlayProxy = null;
			var _loc5_:String = null;
			var _loc6_:String = null;
			var _loc7_:ContinueInfo = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ControllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
			var _loc3_:IMovieModel = _loc1_.curActor.movieModel;
			if(!(_loc3_ == null) && _loc1_.curActor.currentTime < _loc3_.trailerTime && _loc3_.trailerTime > 0 && (Settings.instance.skipTrailer)) {
				this.showTip(TipsDef.TIP_ID_SKIPPING_TAIL);
			} else {
				_loc4_ = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
				if(!_loc4_.isCyclePlay) {
					if(_loc4_.isJSContinue) {
						if(_loc4_.JSContinueTitle) {
							this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DESCRIPTION,_loc4_.JSContinueTitle);
						} else {
							this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DESCRIPTION,"下一个节目");
						}
						if(!_loc2_.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc1_.curActor.movieModel.duration >= TipsDef.DEF_VIDEO_CURRENTTIME_MIN) {
							this.showTip(TipsDef.TIP_ID_NEXT_VIDEO);
						}
					} else {
						_loc5_ = _loc1_.curActor.loadMovieParams.tvid;
						_loc6_ = _loc1_.curActor.loadMovieParams.vid;
						_loc7_ = _loc4_.findNextContinueInfo(_loc5_,_loc6_);
						if((_loc4_.isContinue) && (_loc7_)) {
							if(_loc7_.title) {
								this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DESCRIPTION,_loc7_.title);
							} else {
								this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DESCRIPTION,"下一个节目");
							}
							if(!_loc2_.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc1_.curActor.movieModel.duration >= TipsDef.DEF_VIDEO_CURRENTTIME_MIN) {
								this.showTip(TipsDef.TIP_ID_NEXT_VIDEO);
							}
						}
					}
				}
			}
		}
		
		private function onPlayerDefinitionSwitched(param1:int) : void {
			var _loc2_:PlayerProxy = null;
			var _loc3_:UserProxy = null;
			var _loc4_:* = false;
			var _loc5_:EnumItem = null;
			if(!Settings.instance.autoMatchRate || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT) {
				_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				if(!(_loc3_.userLevel == UserDef.USER_LEVEL_NORMAL) && !(_loc2_.curActor.movieModel.qualityDefinitionControlType == DefinitionControlTypeEnum.NONE)) {
					_loc4_ = false;
					for each(_loc5_ in _loc2_.curActor.movieModel.qualityDefinitionControlList) {
						if(_loc5_ == _loc2_.curActor.movieModel.curDefinitionInfo.type) {
							this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION,ChineseNameOfLangAudioDef.getDefinitionName(Settings.instance.definition));
							this.showTip(TipsDef.TIP_ID_SWAPPING_LIMIT_DEF);
							_loc4_ = true;
						}
					}
					if(!_loc4_) {
						if(Settings.instance.definition == DefinitionEnum.FOUR_K || Settings.instance.definition == DefinitionEnum.FULL_HD || Settings.instance.definition == DefinitionEnum.SUPER_HIGH) {
							this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION,ChineseNameOfLangAudioDef.getDefinitionName(Settings.instance.definition));
							this.showTip(TipsDef.TIP_ID_SWAPPING_DEFINITION_DEF);
						} else {
							this.showTip(TipsDef.TIP_ID_SWAPPING_DEF);
						}
					}
				} else if(Settings.instance.definition == DefinitionEnum.FOUR_K || Settings.instance.definition == DefinitionEnum.FULL_HD || Settings.instance.definition == DefinitionEnum.SUPER_HIGH) {
					this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION,ChineseNameOfLangAudioDef.getDefinitionName(Settings.instance.definition));
					this.showTip(TipsDef.TIP_ID_SWAPPING_DEFINITION_DEF);
				} else {
					this.showTip(TipsDef.TIP_ID_SWAPPING_DEF);
				}
				
				TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
				TweenLite.delayedCall(param1 / 1000,this.onPlayerDefinitionSwitchComplete);
			}
		}
		
		private function onPlayerDefinitionSwitchComplete() : void {
			var _loc2_:EnumItem = null;
			var _loc3_:TopBarProxy = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.movieModel) {
				_loc2_ = _loc1_.curActor.movieModel.curDefinitionInfo.type;
				if(_loc2_ == DefinitionEnum.LIMIT) {
					_loc3_ = facade.retrieveProxy(TopBarProxy.NAME) as TopBarProxy;
					if((GlobalStage.isFullScreen()) && !(_loc3_.scaleValue == TopBarDef.SCALE_VALUE_75)) {
						if(TipManager.isShow(TipsDef.TIP_ID_SWAPPING_DEF)) {
							this.hideTip(TipsDef.TIP_ID_SWAPPING_DEF);
						}
						this.showTip(TipsDef.TIP_ID_CHANG_SIZE_75);
					} else {
						this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION,ChineseNameOfLangAudioDef.getDefinitionName(DefinitionEnum.LIMIT));
						this.showTip(TipsDef.TIP_ID_SWAPPED_DEF);
					}
				} else if(_loc2_ == DefinitionEnum.FOUR_K || _loc2_ == DefinitionEnum.FULL_HD || _loc2_ == DefinitionEnum.SUPER_HIGH) {
					this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION,ChineseNameOfLangAudioDef.getDefinitionName(_loc2_));
					this.showTip(TipsDef.TIP_ID_SWAPPED_DEFINITION_DEF);
				} else {
					this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION,ChineseNameOfLangAudioDef.getDefinitionName(_loc2_));
					this.showTip(TipsDef.TIP_ID_SWAPPED_DEF);
				}
				
			}
		}
		
		private function onPlayerAudioTrackSwitched(param1:int) : void {
			this.showTip(TipsDef.TIP_ID_SWAPPING_TRACK);
			TweenLite.killTweensOf(this.onPlayerAudioTrackSwitchComplete);
			TweenLite.delayedCall(param1 / 1000,this.onPlayerAudioTrackSwitchComplete);
		}
		
		private function onPlayerAudioTrackSwitchComplete() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:EnumItem = _loc1_.curActor.movieModel.curAudioTrackInfo.type;
			this.updateTipAttr(TipsDef.TIP_ATTR_NAME_AUDIO_TRACK,ChineseNameOfLangAudioDef.getAudioName(_loc2_));
			this.showTip(TipsDef.TIP_ID_SWAPPED_TRACK);
		}
		
		private function onPlayerStuck() : void {
			var _loc1_:PlayerProxy = null;
			var _loc2_:IAudioTrackInfo = null;
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			var _loc5_:EnumItem = null;
			if((this._tipsProxy.lagDownDefinition(TipsDef.LAG_TIME_SWAP_TIP_QD)) && !Settings.instance.autoMatchRate) {
				_loc1_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if(_loc1_.curActor.movieModel.curDefinitionInfo.type != DefinitionEnum.LIMIT) {
					_loc2_ = _loc1_.curActor.movieModel.curAudioTrackInfo;
					_loc3_ = _loc2_.definitionCount;
					_loc4_ = 0;
					while(_loc4_ < _loc3_) {
						_loc5_ = _loc2_.findDefinitionInfoAt(_loc4_).type;
						if(_loc5_ == DefinitionEnum.LIMIT) {
							this.showTip(TipsDef.TIP_ID_SWAP_TIP_QD);
							break;
						}
						_loc4_++;
					}
				}
			}
		}
		
		private function onPlayerStartFromHistory(param1:int) : void {
			var _loc3_:String = null;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(param1 > TipsDef.HISTORY_MIN_TIME && _loc2_.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_ORIGINAL) {
				_loc3_ = Strings.formatAsTimeCode(param1 / ConstUtils.S_2_MS,_loc2_.curActor.movieModel.duration >= ConstUtils.H_2_MS);
				this.updateTipAttr(TipsDef.TIP_ATTR_NAME_HISTORY_TIME,_loc3_);
				this.showTip(TipsDef.TIP_ID_HISTORY_TIME);
			}
		}
		
		private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void {
			TipManager.setCurrTime(param1 / 1000,Statistics.instance.playDuration / 1000);
		}
		
		private function onTipEvent(param1:TipEvent) : void {
			var event:TipEvent = param1;
			switch(event.type) {
				case TipEvent.ASEvent:
					this.doASEvent(event.eventName);
					break;
				case TipEvent.JSEvent:
					try {
						ExternalInterface.call(event.eventName,event.eventParams);
					}
					catch(error:Error) {
					}
					break;
				case TipEvent.LinkEvent:
					this.doLinkEvent(event.tipId,event.url);
					break;
				case TipEvent.Close:
					break;
				case TipEvent.Error:
					break;
				case TipEvent.Show:
					if(event.tipId == TipsDef.TIP_ID_TRY_WATCH || event.tipId == TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET || event.tipId == TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET || event.tipId == TipsDef.TIP_ID_TRY_WATCH_TOTAL) {
						this._tipsView.setCloseBtnVisible(false);
					} else {
						this._tipsView.setCloseBtnVisible(true);
					}
					this.doShowEvent(event.tipId);
					break;
				case TipEvent.Hide:
					this.onTipHided();
					break;
			}
		}
		
		private function doASEvent(param1:String) : void {
			var _loc4_:PlayerProxy = null;
			var _loc5_:SceneTileProxy = null;
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((_loc2_.hasStatus(ADDef.STATUS_LOADING)) || (_loc2_.hasStatus(ADDef.STATUS_PLAYING)) || (_loc2_.hasStatus(ADDef.STATUS_PAUSED))) {
				return;
			}
			var _loc3_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			switch(param1) {
				case TipsDef.AS_EVENT_NAME_SKIP_SET:
					Settings.instance.skipTrailer = false;
					Settings.instance.skipTitle = false;
					break;
				case TipsDef.AS_EVENT_NAME_WATCH_START:
					sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAY);
					break;
				case TipsDef.AS_EVENT_NAME_SWAPTOQD:
					Settings.instance.autoMatchRate = false;
					Settings.instance.definition = DefinitionEnum.LIMIT;
					break;
				case TipsDef.AS_EVENT_NAME_SCREEN_DEFAULT:
					sendNotification(TopBarDef.NOTIFIC_REQUEST_SCALE,TopBarDef.SCALE_VALUE_100);
					break;
				case TipsDef.AS_EVENT_NAME_SWITCHOVER_NEXT:
					_loc3_.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
					sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
					break;
				case TipsDef.AS_EVENT_NAME_TRY_WATCH_BUY:
					GlobalStage.setNormalScreen();
					_loc3_.callJsRecharge("Q00304",1);
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
					break;
				case TipsDef.AS_EVENT_NAME_TRY_WATCH_USE_TICKET:
					GlobalStage.setNormalScreen();
					_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(_loc4_.curActor.movieModel) {
						this._tipsProxy.requestUseTicket(_loc4_.curActor.movieModel.albumId);
					}
					break;
				case TipsDef.AS_EVENT_NAME_LOGIN:
					GlobalStage.setNormalScreen();
					_loc5_ = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
					_loc5_.requestLogin();
					break;
			}
			this.hideTip();
		}
		
		private function onTipHided() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.isTryWatch) {
				this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
				if(_loc1_.curActor.tryWatchType == TryWatchEnum.TOTAL) {
					this.showTip(TipsDef.TIP_ID_TRY_WATCH_TOTAL);
				} else if(_loc1_.curActor.authenticationTipType == TipsDef.AUTH_TIP_TYPE_NOT_TICKET) {
					this.showTip(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET);
				} else if(_loc1_.curActor.authenticationTipType == TipsDef.AUTH_TIP_TYPE_TICKET) {
					this.showTip(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET);
				} else {
					this.showTip(TipsDef.TIP_ID_TRY_WATCH);
				}
				
				
			}
		}
		
		private function checkTipsLocation() : void {
			var _loc1_:ControllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
			if(_loc1_.hasStatus(ControllBarDef.STATUS_SHOW)) {
				if(_loc1_.hasStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW)) {
					if(_loc1_.hasStatus(ControllBarDef.STATUS_SEEK_BAR_THICK)) {
						this._tipsView.setGap(TipsDef.STAGE_GAP_1);
					} else {
						this._tipsView.setGap(TipsDef.STAGE_GAP_2);
					}
				} else {
					this._tipsView.setGap(TipsDef.STAGE_GAP_4);
				}
			} else {
				this._tipsView.setGap(TipsDef.STAGE_GAP_3);
			}
		}
		
		private function doLinkEvent(param1:String, param2:String) : void {
			GlobalStage.setNormalScreen();
			switch(param1) {
				case TipsDef.TIP_ID_AD_NOTICE_BUY_VIP_TIPS:
					navigateToURL(new URLRequest(param2),"_blank");
					this.hideTip();
					return;
				default:
					navigateToURL(new URLRequest(param2),"_self");
					this.hideTip();
					return;
			}
		}
		
		private function doShowEvent(param1:String) : void {
			switch(param1) {
				case TipsDef.TIP_ID_AD_NOTICE_BUY_VIP_TIPS:
					PingBack.getInstance().playerActionPing(PingBackDef.SHOW_BUY_VIP_TIPS);
					break;
			}
		}
	}
}
