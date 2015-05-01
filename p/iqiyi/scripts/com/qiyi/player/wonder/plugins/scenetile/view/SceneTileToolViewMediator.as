package com.qiyi.player.wonder.plugins.scenetile.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.common.sw.ISwitch;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import flash.events.MouseEvent;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.scenetile.SceneTileDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	import com.qiyi.player.wonder.plugins.continueplay.ContinuePlayDef;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.plugins.videolink.VideoLinkDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import gs.TweenLite;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.wonder.plugins.dock.model.DockProxy;
	import com.qiyi.player.wonder.plugins.dock.DockDef;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import flash.events.Event;
	import com.qiyi.player.wonder.common.utils.StringUtils;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.plugins.videolink.model.VideoLinkProxy;
	import flash.ui.Mouse;
	import com.qiyi.player.wonder.common.lso.LSO;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	
	public class SceneTileToolViewMediator extends Mediator implements ISwitch {
		
		public function SceneTileToolViewMediator(param1:SceneTileToolView) {
			super(NAME,param1);
			this._sceneTileView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileToolViewMediator";
		
		private var _sceneTileProxy:SceneTileProxy;
		
		private var _sceneTileView:SceneTileToolView;
		
		private var _sceneTileTipShown:Boolean;
		
		private var _isFirstPlay:Boolean = true;
		
		override public function onRegister() : void {
			super.onRegister();
			SwitchManager.getInstance().register(this);
			this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			this._sceneTileView.addEventListener(SceneTileEvent.Evt_ToolOpen,this.onSceneTileToolViewOpen);
			this._sceneTileView.addEventListener(SceneTileEvent.Evt_ToolClose,this.onSceneTileToolViewClose);
			this._sceneTileView.playBtn.addEventListener(MouseEvent.CLICK,this.onPlayBtnClick);
			this._sceneTileView.addEventListener(SceneTileEvent.Evt_TipCloseBtnClick,this.onTipCloseBtnClick);
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMove);
		}
		
		override public function listNotificationInterests() : Array {
			return [SceneTileDef.NOTIFIC_ADD_STATUS,SceneTileDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_JS_LIGHT_CHANGED,BodyDef.NOTIFIC_PLAYER_REPLAYED,BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,ControllBarDef.NOTIFIC_ADD_STATUS,ControllBarDef.NOTIFIC_REMOVE_STATUS,ControllBarDef.NOTIFIC_DEF_BTN_POS_CHANGE,ControllBarDef.NOTIFIC_SCENE_TILE_TOOL_TIP,ADDef.NOTIFIC_ADD_STATUS,TopBarDef.NOTIFIC_ADD_STATUS,TopBarDef.NOTIFIC_REMOVE_STATUS,ContinuePlayDef.NOTIFIC_ADD_STATUS,ContinuePlayDef.NOTIFIC_REMOVE_STATUS,SettingDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_ADD_STATUS,VideoLinkDef.NOTIFIC_REMOVE_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc7_:ADProxy = null;
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			var _loc5_:ControllBarProxy = null;
			var _loc6_:PlayerProxy = null;
			switch(_loc3_) {
				case SceneTileDef.NOTIFIC_ADD_STATUS:
					_loc6_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(int(_loc2_) == SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW) {
						_loc5_ = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
						this._sceneTileView.sceneTileTipBtnX = _loc5_.filterBtnX;
						this._sceneTileView.sceneTileTipBtnY = _loc5_.hasStatus(ControllBarDef.STATUS_SHOW)?SceneTileDef.STAGE_GAP_1:SceneTileDef.STAGE_GAP_2;
						TweenLite.killTweensOf(this.delayedSecenTileTip);
						TweenLite.delayedCall(SceneTileDef.SCENE_TILE_TIP_DELAY_TIME / 1000,this.delayedSecenTileTip);
					}
					if(int(_loc2_) == SceneTileDef.STATUS_SCORE_OPEN) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					}
					if(int(_loc2_) == SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW && (_loc6_.curActor.movieModel)) {
						this._sceneTileView.updateStarHeadImage(this._sceneTileProxy.starInteractInfo.getStarInteractByTvid(_loc6_.curActor.movieModel.tvid));
					}
					this._sceneTileView.onAddStatus(int(_loc2_));
					break;
				case SceneTileDef.NOTIFIC_REMOVE_STATUS:
					if(int(_loc2_) == SceneTileDef.STATUS_SCORE_OPEN && (this.checkPlayBtnShowStatus())) {
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					}
					this._sceneTileView.onRemoveStatus(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._sceneTileView.onResize(_loc2_.w,_loc2_.h);
					this.updateBorderShowState();
					_loc7_ = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
					if((GlobalStage.isFullScreen()) && !_loc7_.hasStatus(ADDef.STATUS_PAUSED) && !_loc7_.hasStatus(ADDef.STATUS_PLAYING)) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW);
					}
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
				case BodyDef.NOTIFIC_FULL_SCREEN:
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW);
					TweenLite.killTweensOf(this.delayedSecenTileTip);
					this._isFirstPlay = true;
					break;
				case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
					this.onLightChanged(Boolean(_loc2_));
					break;
				case BodyDef.NOTIFIC_PLAYER_REPLAYED:
					_loc6_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if((_loc6_.curActor.movieModel) && _loc6_.curActor.movieModel.curDefinitionInfo.type == DefinitionEnum.FULL_HD) {
						this._sceneTileTipShown = true;
					} else {
						this._sceneTileTipShown = false;
					}
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW);
					this._isFirstPlay = true;
					break;
				case BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE:
					this._sceneTileView.requestUnAutoPlayImage();
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					if(Boolean(_loc2_)) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW);
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
					} else {
						this.checkVideoNameShow();
					}
					break;
				case ControllBarDef.NOTIFIC_ADD_STATUS:
					this.onControllBarStatusChanged(int(_loc2_),true);
					break;
				case ControllBarDef.NOTIFIC_REMOVE_STATUS:
					this.onControllBarStatusChanged(int(_loc2_),false);
					break;
				case ControllBarDef.NOTIFIC_DEF_BTN_POS_CHANGE:
					_loc5_ = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
					this._sceneTileView.sceneTileTipBtnX = _loc5_.filterBtnX;
					break;
				case ControllBarDef.NOTIFIC_SCENE_TILE_TOOL_TIP:
					this.showSceneTileToolTip();
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2_),true);
					break;
				case TopBarDef.NOTIFIC_ADD_STATUS:
					this.onTopBarStatusChanged(int(_loc2_),true);
					break;
				case TopBarDef.NOTIFIC_REMOVE_STATUS:
					this.onTopBarStatusChanged(int(_loc2_),false);
					break;
				case ContinuePlayDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == ContinuePlayDef.STATUS_OPEN) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					}
					break;
				case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
					if(int(_loc2_) == ContinuePlayDef.STATUS_OPEN && (this.checkPlayBtnShowStatus())) {
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					}
					break;
				case VideoLinkDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == VideoLinkDef.STATUS_OPEN) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					}
					break;
				case VideoLinkDef.NOTIFIC_REMOVE_STATUS:
					if(int(_loc2_) == VideoLinkDef.STATUS_OPEN && (this.checkPlayBtnShowStatus())) {
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					}
					break;
				case SettingDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == SettingDef.STATUS_DEFINITION_OPEN) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
					}
					break;
			}
		}
		
		public function getSwitchID() : Vector.<int> {
			return Vector.<int>([SwitchDef.ID_SHOW_MAX_MIN_BTN,SwitchDef.ID_SHOW_LOGO]);
		}
		
		public function onSwitchStatusChanged(param1:int, param2:Boolean) : void {
			var _loc3_:PlayerProxy = null;
			switch(param1) {
				case SwitchDef.ID_SHOW_MAX_MIN_BTN:
					break;
				case SwitchDef.ID_SHOW_LOGO:
					_loc3_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(param2) {
						if(this.checkLogoShowStatus()) {
							_loc3_.curActor.floatLayer.showLogo = true;
							_loc3_.preActor.floatLayer.showLogo = true;
						}
					} else {
						_loc3_.curActor.floatLayer.showLogo = false;
						_loc3_.preActor.floatLayer.showLogo = false;
					}
					break;
			}
		}
		
		private function updateBorderShowState() : void {
			var _loc1_:DockProxy = facade.retrieveProxy(DockProxy.NAME) as DockProxy;
			var _loc2_:ControllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
			if(!_loc1_.hasStatus(DockDef.STATUS_LIGHT_ON) && (_loc2_.hasStatus(ControllBarDef.STATUS_SHOW)) && !GlobalStage.isFullScreen()) {
				this._sceneTileView.drawBorder();
			} else {
				this._sceneTileView.clearBorder();
			}
		}
		
		private function onSceneTileToolViewOpen(param1:SceneTileEvent) : void {
			if(!this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_TOOL_OPEN)) {
				this._sceneTileProxy.addStatus(SceneTileDef.STATUS_TOOL_OPEN);
			}
		}
		
		private function onSceneTileToolViewClose(param1:SceneTileEvent) : void {
			if(this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_TOOL_OPEN)) {
				this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_TOOL_OPEN);
			}
		}
		
		private function onTipCloseBtnClick(param1:SceneTileEvent) : void {
			if(this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW)) {
				this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
			}
		}
		
		private function onPlayBtnClick(param1:MouseEvent) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(!FlashVarConfig.autoPlay && !_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE)) {
				sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
			} else {
				sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
				sendNotification(ADDef.NOTIFIC_RESUME);
				GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			var _loc4_:PlayerProxy = null;
			var _loc5_:String = null;
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						this._sceneTileTipShown = false;
						this._isFirstPlay = true;
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW);
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
						this._sceneTileView.destroyImageLoader();
					}
					break;
				case BodyDef.PLAYER_STATUS_PAUSED:
					if(param2) {
						if(this.checkPlayBtnShowStatus()) {
							this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
						}
					} else {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					if(param2) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
						if(this._isFirstPlay) {
							this._isFirstPlay = false;
							_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
							if(!GlobalStage.isFullScreen() && !_loc4_.curActor.smallWindowMode) {
								_loc5_ = "";
								if(_loc4_.curActor.movieInfo.infoJSON) {
									_loc5_ = _loc4_.curActor.movieInfo.infoJSON.shortTitle?_loc4_.curActor.movieInfo.infoJSON.shortTitle:StringUtils.remainWord(_loc4_.curActor.movieInfo.title,20);
								}
								this._sceneTileProxy.addStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW);
								this._sceneTileView.updateVideoNamePosition(_loc5_,false);
							} else {
								this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW);
							}
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
				case BodyDef.PLAYER_STATUS_STOPED:
					if(param2) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
						TweenLite.killTweensOf(this.delayedSecenTileTip);
					}
					break;
			}
		}
		
		private function onLightChanged(param1:Boolean) : void {
			this.updateBorderShowState();
		}
		
		private function onControllBarStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ControllBarDef.STATUS_SHOW:
					this.updateBorderShowState();
					if(param2) {
						this._sceneTileView.setGap(SceneTileDef.STAGE_GAP_1);
					} else {
						this._sceneTileView.setGap(SceneTileDef.STAGE_GAP_2);
					}
					break;
				case ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW:
					if(param2) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					} else if(this.checkPlayBtnShowStatus()) {
						this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
					}
					
					break;
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ADDef.STATUS_PLAYING:
					if(param2) {
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
						TweenLite.killTweensOf(this.delayedSecenTileTip);
						this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
						this.checkVideoNameShow();
					}
					break;
				case ADDef.STATUS_PAUSED:
					if(param2) {
						this.checkVideoNameShow();
					}
					break;
				case ADDef.STATUS_PLAY_END:
					break;
			}
		}
		
		private function checkVideoNameShow() : void {
			var _loc3_:String = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if(!_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && ((_loc2_.hasStatus(ADDef.STATUS_PLAYING)) || (_loc2_.hasStatus(ADDef.STATUS_PAUSED))) && !_loc1_.curActor.smallWindowMode && !this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW)) {
				_loc3_ = "";
				if(_loc1_.curActor.movieInfo.infoJSON) {
					_loc3_ = _loc1_.curActor.movieInfo.infoJSON.shortTitle?_loc1_.curActor.movieInfo.infoJSON.shortTitle:StringUtils.remainWord(_loc1_.curActor.movieInfo.title,20);
				}
				this._sceneTileProxy.addStatus(SceneTileDef.STATUS_VIDEO_NAME_SHOW);
				this._sceneTileView.updateVideoNamePosition(_loc3_,true);
			}
		}
		
		private function onTopBarStatusChanged(param1:int, param2:Boolean) : void {
			var _loc3_:PlayerProxy = null;
			switch(param1) {
				case TopBarDef.STATUS_SHOW:
					_loc3_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					if(param2) {
						if(_loc3_.curActor.floatLayer) {
							_loc3_.curActor.floatLayer.showLogo = false;
						}
						if(_loc3_.preActor.floatLayer) {
							_loc3_.preActor.floatLayer.showLogo = false;
						}
					} else if(this.checkLogoShowStatus()) {
						if(_loc3_.curActor.floatLayer) {
							_loc3_.curActor.floatLayer.showLogo = true;
						}
						if(_loc3_.preActor.floatLayer) {
							_loc3_.preActor.floatLayer.showLogo = true;
						}
					}
					
					break;
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
			this._sceneTileView.onUserInfoChanged(_loc2_);
		}
		
		private function checkPlayBtnShowStatus() : Boolean {
			var _loc1_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			var _loc4_:VideoLinkProxy = facade.retrieveProxy(VideoLinkProxy.NAME) as VideoLinkProxy;
			var _loc5_:ControllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
			if((_loc2_.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED)) && !_loc1_.hasStatus(ADDef.STATUS_PLAYING) && !_loc1_.hasStatus(ADDef.STATUS_PAUSED) && !_loc3_.hasStatus(ContinuePlayDef.STATUS_OPEN) && !_loc5_.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW) && !_loc4_.hasStatus(VideoLinkDef.STATUS_OPEN) && !this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_OPEN)) {
				if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && !(FlashVarConfig.os == FlashVarConfig.OS_XP)) {
					return true;
				}
			}
			return false;
		}
		
		private function checkLogoShowStatus() : Boolean {
			if(SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_LOGO)) {
				if(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && !(FlashVarConfig.os == FlashVarConfig.OS_XP)) {
					return true;
				}
			}
			return false;
		}
		
		private function delayedComplete() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(!_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED)) {
				Mouse.hide();
			}
		}
		
		private function showSceneTileToolTip() : void {
			if(this.checkFullHdTipShowEnable()) {
				this._sceneTileTipShown = true;
				LSO.getInstance().sttDate = new Date();
				if(this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW)) {
					this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
				}
				this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
				PingBack.getInstance().userActionPing(PingBackDef.SCENE_TILE_TIP_SHOW);
				LSO.getInstance().sttMaxCount++;
				if(LSO.getInstance().sttShowCountOneDay >= 2) {
					LSO.getInstance().sttShowCountOneDay = 1;
				} else {
					LSO.getInstance().sttShowCountOneDay++;
				}
			}
		}
		
		private function checkFullHdTipShowEnable() : Boolean {
			var _loc3_:SettingProxy = null;
			var _loc4_:Date = null;
			var _loc5_:Date = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ControllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
			if(!this._sceneTileTipShown && !this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW) && !_loc2_.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW) && !_loc1_.curActor.smallWindowMode) {
				_loc3_ = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
				if(!_loc3_.hasStatus(SettingDef.STATUS_DEFINITION_OPEN)) {
					_loc4_ = new Date();
					_loc5_ = LSO.getInstance().sttDate;
					if(LSO.getInstance().sttShowCountOneDay < 2 || !(_loc4_.date == _loc5_.date) || !(_loc4_.month == _loc5_.month) || !(_loc4_.fullYear == _loc5_.fullYear)) {
						if(LSO.getInstance().sttMaxCount < 7) {
							return true;
						}
						return false;
					}
				}
			}
			return false;
		}
		
		private function delayedSecenTileTip() : void {
			TweenLite.killTweensOf(this.delayedSecenTileTip);
			this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCENE_TILE_TIP_SHOW);
		}
		
		private function onStageMouseMove(param1:MouseEvent) : void {
			Mouse.show();
		}
	}
}
