package com.qiyi.player.wonder.plugins.topbar.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.topbar.model.TopBarProxy;
	import com.iqiyi.components.global.GlobalStage;
	import flash.events.MouseEvent;
	import com.qiyi.player.wonder.plugins.topbar.TopBarDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.setting.SettingDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import gs.TweenLite;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	
	public class TopBarViewMediator extends Mediator {
		
		public function TopBarViewMediator(param1:TopBarView) {
			super(NAME,param1);
			this._topBarView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.topbar.view.TopBarViewMediator";
		
		private var _topBarProxy:TopBarProxy;
		
		private var _topBarView:TopBarView;
		
		override public function onRegister() : void {
			super.onRegister();
			this._topBarProxy = facade.retrieveProxy(TopBarProxy.NAME) as TopBarProxy;
			this._topBarView.addEventListener(TopBarEvent.Evt_Open,this.onTopBarViewOpen);
			this._topBarView.addEventListener(TopBarEvent.Evt_Close,this.onTopBarViewClose);
			this._topBarView.addEventListener(TopBarEvent.Evt_ScaleClick,this.onScaleClick);
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onStageMouseWheel);
		}
		
		override public function listNotificationInterests() : Array {
			return [TopBarDef.NOTIFIC_ADD_STATUS,TopBarDef.NOTIFIC_REMOVE_STATUS,TopBarDef.NOTIFIC_REQUEST_SCALE,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED,SettingDef.NOTIFIC_NORMAL_VIDEO_RATE_CHANGE,ADDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case TopBarDef.NOTIFIC_ADD_STATUS:
					this._topBarView.onAddStatus(int(_loc2_));
					break;
				case TopBarDef.NOTIFIC_REMOVE_STATUS:
					this._topBarView.onRemoveStatus(int(_loc2_));
					break;
				case TopBarDef.NOTIFIC_REQUEST_SCALE:
					if((GlobalStage.isFullScreen()) && !(int(_loc2_) == this._topBarProxy.scaleValue)) {
						this.changeScaleValue(int(_loc2_));
						this._topBarView.updateScaleBtn(int(_loc2_));
					}
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._topBarView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					this.onFullScreenChanged(Boolean(_loc2_));
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
				case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.onPlayerDefinitionSwitched(int(_loc2_));
					}
					break;
				case SettingDef.NOTIFIC_NORMAL_VIDEO_RATE_CHANGE:
					if(int(_loc2_) == SettingDef.VIDEO_PAGE_ASPECT_FILL) {
						this.changeScaleValue(TopBarDef.SCALE_VALUE_FULL);
						this._topBarView.updateScaleBtn(TopBarDef.SCALE_VALUE_FULL);
					} else if(this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_FULL) {
						this.changeScaleValue(TopBarDef.SCALE_VALUE_100);
						this._topBarView.updateScaleBtn(TopBarDef.SCALE_VALUE_100);
					}
					
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2_),true);
					break;
			}
		}
		
		private function onTopBarViewOpen(param1:TopBarEvent) : void {
			if(!this._topBarProxy.hasStatus(TopBarDef.STATUS_OPEN)) {
				this._topBarProxy.addStatus(TopBarDef.STATUS_OPEN);
			}
		}
		
		private function onTopBarViewClose(param1:TopBarEvent) : void {
			if(this._topBarProxy.hasStatus(TopBarDef.STATUS_OPEN)) {
				this._topBarProxy.removeStatus(TopBarDef.STATUS_OPEN);
			}
		}
		
		private function onScaleClick(param1:TopBarEvent) : void {
			this.changeScaleValue(int(param1.data));
		}
		
		private function changeScaleValue(param1:int) : void {
			if(this._topBarProxy.scaleValue == param1) {
				return;
			}
			this._topBarProxy.scaleValue = param1;
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_FULL) {
				_loc2_.curActor.setPuman(true);
				_loc2_.curActor.setZoom(TopBarDef.SCALE_VALUE_100);
				_loc2_.preActor.setPuman(true);
				_loc2_.preActor.setZoom(TopBarDef.SCALE_VALUE_100);
			} else {
				_loc2_.curActor.setPuman(false);
				_loc2_.curActor.setZoom(this._topBarProxy.scaleValue);
				_loc2_.preActor.setPuman(false);
				_loc2_.preActor.setZoom(this._topBarProxy.scaleValue);
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
						TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					this._topBarView.setTitle(_loc4_.curActor.movieInfo.title);
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
					this._topBarProxy.addStatus(TopBarDef.STATUS_ALLOW_TELL_TIME);
					break;
				case BodyDef.PLAYER_STATUS_STOPPING:
				case BodyDef.PLAYER_STATUS_STOPED:
					if(param2) {
						TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
						if(!this.checkShowStatus()) {
							this._topBarProxy.removeStatus(TopBarDef.STATUS_SHOW);
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2) {
						TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
					}
					break;
			}
		}
		
		private function onPlayerSwitchPreActor() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY)) {
				this._topBarView.setTitle(_loc1_.curActor.movieInfo.title);
			}
			TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ADDef.STATUS_LOADING:
				case ADDef.STATUS_PLAYING:
				case ADDef.STATUS_PAUSED:
					if(param2) {
						this._topBarProxy.removeStatus(TopBarDef.STATUS_ALLOW_TELL_TIME);
						if(!this.checkShowStatus()) {
							this._topBarProxy.removeStatus(TopBarDef.STATUS_SHOW);
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
			this._topBarView.onUserInfoChanged(_loc2_);
		}
		
		private function onFullScreenChanged(param1:Boolean) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(param1) {
				this._topBarView.hasTween = true;
				GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
				if(this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_FULL) {
					_loc2_.curActor.setPuman(true);
					_loc2_.curActor.setZoom(TopBarDef.SCALE_VALUE_100);
					_loc2_.preActor.setPuman(true);
					_loc2_.preActor.setZoom(TopBarDef.SCALE_VALUE_100);
				} else {
					_loc2_.curActor.setPuman(false);
					_loc2_.curActor.setZoom(this._topBarProxy.scaleValue);
					_loc2_.preActor.setPuman(false);
					_loc2_.preActor.setZoom(this._topBarProxy.scaleValue);
				}
			} else {
				this._topBarView.hasTween = false;
				GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
				this._topBarProxy.removeStatus(TopBarDef.STATUS_SHOW);
				if(this._topBarProxy.scaleValue != TopBarDef.SCALE_VALUE_FULL) {
					_loc2_.curActor.setPuman(false);
					_loc2_.curActor.setZoom(TopBarDef.SCALE_VALUE_100);
					_loc2_.preActor.setPuman(false);
					_loc2_.preActor.setZoom(TopBarDef.SCALE_VALUE_100);
				}
			}
			this._topBarView.onFullScreenChanged(param1);
		}
		
		private function checkShowStatus() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((GlobalStage.isFullScreen()) && (_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) && !_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc2_.hasStatus(ADDef.STATUS_LOADING) && !_loc2_.hasStatus(ADDef.STATUS_PLAYING) && !_loc2_.hasStatus(ADDef.STATUS_PAUSED)) {
				return true;
			}
			return false;
		}
		
		private function onPlayerDefinitionSwitched(param1:int) : void {
			if(!Settings.instance.autoMatchRate) {
				TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
				TweenLite.delayedCall(param1 / 1000,this.onPlayerDefinitionSwitchComplete);
			}
		}
		
		private function onPlayerDefinitionSwitchComplete() : void {
			var _loc2_:EnumItem = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.movieModel) {
				_loc2_ = _loc1_.curActor.movieModel.curDefinitionInfo.type;
				if(_loc2_ == DefinitionEnum.LIMIT) {
					if((GlobalStage.isFullScreen()) && !(this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_75)) {
						this.changeScaleValue(TopBarDef.SCALE_VALUE_75);
						this._topBarView.updateScaleBtn(TopBarDef.SCALE_VALUE_75);
					}
				}
			}
		}
		
		private function onMouseMove(param1:MouseEvent) : void {
			if(this.checkShowStatus()) {
				this._topBarProxy.addStatus(TopBarDef.STATUS_SHOW);
				TweenLite.killTweensOf(this.delayedHideTopBar);
				TweenLite.delayedCall(TopBarDef.TOP_BAR_HIND_DELAY / 1000,this.delayedHideTopBar);
			}
		}
		
		private function delayedHideTopBar() : void {
			this._topBarProxy.removeStatus(TopBarDef.STATUS_SHOW);
		}
		
		private function onStageMouseWheel(param1:MouseEvent) : void {
			var _loc2_:SceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
			if(!GlobalStage.isFullScreen()) {
				this._topBarProxy.upWardWheelCount = 0;
				this._topBarProxy.downWardWheelCount = 0;
				return;
			}
			var _loc3_:int = this._topBarProxy.scaleValue;
			if(param1.delta > 0) {
				this._topBarProxy.upWardWheelCount++;
				if(this._topBarProxy.upWardWheelCount == 3) {
					this._topBarProxy.upWardWheelCount = 0;
					if(this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_FULL) {
						return;
					}
					_loc3_ = this._topBarProxy.scaleValue + 25;
					if(_loc3_ > TopBarDef.SCALE_VALUE_100) {
						_loc3_ = TopBarDef.SCALE_VALUE_FULL;
					}
					this.changeScaleValue(_loc3_);
					this._topBarView.updateScaleBtn(this._topBarProxy.scaleValue);
					PingBack.getInstance().scaleActionPing(this._topBarProxy.scaleValue);
				}
			} else {
				this._topBarProxy.downWardWheelCount++;
				if(this._topBarProxy.downWardWheelCount == 3) {
					this._topBarProxy.downWardWheelCount = 0;
					if(this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_50) {
						return;
					}
					_loc3_ = this._topBarProxy.scaleValue - 25;
					if(_loc3_ < 0) {
						_loc3_ = TopBarDef.SCALE_VALUE_100;
					}
					this.changeScaleValue(_loc3_);
					this._topBarView.updateScaleBtn(this._topBarProxy.scaleValue);
					PingBack.getInstance().scaleActionPing(this._topBarProxy.scaleValue);
				}
			}
		}
	}
}