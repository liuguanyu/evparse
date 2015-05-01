package com.qiyi.player.wonder.plugins.controllbar.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.common.sw.ISwitch;
	import com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.iqiyi.components.global.GlobalStage;
	import flash.events.KeyboardEvent;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.plugins.loading.LoadingDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import com.qiyi.player.core.model.ISkipPointInfo;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.core.player.def.SeekTypeEnum;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.plugins.tips.TipsDef;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import flash.ui.Mouse;
	import gs.TweenLite;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.plugins.controllbar.view.preview.image.PreviewImageLoader;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.core.player.def.PauseTypeEnum;
	import com.qiyi.player.core.player.LoadMovieParams;
	import com.qiyi.player.core.model.impls.ScreenInfo;
	import com.qiyi.player.wonder.plugins.loading.model.LoadingProxy;
	import com.qiyi.player.core.model.IMovieModel;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.core.model.def.ScreenEnum;
	import flash.geom.Point;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.core.model.def.SkipPointEnum;
	
	public class ControllBarViewMediator extends Mediator implements ISwitch {
		
		public function ControllBarViewMediator(param1:ControllBarView) {
			super(NAME,param1);
			this._controllBarView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.controllbar.view.ControllBarViewMediator";
		
		private var _controllBarProxy:ControllBarProxy;
		
		private var _controllBarView:ControllBarView;
		
		private var _frameCount:uint;
		
		private var _isUserSeek:Boolean = false;
		
		override public function onRegister() : void {
			super.onRegister();
			SwitchManager.getInstance().register(this);
			this._controllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
			this._controllBarView.addEventListener(ControllBarEvent.Evt_Open,this.onControllBarViewOpen);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_Close,this.onControllBarViewClose);
			this._controllBarView.seekBarView.addEventListener(ControllBarEvent.Evt_Seek,this.onControllBarViewSeek);
			this._controllBarView.seekBarView.addEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick,this.onImagePreViewGoodsClick);
			this._controllBarView.seekBarView.addEventListener(ControllBarEvent.Evt_ImagePreviewVedioShow,this.onImagePreviewVedioShow);
			this._controllBarView.volumeControlView.addEventListener(ControllBarEvent.Evt_VolumeChanged,this.onVolumeChanged);
			this._controllBarView.volumeControlView.addEventListener(ControllBarEvent.Evt_VolumeMuteChanged,this.onVolumeMuteChanged);
			this._controllBarView.loadingBtn.addEventListener(MouseEvent.CLICK,this.onLoadingBtnClick);
			this._controllBarView.playBtn.addEventListener(MouseEvent.CLICK,this.onPlayBtnClick);
			this._controllBarView.pauseBtn.addEventListener(MouseEvent.CLICK,this.onPauseBtnClick);
			this._controllBarView.replayBtn.addEventListener(MouseEvent.CLICK,this.onReplayBtnClick);
			this._controllBarView.unFoldBtn.addEventListener(MouseEvent.CLICK,this.onUnFoldBtnClick);
			this._controllBarView.foldBtn.addEventListener(MouseEvent.CLICK,this.onFoldBtnClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_D3BtnClick,this.onD3BtnClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_FilterOpenClick,this.onFilterBtnClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_FilterCloseClick,this.onFilterSeletedBtnClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_CaptionOrTrackBtnClick,this.onCaptionOrTrackClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_RepeatBtnClicked,this.onRepeatBtnClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_NextVideoBtnClicked,this.onNextVideoBtnClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_TvListBtnClicked,this.onTvListBtnClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_DefinitionBtnClicked,this.onDefinitionBtnClick);
			this._controllBarView.addEventListener(ControllBarEvent.Evt_DefinitionBtnLocationChange,this.onDefinitionBtnLocationChange);
			this._controllBarView.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove);
			GlobalStage.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			GlobalStage.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			this.onStageMouseMove();
			this._controllBarProxy.isFullScreen = GlobalStage.isFullScreen();
			var _loc1_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			this._controllBarView.repeatSubBtnVisible = _loc1_.isCyclePlay;
		}
		
		override public function listNotificationInterests() : Array {
			return [ControllBarDef.NOTIFIC_ADD_STATUS,ControllBarDef.NOTIFIC_REMOVE_STATUS,ControllBarDef.NOTIFIC_FILTER_OPEN,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,BodyDef.NOTIFIC_PLAYER_REPLAYED,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_JS_LIGHT_CHANGED,BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO,BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE,BodyDef.NOTIFIC_JS_EXPAND_CHANGED,BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED,BodyDef.NOTIFIC_JS_CALL_SEEK,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,BodyDef.NOTIFIC_PLAYER_OUT_SKIP_POINT,BodyDef.NOTIFIC_PLAYER_ENTER_SKIP_POINT,BodyDef.NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT,BodyDef.NOTIFIC_PLAYER_FRESHED_SKIP_POINT,BodyDef.NOTIFIC_PLAYER_ENJOY_TYPE_INITED,BodyDef.NOTIFIC_LEAVE_STAGE,ContinuePlayDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED,ContinuePlayDef.NOTIFIC_CYCLE_PLAY_CHANGED,ADDef.NOTIFIC_ADD_STATUS,ADDef.NOTIFIC_REMOVE_STATUS,LoadingDef.NOTIFIC_ADD_STATUS,LoadingDef.NOTIFIC_REMOVE_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc6_:SettingProxy = null;
			var _loc7_:ISkipPointInfo = null;
			var _loc8_:ISkipPointInfo = null;
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			var _loc5_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			switch(_loc3_) {
				case ControllBarDef.NOTIFIC_ADD_STATUS:
					this._controllBarView.onAddStatus(int(_loc2_));
					break;
				case ControllBarDef.NOTIFIC_REMOVE_STATUS:
					this._controllBarView.onRemoveStatus(int(_loc2_));
					break;
				case ControllBarDef.NOTIFIC_FILTER_OPEN:
					if(Boolean(_loc2_)) {
						this.onFilterBtnClick();
					} else {
						this.onFilterSeletedBtnClick();
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_FRESHED_SKIP_POINT:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR && (this.checkFilterBtnState()) && (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE))) {
						if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
							this._controllBarView.updateFilterBtnType(true);
							this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
							if(!this.checkInEnjoyableSkipType()) {
								_loc7_ = this.checkHasNestEnjoableSkip();
								if(_loc7_ != null) {
									this.onPlayerSeeking(_loc7_.startTime,SeekTypeEnum.SKIP_ENJOYABLE_POINT);
								} else {
									this.firstEnjoyableSkipPointPlay();
								}
							}
						}
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_ENJOY_TYPE_INITED:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR && (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE)) && (this.checkFilterBtnState())) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
						if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
							this._controllBarView.updateFilterBtnType(true);
							this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
						}
						this._controllBarView.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_REPLAYED:
					if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
						this.firstEnjoyableSkipPointPlay();
						if(this.checkFilterBtnState()) {
							this.showOpenFilterTip();
						}
						PingBack.getInstance().filterPing(PingBackDef.FILTER_CONTINUE_PLAY);
					}
					this.onUpdateContinuePlayBtns();
					break;
				case BodyDef.NOTIFIC_PLAYER_ENTER_SKIP_POINT:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this._isUserSeek = false;
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_OUT_SKIP_POINT:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR && (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))) {
						_loc8_ = this.checkHasNestEnjoableSkip();
						if(!this.checkInEnjoyableSkipType()) {
							if(_loc8_ != null) {
								if(!this._isUserSeek) {
									this.onPlayerSeeking(_loc8_.startTime,SeekTypeEnum.SKIP_ENJOYABLE_POINT);
									sendNotification(SettingDef.NOTIFIC_FILTER_SKIP_MOVIECLIP);
								} else {
									this._isUserSeek = false;
								}
							} else if(!this._isUserSeek) {
								sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
							} else {
								this._isUserSeek = false;
							}
							
						}
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT:
					_loc6_ = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR && (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))) {
						if(this.checkHasNestEnjoableSkip() != null) {
							sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_FILTER_NEST_ENJOYABLE_TIP);
						}
					}
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._controllBarView.onResize(_loc2_.w,_loc2_.h);
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
				case BodyDef.NOTIFIC_PLAYER_REPLAYED:
					this.onUpdateContinuePlayBtns();
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					this.onFullScreenSwitch(Boolean(_loc2_));
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this.onPlayerSwitchPreActor();
					break;
				case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
					this._controllBarProxy.playerLightOn = Boolean(_loc2_);
					if((this._controllBarProxy.playerLightOn) && !this._controllBarProxy.hasStatus(ControllBarDef.STATUS_SHOW) && (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR))) {
						if(_loc5_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
							Mouse.show();
							this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
						}
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:
					if((Boolean(_loc2_.continuePlay)) && (this.checkNextBtnShow())) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:
					if((Boolean(_loc2_)) && (this.checkNextBtnShow())) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					}
					break;
				case BodyDef.NOTIFIC_LEAVE_STAGE:
					TweenLite.killTweensOf(this.hideSeekBar);
					this.hideSeekBar();
					break;
				case ContinuePlayDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == ContinuePlayDef.STATUS_OPEN) {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW);
					}
					break;
				case ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED:
					if(this.checkNextBtnShow()) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					}
					if(this.checkTvListBtnShow()) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
						if(this.isTvListChannels()) {
							this._controllBarProxy.addStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
						} else {
							this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
						}
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
					}
					break;
				case ContinuePlayDef.NOTIFIC_CYCLE_PLAY_CHANGED:
					this._controllBarView.repeatSubBtnVisible = Boolean(_loc2_);
					break;
				case BodyDef.NOTIFIC_JS_EXPAND_CHANGED:
					if(Boolean(_loc2_)) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
					}
					break;
				case BodyDef.NOTIFIC_JS_CALL_SEEK:
					this.onPlayerSeeking(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					if(_loc2_) {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_OPEN);
					} else {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_OPEN);
					}
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADPlayerStatusChanged(int(_loc2_),true);
					break;
				case ADDef.NOTIFIC_REMOVE_STATUS:
					this.onADPlayerStatusChanged(int(_loc2_),false);
					break;
				case LoadingDef.NOTIFIC_ADD_STATUS:
					this.onLoadingStatusChanged(int(_loc2_),true);
					break;
				case LoadingDef.NOTIFIC_REMOVE_STATUS:
					this.onLoadingStatusChanged(int(_loc2_),false);
					break;
				case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerDefinitionSwitched(int(_loc2_));
					}
					break;
			}
		}
		
		public function getSwitchID() : Vector.<int> {
			return Vector.<int>([SwitchDef.ID_SHOW_CONTROL_BAR,SwitchDef.ID_SHOW_CONTROL_BAR_SEEK_BAR,SwitchDef.ID_SHOW_CONTROL_BAR_LOOP_PLAY_BTN,SwitchDef.ID_SHOW_CONTROL_BAR_NEXT_BTN,SwitchDef.ID_SHOW_CONTROL_BAR_TIME,SwitchDef.ID_SHOW_CONTROL_BAR_VOLUME,SwitchDef.ID_SHOW_CONTROL_BAR_FULLSCREEN,SwitchDef.ID_SHOW_CONTROL_BAR_SETTING,SwitchDef.ID_SHOW_CONTROL_BAR_CAPTURE,SwitchDef.ID_SHOW_CONTROL_BAR_CAPTION,SwitchDef.ID_SHOW_CONTROL_BAR_TRACK,SwitchDef.ID_SHOW_CONTROL_BAR_EXPAND_BTN,SwitchDef.ID_SHOW_CONTROL_BAR_TVLIST_BTN,SwitchDef.ID_SHOW_CONTROL_BAR_3D_BTN,SwitchDef.ID_SHOW_CONTROL_BAR_SKIP_TIP,SwitchDef.ID_SHOW_CONTROL_BAR_VIEW_TIP,SwitchDef.ID_SHOW_CONTROL_BAR_PREVIEW,SwitchDef.ID_SHOW_CONTROL_BAR_FF]);
		}
		
		public function onSwitchStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case SwitchDef.ID_SHOW_CONTROL_BAR:
					if(param2) {
						Mouse.show();
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
					} else {
						if(GlobalStage.isFullScreen()) {
							Mouse.hide();
						}
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_SEEK_BAR:
					if(param2) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_LOOP_PLAY_BTN:
					if(param2) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_NEXT_BTN:
					if(param2) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_TIME:
					if(param2) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_TIME_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TIME_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_VOLUME:
					if(param2) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_FULLSCREEN:
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_SETTING:
				case SwitchDef.ID_SHOW_CONTROL_BAR_CAPTURE:
				case SwitchDef.ID_SHOW_CONTROL_BAR_CAPTION:
				case SwitchDef.ID_SHOW_CONTROL_BAR_TRACK:
				case SwitchDef.ID_SHOW_CONTROL_BAR_EXPAND_BTN:
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_TVLIST_BTN:
					if((param2) && (this.checkTvListBtnShow())) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
					} else {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_3D_BTN:
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_SKIP_TIP:
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_VIEW_TIP:
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_PREVIEW:
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_FF:
					break;
				case SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE:
					if(param2) {
						if(GlobalStage.isFullScreen()) {
							Mouse.hide();
						}
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SHOW);
					} else {
						Mouse.show();
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
					}
			}
		}
		
		private function onControllBarViewOpen(param1:ControllBarEvent) : void {
			if(!this._controllBarProxy.hasStatus(ControllBarDef.STATUS_OPEN)) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_OPEN);
			}
		}
		
		private function onControllBarViewClose(param1:ControllBarEvent) : void {
			if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_OPEN)) {
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_OPEN);
			}
		}
		
		private function onControllBarViewSeek(param1:ControllBarEvent) : void {
			var _loc2_:SettingProxy = null;
			this.onPlayerSeeking(int(param1.data));
			this._controllBarProxy.seekCount = this._controllBarProxy.seekCount + 1;
			if(this.checkFilterTipShow()) {
				_loc2_ = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
				if(!this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && !_loc2_.hasStatus(SettingDef.STATUS_FILTER_OPEN)) {
					sendNotification(ControllBarDef.NOTIFIC_SCENE_TILE_TOOL_TIP);
				}
			}
			if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
				this._isUserSeek = this.checkInEnjoyableSkipType()?false:true;
			}
		}
		
		private function onImagePreViewGoodsClick(param1:ControllBarEvent) : void {
			GlobalStage.setNormalScreen();
			var _loc2_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc2_.callJsFindGoods(int(Number(param1.data) / 1000));
		}
		
		private function onImagePreviewVedioShow(param1:ControllBarEvent) : void {
			if(param1.data) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW);
			} else {
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW);
				this.hideSeekBar();
			}
		}
		
		private function onPlayerSeeking(param1:int, param2:int = 0) : void {
			var _loc3_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((_loc3_.hasStatus(ADDef.STATUS_PLAYING)) || (_loc3_.hasStatus(ADDef.STATUS_PAUSED)) || (_loc3_.hasStatus(ADDef.STATUS_LOADING))) {
				return;
			}
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)) || (_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING)) || (_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING)) || (_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING))) {
				if(param1 < 0) {
					var param1:* = 0;
				} else if(param1 > _loc4_.curActor.movieModel.duration) {
					param1 = _loc4_.curActor.movieModel.duration;
				}
				
				PingBack.getInstance().dragActionPing(_loc4_.curActor.currentTime,param1,uint(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)));
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
				if(_loc4_.curActor.movieModel.duration - param1 < 2000) {
					param1 = _loc4_.curActor.movieModel.duration - 2000;
				}
				sendNotification(BodyDef.NOTIFIC_PLAYER_SEEK,{
					"time":param1,
					"type":param2
				});
				if(_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)) {
					sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
					sendNotification(ADDef.NOTIFIC_RESUME);
					GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
				}
				if(this._controllBarView.seekBarView.seekClickCount == 3) {
					sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_HOT_KEY_FF);
				}
			}
		}
		
		private function onVolumeChanged(param1:ControllBarEvent) : void {
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			Settings.instance.volumn = int(param1.data.volume);
			_loc2_.mute = Settings.instance.mute = Settings.instance.volumn <= 0;
			sendNotification(ADDef.NOTIFIC_AD_VOLUMN_CHANGED);
			if(Boolean(param1.data.tip)) {
				this.addVolumeTip();
			}
		}
		
		private function onVolumeMuteChanged(param1:ControllBarEvent) : void {
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((_loc2_.hasStatus(ADDef.STATUS_PLAYING)) || (_loc2_.hasStatus(ADDef.STATUS_PAUSED))) {
				_loc2_.mute = Boolean(param1.data);
				if(!_loc2_.mute) {
					Settings.instance.mute = _loc2_.mute;
					Settings.instance.volumn = this._controllBarView.volumeControlView.currentVolume == 0?60:this._controllBarView.volumeControlView.currentVolume;
				}
			} else {
				_loc2_.mute = Settings.instance.mute = Boolean(param1.data);
				if(!Settings.instance.mute) {
					Settings.instance.volumn = this._controllBarView.volumeControlView.currentVolume == 0?60:this._controllBarView.volumeControlView.currentVolume;
				} else {
					Settings.instance.volumn = 0;
				}
			}
			sendNotification(ADDef.NOTIFIC_AD_VOLUMN_CHANGED);
			this.addVolumeTip();
		}
		
		private function onPlayerSwitchPreActor() : void {
			this.onPlayerSwitchStoppedFailedLoaded();
			TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc3_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				PreviewImageLoader.instance.clearImageData();
				this._controllBarView.seekBarView.setTotalTime(_loc1_.curActor.movieModel.duration);
				this._controllBarView.seekBarView.setImagePrePicUrlArr(this.getImageUrlList());
				this._controllBarView.seekBarView.setCurrentTime(0);
				this._controllBarView.seekBarView.setHeadTailPoint(_loc1_.curActor.movieModel.titlesTime,_loc1_.curActor.movieModel.trailerTime);
				if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
					this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
				}
				this._controllBarView.currentDefinitionInfo = _loc1_.curActor.movieModel.curDefinitionInfo.type;
				this.onUpdateContinuePlayBtns();
				if(!Settings.instance.mute) {
					this._controllBarView.volumeControlView.updateVolumeControlView(Settings.instance.volumn,false,false);
				}
				this.showExpandBtn();
			}
			this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
			this._controllBarProxy.seekCount = 0;
			this._controllBarProxy.isFirstPlay = true;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)) {
				this._controllBarView.seekBarView.setViewPoints(_loc1_.curActor.movieInfo.focusTips);
				this._controllBarView.seekBarView.setMerchandiseViewPoints(_loc3_.viewPoints);
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
			this._controllBarView.onUserInfoChanged(_loc2_);
		}
		
		private function onPlayBtnClick(param1:MouseEvent) : void {
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(!_loc2_.hasStatus(ADDef.STATUS_PLAYING) && !_loc2_.hasStatus(ADDef.STATUS_PAUSED)) {
				sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
				GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
			}
			sendNotification(ADDef.NOTIFIC_RESUME);
		}
		
		private function onPauseBtnClick(param1:MouseEvent) : void {
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(!_loc2_.hasStatus(ADDef.STATUS_PLAYING) && !_loc2_.hasStatus(ADDef.STATUS_PAUSED)) {
				sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE,PauseTypeEnum.USER);
				GlobalStage.stage.dispatchEvent(new Event("tmp_dis_pause_to_p2p"));
			}
			sendNotification(ADDef.NOTIFIC_PAUSE);
		}
		
		private function onLoadingBtnClick(param1:MouseEvent) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(!_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) && (_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))) {
				if((_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING)) || (_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING))) {
					sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE,PauseTypeEnum.USER);
					sendNotification(ADDef.NOTIFIC_PAUSE);
					GlobalStage.stage.dispatchEvent(new Event("tmp_dis_pause_to_p2p"));
				}
			}
		}
		
		private function onReplayBtnClick(param1:MouseEvent) : void {
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(!_loc2_.hasStatus(ADDef.STATUS_PLAYING) && !_loc2_.hasStatus(ADDef.STATUS_PAUSED) && !_loc2_.hasStatus(ADDef.STATUS_LOADING)) {
				sendNotification(ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO);
				PingBack.getInstance().userActionPing(PingBackDef.REPLAY);
			}
		}
		
		private function onUnFoldBtnClick(param1:MouseEvent) : void {
			var _loc2_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc2_.callJsExpand(true);
			PingBack.getInstance().userActionPing(PingBackDef.EXPAND_SCREEN);
		}
		
		private function onFoldBtnClick(param1:MouseEvent) : void {
			var _loc2_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc2_.callJsExpand(false);
			PingBack.getInstance().userActionPing(PingBackDef.UN_EXPAND_SCREEN);
		}
		
		private function onRepeatBtnClick(param1:ControllBarEvent) : void {
			var _loc2_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			_loc2_.isCyclePlay = Boolean(param1.data);
			if(_loc2_.isCyclePlay) {
				sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_LOOP_ON);
				PingBack.getInstance().cyclePlayPing(PingBackDef.USER_ACTION,PingBackDef.USER_ACTION);
			} else {
				sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_LOOP_OFF);
			}
		}
		
		private function onNextVideoBtnClick(param1:ControllBarEvent) : void {
			var _loc2_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc2_.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
			sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
			PingBack.getInstance().nextPing();
		}
		
		private function onTvListBtnClick(param1:ControllBarEvent) : void {
			var _loc2_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			if(_loc2_.hasStatus(ContinuePlayDef.STATUS_OPEN)) {
				sendNotification(ContinuePlayDef.NOTIFIC_OPEN_CLOSE,false);
			} else {
				sendNotification(ContinuePlayDef.NOTIFIC_OPEN_CLOSE,true);
				PingBack.getInstance().userActionPing(PingBackDef.SHOW_TVLIST);
			}
		}
		
		private function onD3BtnClick(param1:ControllBarEvent) : void {
			var _loc3_:LoadMovieParams = null;
			var _loc4_:ScreenInfo = null;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(Boolean(param1.data)) {
				_loc4_ = _loc2_.curActor.get3DScreenInfo();
				if(_loc4_) {
					_loc3_ = _loc2_.curActor.loadMovieParams.clone();
					_loc3_.tvid = _loc4_.tvid;
					_loc3_.vid = _loc4_.vid;
					sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE,ContinuePlayDef.SWITCH_VIDEO_TYPE_2D_3D_BTN);
					sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,_loc3_,BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D);
				}
			} else {
				_loc4_ = _loc2_.curActor.get2DScreenInfo();
				if(_loc4_) {
					_loc3_ = _loc2_.curActor.loadMovieParams.clone();
					_loc3_.tvid = _loc4_.tvid;
					_loc3_.vid = _loc4_.vid;
					sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE,ContinuePlayDef.SWITCH_VIDEO_TYPE_2D_3D_BTN);
					sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE,_loc3_,BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D);
				}
			}
		}
		
		private function onDefinitionBtnClick(param1:ControllBarEvent) : void {
			var _loc2_:SettingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			if(_loc2_.hasStatus(SettingDef.STATUS_DEFINITION_OPEN)) {
				sendNotification(SettingDef.NOTIFIC_DEFINITION_OPEN_CLOSE,false);
			} else {
				sendNotification(SettingDef.NOTIFIC_DEFINITION_OPEN_CLOSE,true);
			}
		}
		
		private function onDefinitionBtnLocationChange(param1:ControllBarEvent) : void {
			this._controllBarProxy.definitionBtnX = param1.data.x;
			this._controllBarProxy.definitionBtnY = param1.data.y;
			this._controllBarProxy.filterBtnX = param1.data.filterBtnX;
			sendNotification(ControllBarDef.NOTIFIC_DEF_BTN_POS_CHANGE);
		}
		
		private function onFilterBtnClick(param1:ControllBarEvent = null) : void {
			var _loc3_:ISkipPointInfo = null;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			_loc2_.preActor.openSelectPlay = _loc2_.curActor.openSelectPlay = true;
			this._controllBarProxy.addStatus(ControllBarDef.STATUS_FILTER_OPEN);
			this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
			this.showOpenFilterTip();
			sendNotification(SettingDef.NOTIFIC_FILTER_OPEN_CLOSE,true);
			PingBack.getInstance().filterPing(PingBackDef.FILTER_OPEN);
			if(!this.checkInEnjoyableSkipType()) {
				_loc3_ = this.checkHasNestEnjoableSkip();
				if(_loc3_ != null) {
					this.onPlayerSeeking(_loc3_.startTime,SeekTypeEnum.SKIP_ENJOYABLE_POINT);
				} else {
					this.firstEnjoyableSkipPointPlay();
				}
			}
		}
		
		private function onFilterSeletedBtnClick(param1:ControllBarEvent = null) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:SettingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
			_loc2_.preActor.openSelectPlay = _loc2_.curActor.openSelectPlay = false;
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_OPEN);
			this._controllBarView.seekBarView.setSkipPoints(null);
			sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_FILTER_CLOSE_TIP);
			sendNotification(SettingDef.NOTIFIC_FILTER_OPEN_CLOSE,false);
			PingBack.getInstance().filterPing(PingBackDef.FILTER_CLOSE);
			this.onPlayerSeeking(_loc2_.curActor.currentTime);
		}
		
		private function onCaptionOrTrackClick(param1:ControllBarEvent) : void {
			sendNotification(SettingDef.NOTIFIC_OPEN_CLOSE);
		}
		
		private function onEnterFrame(param1:Event) : void {
			var _loc2_:PlayerProxy = null;
			this._frameCount++;
			if(this._frameCount % 2 == 0) {
				this._frameCount = 0;
				_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				if((_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING)) || (_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING)) || (_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) || (_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))) {
					this._controllBarView.onPlayerRunning(_loc2_.curActor.currentTime,_loc2_.curActor.bufferTime,_loc2_.curActor.movieModel.duration,this._controllBarProxy.keyDownSeeking);
				}
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			var _loc8_:ContinuePlayProxy = null;
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			var _loc4_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc5_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc6_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			var _loc7_:LoadingProxy = null;
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
					if(param2) {
						PreviewImageLoader.instance.clearImageData();
						this._controllBarView.seekBarView.setTotalTime(_loc4_.curActor.movieModel.duration);
						this._controllBarView.seekBarView.setImagePrePicUrlArr(this.getImageUrlList());
						this._controllBarView.seekBarView.setCurrentTime(0);
						this._controllBarView.seekBarView.setHeadTailPoint(_loc4_.curActor.movieModel.titlesTime,_loc4_.curActor.movieModel.trailerTime);
						if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
							this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
						}
						TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
						this._controllBarView.currentDefinitionInfo = _loc4_.curActor.movieModel.curDefinitionInfo.type;
						this.onUpdateContinuePlayBtns();
						this.showExpandBtn();
						this._controllBarProxy.seekCount = 0;
						this._controllBarProxy.isFirstPlay = true;
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2) {
						this._controllBarView.seekBarView.setViewPoints(_loc4_.curActor.movieInfo.focusTips);
						if(!Settings.instance.mute) {
							this._controllBarView.volumeControlView.updateVolumeControlView(Settings.instance.volumn,false,false);
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
					if(param2) {
						this._controllBarView.seekBarView.setMerchandiseViewPoints(_loc6_.viewPoints);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
						if(!this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE)) {
							if(!Settings.instance.mute) {
								this._controllBarView.volumeControlView.updateVolumeControlView(Settings.instance.volumn,false,false);
							}
						}
						this.initBtns();
						this.skipPointInFirstPlay();
					}
					break;
				case BodyDef.PLAYER_STATUS_PAUSED:
					if(param2) {
						if(this.checkPauseBtnStatus()) {
							this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
						}
					} else if((_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) || (_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING))) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
					}
					
					break;
				case BodyDef.PLAYER_STATUS_WAITING:
				case BodyDef.PLAYER_STATUS_SEEKING:
					if((param2) && !_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
						_loc7_ = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
						if(!_loc7_.hasStatus(LoadingDef.STATUS_OPEN)) {
							this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPPING:
					if(param2) {
						this.onPlayerSwitchStoppedFailedLoaded();
						this._controllBarView.adjustDisplayTimeOnStoped();
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						this.onPlayerSwitchStoppedFailedLoaded();
						if(!_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)) {
							this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
							_loc7_ = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
							if(!_loc7_.hasStatus(LoadingDef.STATUS_OPEN)) {
								this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
							}
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2) {
						this.onPlayerSwitchStoppedFailedLoaded();
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPED:
					if((param2) && (this.checkShowStatus())) {
						_loc8_ = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
						if(!_loc8_.isContinue) {
							Mouse.show();
							this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
						} else if((_loc8_.isContinue) && !_loc8_.findNextContinueInfo(_loc4_.curActor.loadMovieParams.tvid,_loc4_.curActor.loadMovieParams.vid)) {
							Mouse.show();
							this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
						}
						
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
					if(param2) {
					}
					break;
			}
		}
		
		private function onPlayerSwitchStoppedFailedLoaded() : void {
			if(this._controllBarView.seekBarView.videoHeadTailTipPanel.parent) {
				GlobalStage.stage.removeChild(this._controllBarView.seekBarView.videoHeadTailTipPanel);
			}
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
			this.deinitBtns();
		}
		
		private function onADPlayerStatusChanged(param1:int, param2:Boolean) : void {
			var _loc4_:PlayerProxy = null;
			var _loc3_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			switch(param1) {
				case ADDef.STATUS_PLAYING:
					if(param2) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
						if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE)) {
							this.deinitBtns();
						}
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TIME_SHOW);
						this.onUpdateContinuePlayBtns();
					}
					break;
				case ADDef.STATUS_PAUSED:
					if(param2) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
					}
					break;
				case ADDef.STATUS_PLAY_END:
					_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(_loc4_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED)) {
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
						this._controllBarProxy.addStatus(ControllBarDef.STATUS_TIME_SHOW);
					}
					_loc3_.mute = Settings.instance.mute;
					this._controllBarView.volumeControlView.updateVolumeControlView(Settings.instance.mute?0:Settings.instance.volumn,false,false);
					break;
			}
		}
		
		private function onLoadingStatusChanged(param1:int, param2:Boolean) : void {
			var _loc3_:PlayerProxy = null;
			switch(param1) {
				case LoadingDef.STATUS_OPEN:
					if(param2) {
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
					} else {
						_loc3_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						if((this._controllBarProxy.hasStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW)) && !_loc3_.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) {
							this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
						}
					}
					break;
			}
		}
		
		private function onPlayerDefinitionSwitched(param1:int) : void {
			if(param1 >= 0) {
				TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
				TweenLite.delayedCall(param1 / 1000,this.onPlayerDefinitionSwitchComplete);
			}
		}
		
		private function onPlayerDefinitionSwitchComplete() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((_loc1_.curActor.movieModel) && (_loc1_.curActor.movieModel.curDefinitionInfo)) {
				if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_DEFINITION_SHOW)) {
					this._controllBarView.updateDefinitionBtn(_loc1_.curActor.movieModel.curDefinitionInfo.type);
				} else {
					this._controllBarView.currentDefinitionInfo = _loc1_.curActor.movieModel.curDefinitionInfo.type;
				}
			}
		}
		
		private function checkPreviewTipEnable() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:IMovieModel = _loc1_.curActor.movieModel;
			if((_loc2_) && (!_loc2_.member) && FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE) {
				return true;
			}
			return false;
		}
		
		private function initBtns() : void {
			if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE)) {
				return;
			}
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:SwitchManager = SwitchManager.getInstance();
			if(_loc2_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_SEEK_BAR)) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW);
			}
			if(_loc2_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_LOOP_PLAY_BTN)) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW);
			}
			if(this.checkTvListBtnShow()) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
				if(this.isTvListChannels()) {
					this._controllBarProxy.addStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
				} else {
					this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
				}
			}
			if(_loc2_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_3D_BTN)) {
				if((_loc1_.curActor.get3DScreenInfo()) || (_loc1_.curActor.get2DScreenInfo())) {
					this._controllBarProxy.addStatus(ControllBarDef.STATUS_3D_BTN_SHOW);
					this._controllBarView.updateD3BtnVisible(_loc1_.curActor.movieModel.screenType == ScreenEnum.THREE_D);
				} else {
					this._controllBarProxy.removeStatus(ControllBarDef.STATUS_3D_BTN_SHOW);
				}
			}
			if(_loc2_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_TIME)) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_TIME_SHOW);
			}
			if(this.checkFilterBtnState()) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
				if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
					this._controllBarView.updateFilterBtnType(true);
					this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
				}
			}
			if(_loc2_.getStatus(SwitchDef.ID_SHOW_DOCK_DEFINITION)) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_DEFINITION_SHOW);
			}
			if((_loc2_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_CAPTION)) && _loc1_.curActor.movieInfo.subtitles.length >= 1) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_CAPTION_BTN_SHOW);
			}
			if((_loc2_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_TRACK)) && _loc1_.curActor.movieInfo.subtitles.length < 1 && _loc1_.curActor.movieModel.audioTrackCount > 1) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRACK_BTN_SHOW);
			}
			this._controllBarProxy.addStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE,false);
			this._controllBarView.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		private function skipPointInFirstPlay() : void {
			if((this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE)) && !this._controllBarProxy.isFirstPlay) {
				return;
			}
			this._controllBarProxy.isFirstPlay = false;
			if(this.checkFilterBtnState()) {
				if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
					this._controllBarView.updateFilterBtnType(true);
					this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
					this.firstEnjoyableSkipPointPlay();
					this.showOpenFilterTip();
					PingBack.getInstance().filterPing(PingBackDef.FILTER_CONTINUE_PLAY);
				}
			}
		}
		
		private function deinitBtns() : void {
			var _loc1_:ADProxy = null;
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW);
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW);
			if((this._controllBarProxy.hasStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW)) || (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_LIST_BTN_SHOW))) {
				_loc1_ = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
				if(!_loc1_.hasStatus(ADDef.STATUS_PLAYING) && !_loc1_.hasStatus(ADDef.STATUS_PAUSED)) {
					this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
					this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
				}
			}
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TIME_SHOW);
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_3D_BTN_SHOW);
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_CAPTION_BTN_SHOW);
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TRACK_BTN_SHOW);
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_DEFINITION_SHOW);
			this._controllBarProxy.removeStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE,false);
		}
		
		private function onFullScreenSwitch(param1:Boolean) : void {
			var _loc2_:Point = null;
			if(param1) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
			} else {
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
			}
			if(this.checkTvListBtnShow()) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
				if(this.isTvListChannels()) {
					this._controllBarProxy.addStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
				} else {
					this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
				}
			} else {
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
			}
			this.showExpandBtn();
			if((SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR)) && !this._controllBarProxy.hasStatus(ControllBarDef.STATUS_SHOW)) {
				Mouse.show();
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
			}
			if(this._controllBarProxy.isFullScreen == param1) {
				this._controllBarView.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
			} else {
				this._controllBarProxy.isFullScreen = param1;
			}
			if(!param1) {
				this._controllBarView.seekBarView.hideImagePreview();
			}
			if(GlobalStage.stage.focus == null) {
				GlobalStage.stage.focus = GlobalStage.stage;
			}
			if(this._controllBarView.volumeControlView.volumeTip.parent) {
				_loc2_ = this._controllBarView.volumeControlView.localToGlobal(new Point(this._controllBarView.volumeControlView.tipX,this._controllBarView.volumeControlView.tipY));
				this._controllBarView.volumeControlView.volumeTip.x = _loc2_.x;
				this._controllBarView.volumeControlView.volumeTip.y = _loc2_.y;
			}
		}
		
		private function showExpandBtn() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_EXPAND_BTN)) {
				if(!GlobalStage.isFullScreen() && !_loc1_.curActor.isTryWatch) {
					this._controllBarProxy.addStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW);
				} else {
					this._controllBarProxy.removeStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW);
				}
			}
		}
		
		private function checkShowStatus() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(((GlobalStage.isFullScreen()) || !this._controllBarProxy.playerLightOn || (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE))) && (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR)) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))) {
				return true;
			}
			return false;
		}
		
		private function checkPauseBtnStatus() : Boolean {
			var _loc1_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(_loc1_.hasStatus(ADDef.STATUS_PLAYING)) {
				return false;
			}
			return true;
		}
		
		private function onStageMouseMove(param1:MouseEvent = null) : void {
			this._controllBarProxy.addStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
			if(this.checkShowStatus()) {
				Mouse.show();
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
			}
			TweenLite.killTweensOf(this.hideSeekBar);
			TweenLite.delayedCall(ControllBarDef.SEEKBAR_THIN_DELAY / 1000,this.hideSeekBar);
		}
		
		private function hideSeekBar() : void {
			var _loc1_:ADProxy = null;
			var _loc2_:PlayerProxy = null;
			if(!this._controllBarView.seekBarView.isMouseIn && !this._controllBarProxy.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW)) {
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
				if((GlobalStage.isFullScreen()) || !this._controllBarProxy.playerLightOn || (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE))) {
					_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(!_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) {
						if(GlobalStage.isFullScreen()) {
							Mouse.hide();
						}
						this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SHOW);
					}
				}
				_loc1_ = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
				if((_loc1_.hasStatus(ADDef.STATUS_PLAYING)) || (_loc1_.hasStatus(ADDef.STATUS_PAUSED)) || (_loc1_.hasStatus(ADDef.STATUS_LOADING))) {
					this._controllBarProxy.addStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
					TweenLite.killTweensOf(this.hideSeekBar);
					TweenLite.delayedCall(ControllBarDef.SEEKBAR_THIN_DELAY / 1000,this.hideSeekBar);
				}
			}
		}
		
		private function checkNextBtnShow() : Boolean {
			var _loc1_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(_loc1_.continueInfoCount > 0 && (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_NEXT_BTN)) && (_loc2_.curActor.loadMovieParams)) {
				if(_loc1_.findNextContinueInfo(_loc2_.curActor.loadMovieParams.tvid,_loc2_.curActor.loadMovieParams.vid) != null) {
					return true;
				}
			}
			return false;
		}
		
		private function checkTvListBtnShow() : Boolean {
			var _loc1_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:SceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			if(((GlobalStage.isFullScreen()) || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT) && (_loc1_.isContinue) && (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_TVLIST_BTN)) && _loc1_.continueInfoCount > 0 && !_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED)) {
				return true;
			}
			return false;
		}
		
		private function checkFilterTipShow() : Boolean {
			if((this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW)) && this._controllBarProxy.seekCount >= ControllBarDef.FILTER_SEEK_COUNT) {
				return true;
			}
			return false;
		}
		
		private function onUpdateContinuePlayBtns() : void {
			if(this.checkNextBtnShow()) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
			} else {
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
			}
			if(this.checkTvListBtnShow()) {
				this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
				if(this.isTvListChannels()) {
					this._controllBarProxy.addStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
				} else {
					this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
				}
			} else {
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
				this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
			}
		}
		
		private function onKeyDown(param1:KeyboardEvent) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((_loc2_.curActor.smallWindowMode) && !(param1.keyLocation == int.MAX_VALUE)) {
				return;
			}
			switch(param1.keyCode) {
				case 37:
					if(!this.isAllowKeyAction()) {
						return;
					}
					if(this._controllBarProxy.keyDownSeeking == false) {
						this._controllBarView.seekBarView.seekTime = _loc2_.curActor.currentTime - 15000;
						this._controllBarProxy.keyDownSeeking = true;
					} else {
						this._controllBarView.seekBarView.seekTime = this._controllBarView.seekBarView.seekTime - 15000;
					}
					this._controllBarView.seekBarView.updateSeekBarView();
					break;
				case 38:
					this._controllBarProxy.keyDownVolume = true;
					this.increaseVolume();
					break;
				case 39:
					if(!this.isAllowKeyAction()) {
						return;
					}
					if(this._controllBarProxy.keyDownSeeking == false) {
						this._controllBarView.seekBarView.seekTime = _loc2_.curActor.currentTime + 15000;
						this._controllBarProxy.keyDownSeeking = true;
					} else {
						this._controllBarView.seekBarView.seekTime = this._controllBarView.seekBarView.seekTime + 15000;
					}
					this._controllBarView.seekBarView.updateSeekBarView();
					break;
				case 40:
					this._controllBarProxy.keyDownVolume = true;
					this.decreaseVolume();
					break;
				default:
					return;
			}
		}
		
		private function onKeyUp(param1:KeyboardEvent) : void {
			var _loc3_:SettingProxy = null;
			var _loc4_:SettingProxy = null;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((_loc2_.curActor.smallWindowMode) && !(param1.keyLocation == int.MAX_VALUE)) {
				return;
			}
			switch(param1.keyCode) {
				case 32:
					if(!this.isAllowKeyAction()) {
						return;
					}
					if(this._controllBarView.playBtn.visible) {
						this.onPlayBtnClick(null);
					} else if(this._controllBarView.pauseBtn.visible) {
						this.onPauseBtnClick(null);
					}
					
					break;
				case 37:
					if(this._controllBarProxy.keyDownSeeking) {
						this._controllBarProxy.keyDownSeeking = false;
						this.onPlayerSeeking(this._controllBarView.seekBarView.seekTime);
						this._controllBarProxy.seekCount = this._controllBarProxy.seekCount + 1;
						if(this.checkFilterTipShow()) {
							_loc3_ = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
							if(!this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && !_loc3_.hasStatus(SettingDef.STATUS_FILTER_OPEN)) {
								sendNotification(ControllBarDef.NOTIFIC_SCENE_TILE_TOOL_TIP);
							}
						}
						if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
							this._isUserSeek = this.checkInEnjoyableSkipType()?false:true;
						}
						this._controllBarView.seekBarView.hideImagePreview();
					}
					break;
				case 38:
					this._controllBarProxy.keyDownVolume = false;
					break;
				case 39:
					if(this._controllBarProxy.keyDownSeeking) {
						this._controllBarProxy.keyDownSeeking = false;
						this.onPlayerSeeking(this._controllBarView.seekBarView.seekTime);
						this._controllBarProxy.seekCount = this._controllBarProxy.seekCount + 1;
						if(this.checkFilterTipShow()) {
							_loc4_ = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
							if(!this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && !_loc4_.hasStatus(SettingDef.STATUS_FILTER_OPEN)) {
								sendNotification(ControllBarDef.NOTIFIC_SCENE_TILE_TOOL_TIP);
							}
						}
						if(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)) {
							this._isUserSeek = this.checkInEnjoyableSkipType()?false:true;
						}
						this._controllBarView.seekBarView.hideImagePreview();
					}
					break;
				case 40:
					this._controllBarProxy.keyDownVolume = false;
					break;
			}
		}
		
		private function isAllowKeyAction() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY)) && !_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED) && !_loc2_.hasStatus(ADDef.STATUS_LOADING) && !_loc2_.hasStatus(ADDef.STATUS_PLAYING) && !_loc2_.hasStatus(ADDef.STATUS_PAUSED)) {
				return true;
			}
			return false;
		}
		
		private function increaseVolume() : void {
			if(this._controllBarView.volumeControlView.currentVolume < 100) {
				this._controllBarView.volumeControlView.adjustVolume = this._controllBarView.volumeControlView.currentVolume + 10;
				if(this._controllBarView.volumeControlView.adjustVolume > 100) {
					this._controllBarView.volumeControlView.adjustVolume = 100;
				}
			} else {
				this._controllBarView.volumeControlView.adjustVolume = this._controllBarView.volumeControlView.currentVolume + 50;
				if(this._controllBarView.volumeControlView.adjustVolume > 500) {
					this._controllBarView.volumeControlView.adjustVolume = 500;
				}
			}
			this._controllBarView.volumeControlView.updateVolumeControlView(this._controllBarView.volumeControlView.adjustVolume,this._controllBarProxy.keyDownVolume);
		}
		
		private function decreaseVolume() : void {
			if(this._controllBarView.volumeControlView.currentVolume <= 100) {
				this._controllBarView.volumeControlView.adjustVolume = this._controllBarView.volumeControlView.currentVolume - 10;
				if(this._controllBarView.volumeControlView.adjustVolume < 0) {
					this._controllBarView.volumeControlView.adjustVolume = 0;
				}
			} else {
				this._controllBarView.volumeControlView.adjustVolume = this._controllBarView.volumeControlView.currentVolume - 50;
			}
			this._controllBarView.volumeControlView.updateVolumeControlView(this._controllBarView.volumeControlView.adjustVolume,this._controllBarProxy.keyDownVolume);
		}
		
		private function addVolumeTip(param1:Boolean = false) : void {
			TweenLite.killTweensOf(this.removeVolumeTip);
			var _loc2_:Point = this._controllBarView.volumeControlView.localToGlobal(new Point(this._controllBarView.volumeControlView.tipX,this._controllBarView.volumeControlView.tipY));
			this._controllBarView.volumeControlView.volumeTip.x = _loc2_.x;
			this._controllBarView.volumeControlView.volumeTip.y = _loc2_.y;
			if(this._controllBarView.volumeControlView.volumeTip.parent == null) {
				GlobalStage.stage.addChild(this._controllBarView.volumeControlView.volumeTip);
			}
			TweenLite.delayedCall(ControllBarDef.VOLUMETIP_DISAPPEARE_DELAY / 1000,this.removeVolumeTip);
		}
		
		private function removeVolumeTip() : void {
			if(this._controllBarView.volumeControlView.volumeTip.parent) {
				GlobalStage.stage.removeChild(this._controllBarView.volumeControlView.volumeTip);
				TweenLite.killTweensOf(this.removeVolumeTip);
			}
		}
		
		private function isTvListChannels() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			if(_loc2_.dataSource != ContinuePlayDef.SOURCE_QIYU_VALUE) {
				return true;
			}
			return false;
		}
		
		private function showOpenFilterTip() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:Boolean = _loc1_.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
			var _loc3_:Boolean = _loc1_.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
			switch(_loc1_.curActor.movieModel.curEnjoyableSubType) {
				case SkipPointEnum.ENJOYABLE_SUB_MALE:
					sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
						"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
						"value":((_loc2_) || (_loc3_)?TipsDef.CONSTANT_FILTER_MALE:"")
					});
					break;
				case SkipPointEnum.ENJOYABLE_SUB_FEMALE:
					sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
						"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
						"value":((_loc2_) || (_loc3_)?TipsDef.CONSTANT_FILTER_FEMALE:"")
					});
					break;
				default:
					sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR,{
						"attr":TipsDef.TIP_ATTR_NAME_FILTER_TYPE,
						"value":((_loc2_) || (_loc3_)?TipsDef.CONSTANT_FILTER_COMMON:"")
					});
			}
			sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP,TipsDef.TIP_ID_FILTER_OPEN_TIP);
		}
		
		private function checkFilterBtnState() : Boolean {
			var _loc2_:uint = 0;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc2_ = 0;
				while(_loc2_ < _loc1_.curActor.movieModel.skipPointInfoCount) {
					if(_loc1_.curActor.movieModel.getSkipPointInfoAt(_loc2_).skipPointType == SkipPointEnum.ENJOYABLE) {
						return true;
					}
					_loc2_++;
				}
			}
			return false;
		}
		
		private function checkHasNestEnjoableSkip(param1:Boolean = false) : ISkipPointInfo {
			var _loc3_:uint = 0;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc3_ = 0;
				while(_loc3_ < _loc2_.curActor.movieModel.skipPointInfoCount) {
					if(_loc2_.curActor.movieModel.getSkipPointInfoAt(_loc3_).skipPointType == SkipPointEnum.ENJOYABLE) {
						if(_loc2_.curActor.currentTime < _loc2_.curActor.movieModel.getSkipPointInfoAt(_loc3_).startTime) {
							return _loc2_.curActor.movieModel.getSkipPointInfoAt(_loc3_);
						}
					}
					_loc3_++;
				}
			}
			return null;
		}
		
		private function firstEnjoyableSkipPointPlay() : void {
			var _loc2_:uint = 0;
			this._isUserSeek = false;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc2_ = 0;
				while(_loc2_ < _loc1_.curActor.movieModel.skipPointInfoCount) {
					if(_loc1_.curActor.movieModel.getSkipPointInfoAt(_loc2_).skipPointType == SkipPointEnum.ENJOYABLE) {
						this.onPlayerSeeking(_loc1_.curActor.movieModel.getSkipPointInfoAt(_loc2_).startTime,SeekTypeEnum.SKIP_ENJOYABLE_POINT);
						return;
					}
					_loc2_++;
				}
			}
		}
		
		private function checkInEnjoyableSkipType() : Boolean {
			var _loc2_:uint = 0;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc2_ = 0;
				while(_loc2_ < _loc1_.curActor.movieModel.skipPointInfoCount) {
					if(_loc1_.curActor.movieModel.getSkipPointInfoAt(_loc2_).skipPointType == SkipPointEnum.ENJOYABLE) {
						if(_loc1_.curActor.currentTime >= _loc1_.curActor.movieModel.getSkipPointInfoAt(_loc2_).startTime && _loc1_.curActor.currentTime < _loc1_.curActor.movieModel.getSkipPointInfoAt(_loc2_).endTime) {
							return true;
						}
					}
					_loc2_++;
				}
			}
			return false;
		}
		
		private function getAllEnjoyableInfo() : Vector.<ISkipPointInfo> {
			var _loc2_:Vector.<ISkipPointInfo> = null;
			var _loc3_:uint = 0;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				_loc2_ = new Vector.<ISkipPointInfo>();
				_loc3_ = 0;
				while(_loc3_ < _loc1_.curActor.movieModel.skipPointInfoCount) {
					if(_loc1_.curActor.movieModel.getSkipPointInfoAt(_loc3_).skipPointType == SkipPointEnum.ENJOYABLE) {
						_loc2_.push(_loc1_.curActor.movieModel.getSkipPointInfoAt(_loc3_));
					}
					_loc3_++;
				}
				if(_loc2_.length > 0) {
					return _loc2_;
				}
			}
			return null;
		}
		
		private function getImageUrlList() : Array {
			var _loc4_:uint = 0;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:* = "";
			var _loc3_:Array = [];
			if((_loc1_.curActor.movieInfo) && !(_loc1_.curActor.movieInfo.previewImageUrl == "")) {
				_loc4_ = 0;
				while(_loc4_ < Math.ceil(_loc1_.curActor.movieModel.duration / 1000 / 1000)) {
					_loc2_ = _loc1_.curActor.movieInfo.previewImageUrl.replace(".jpg","_160_90_" + (_loc4_ + 1) + ".jpg");
					_loc3_.push(_loc2_);
					_loc4_++;
				}
			}
			return _loc3_;
		}
	}
}
