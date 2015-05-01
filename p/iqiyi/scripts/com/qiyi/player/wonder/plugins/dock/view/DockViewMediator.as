package com.qiyi.player.wonder.plugins.dock.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.common.sw.ISwitch;
	import com.qiyi.player.wonder.plugins.dock.model.DockProxy;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import flash.events.MouseEvent;
	import com.iqiyi.components.global.GlobalStage;
	import com.qiyi.player.wonder.plugins.dock.DockDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.wonder.common.pingback.PingBack;
	import com.qiyi.player.wonder.common.pingback.PingBackDef;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.core.model.def.ScreenEnum;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.share.model.ShareProxy;
	import com.qiyi.player.wonder.plugins.share.ShareDef;
	import com.qiyi.player.wonder.body.model.JavascriptAPIProxy;
	import com.qiyi.player.wonder.plugins.offlinewatch.model.OfflineWatchProxy;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchDef;
	import flash.system.Capabilities;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.common.config.SystemConfig;
	import gs.TweenLite;
	
	public class DockViewMediator extends Mediator implements ISwitch {
		
		public function DockViewMediator(param1:DockView) {
			super(NAME,param1);
			this._dockView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.dock.view.DockViewMediator";
		
		private var _dockProxy:DockProxy;
		
		private var _dockView:DockView;
		
		override public function onRegister() : void {
			super.onRegister();
			SwitchManager.getInstance().register(this);
			this._dockProxy = facade.retrieveProxy(DockProxy.NAME) as DockProxy;
			this._dockView.addEventListener(DockEvent.Evt_Open,this.onDockViewOpen);
			this._dockView.addEventListener(DockEvent.Evt_Close,this.onDockViewClose);
			this._dockView.shareBtn.addEventListener(MouseEvent.CLICK,this.onShareBtnClick);
			this._dockView.openLightBtn.addEventListener(MouseEvent.CLICK,this.onOpenLightBtnClick);
			this._dockView.closeLightBtn.addEventListener(MouseEvent.CLICK,this.onCloseLightBtnClick);
			this._dockView.offlineWatchBtn.addEventListener(MouseEvent.CLICK,this.onOfflineWatchBtnClick);
			GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
		}
		
		override public function listNotificationInterests() : Array {
			return [DockDef.NOTIFIC_ADD_STATUS,DockDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_FULL_SCREEN,BodyDef.NOTIFIC_LEAVE_STAGE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_JS_LIGHT_CHANGED,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR,BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE,ADDef.NOTIFIC_ADD_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			var _loc5_:PlayerProxy = null;
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case DockDef.NOTIFIC_ADD_STATUS:
					this._dockView.onAddStatus(int(_loc2_));
					break;
				case DockDef.NOTIFIC_REMOVE_STATUS:
					this._dockView.onRemoveStatus(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._dockView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_FULL_SCREEN:
					if((SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK_LIGHT)) && !Boolean(_loc2_)) {
						this._dockProxy.addStatus(DockDef.STATUS_LIGHT_SHOW);
					} else {
						this._dockProxy.removeStatus(DockDef.STATUS_LIGHT_SHOW);
					}
					break;
				case BodyDef.NOTIFIC_LEAVE_STAGE:
					this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
					if(Boolean(_loc2_)) {
						this._dockProxy.addStatus(DockDef.STATUS_LIGHT_ON);
					} else {
						this._dockProxy.removeStatus(DockDef.STATUS_LIGHT_ON);
					}
					_loc5_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
					PingBack.getInstance().userActionPing(PingBackDef.LIGHT,_loc5_.curActor.currentTime);
					break;
				case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
					if(Boolean(_loc2_)) {
						this._dockProxy.removeStatus(DockDef.STATUS_OPEN);
					} else {
						this._dockProxy.addStatus(DockDef.STATUS_OPEN);
					}
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this.onPlayerSwitchPreActor();
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2_),true);
					break;
			}
		}
		
		public function getSwitchID() : Vector.<int> {
			return Vector.<int>([SwitchDef.ID_SHOW_DOCK,SwitchDef.ID_SHOW_DOCK_SHARE,SwitchDef.ID_SHOW_DOCK_LIGHT,SwitchDef.ID_SHOW_TWO_DIMENSION_CODE_BTN,SwitchDef.ID_SHOW_DOCK_DETAILS,SwitchDef.ID_SHOW_DOCK_OFFLINE_WATCH]);
		}
		
		public function onSwitchStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case SwitchDef.ID_SHOW_DOCK:
					if(!this.checkShowStatus()) {
						this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_DOCK_SHARE:
					if(param2) {
						this._dockProxy.addStatus(DockDef.STATUS_SHARE_SHOW);
					} else {
						this._dockProxy.removeStatus(DockDef.STATUS_SHARE_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_DOCK_LIGHT:
					if((param2) && !GlobalStage.isFullScreen()) {
						this._dockProxy.addStatus(DockDef.STATUS_LIGHT_SHOW);
					} else {
						this._dockProxy.removeStatus(DockDef.STATUS_LIGHT_SHOW);
					}
					break;
				case SwitchDef.ID_SHOW_DOCK_OFFLINE_WATCH:
					if(param2) {
						if(this.checkOfflineWatchShowStatus()) {
							this._dockProxy.addStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
						}
					} else {
						this._dockProxy.removeStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
					}
					break;
			}
		}
		
		private function checkShowStatus() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
			if((SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK) && _loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && !_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc2_.hasStatus(ADDef.STATUS_LOADING) && !_loc2_.hasStatus(ADDef.STATUS_PLAYING) && !_loc2_.hasStatus(ADDef.STATUS_PAUSED) && _loc1_.curActor.movieModel) && (!(_loc1_.curActor.movieModel.screenType == ScreenEnum.THREE_D)) && !_loc1_.curActor.smallWindowMode) {
				return true;
			}
			return false;
		}
		
		private function checkOfflineWatchShowStatus() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if((SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK_OFFLINE_WATCH)) && (_loc1_.curActor.movieModel)) {
				if(!_loc1_.curActor.movieModel.member) {
					return true;
				}
			}
			return false;
		}
		
		private function checkShareBtnShowStatus() : Boolean {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK_SHARE)) {
				return true;
			}
			return false;
		}
		
		private function onDockViewOpen(param1:DockEvent) : void {
			if(!this._dockProxy.hasStatus(DockDef.STATUS_OPEN)) {
				this._dockProxy.addStatus(DockDef.STATUS_OPEN);
			}
		}
		
		private function onDockViewClose(param1:DockEvent) : void {
			if(this._dockProxy.hasStatus(DockDef.STATUS_OPEN)) {
				this._dockProxy.removeStatus(DockDef.STATUS_OPEN);
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
			this._dockView.onUserInfoChanged(_loc2_);
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			var _loc4_:PlayerProxy = null;
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_READY:
					if(param2) {
						if(this.checkOfflineWatchShowStatus()) {
							this._dockProxy.addStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
						} else {
							this._dockProxy.removeStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
						}
						if(!this.checkShowStatus()) {
							this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
					if(param2) {
						_loc4_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
						if((_loc4_.curActor.movieInfo) && (_loc4_.curActor.movieInfo.allowDownload)) {
							this._dockProxy.addStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE);
						} else {
							this._dockProxy.removeStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE);
						}
					}
					break;
				case BodyDef.PLAYER_STATUS_STOPPING:
				case BodyDef.PLAYER_STATUS_STOPED:
					if((param2) && !this.checkShowStatus()) {
						this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
					}
					break;
			}
		}
		
		private function onPlayerSwitchPreActor() : void {
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			if(_loc1_.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY)) {
				if(this.checkOfflineWatchShowStatus()) {
					this._dockProxy.addStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
				} else {
					this._dockProxy.removeStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
				}
				if(!this.checkShowStatus()) {
					this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
				}
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ADDef.STATUS_LOADING:
				case ADDef.STATUS_PLAYING:
				case ADDef.STATUS_PAUSED:
					if((param2) && !this.checkShowStatus()) {
						this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
					}
					break;
			}
		}
		
		private function onShareBtnClick(param1:MouseEvent) : void {
			var _loc2_:ShareProxy = facade.retrieveProxy(ShareProxy.NAME) as ShareProxy;
			if(_loc2_.hasStatus(ShareDef.STATUS_OPEN)) {
				sendNotification(ShareDef.NOTIFIC_OPEN_CLOSE,false);
			} else {
				sendNotification(ShareDef.NOTIFIC_OPEN_CLOSE,true);
			}
		}
		
		private function onOpenLightBtnClick(param1:MouseEvent) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc3_.callJsSetLight(true);
		}
		
		private function onCloseLightBtnClick(param1:MouseEvent) : void {
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			_loc3_.callJsSetLight(false);
		}
		
		private function onOfflineWatchBtnClick(param1:MouseEvent) : void {
			var _loc3_:OfflineWatchProxy = null;
			var _loc2_:JavascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
			if(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT || FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE && (_loc2_.checkClientInstall())) {
				_loc2_.callJsDownload();
			} else {
				_loc3_ = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
				if(_loc3_.hasStatus(OfflineWatchDef.STATUS_OPEN)) {
					sendNotification(OfflineWatchDef.NOTIFIC_OPEN_CLOSE,false);
				} else {
					GlobalStage.setNormalScreen();
					sendNotification(OfflineWatchDef.NOTIFIC_OPEN_CLOSE,true);
					PingBack.getInstance().userActionPing(PingBackDef.DOWNLOAD_CLIENT);
					if(Capabilities.version.indexOf("WIN") == 0) {
						navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_TINY),"_blank");
					} else {
						navigateToURL(new URLRequest(SystemConfig.CLIENT_DOWNLOAD_URL_MAC),"_blank");
					}
				}
			}
			PingBack.getInstance().userActionPing(PingBackDef.CLICK_DOWNLOAD);
		}
		
		private function onMouseMove(param1:MouseEvent) : void {
			if(this.checkShowStatus()) {
				this._dockProxy.addStatus(DockDef.STATUS_SHOW);
				TweenLite.killTweensOf(this.delayedHideDock);
				TweenLite.delayedCall(DockDef.DOCK_HIND_DELAY / 1000,this.delayedHideDock);
			}
		}
		
		private function delayedHideDock() : void {
			this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
		}
	}
}
