package com.qiyi.player.wonder.plugins.offlinewatch.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.offlinewatch.model.OfflineWatchProxy;
	import com.qiyi.player.wonder.plugins.offlinewatch.OfflineWatchDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	
	public class OfflineWatchViewMediator extends Mediator {
		
		public function OfflineWatchViewMediator(param1:OfflineWatchView) {
			super(NAME,param1);
			this._offlineWatchView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.offlinewatch.view.OfflineWatchViewMediator";
		
		private var _offlineWatchProxy:OfflineWatchProxy;
		
		private var _offlineWatchView:OfflineWatchView;
		
		override public function onRegister() : void {
			super.onRegister();
			this._offlineWatchProxy = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
			this._offlineWatchView.addEventListener(OfflineWatchEvent.Evt_Open,this.onOfflineWatchViewOpen);
			this._offlineWatchView.addEventListener(OfflineWatchEvent.Evt_Close,this.onOfflineWatchViewClose);
		}
		
		override public function listNotificationInterests() : Array {
			return [OfflineWatchDef.NOTIFIC_ADD_STATUS,OfflineWatchDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR];
		}
		
		override public function handleNotification(param1:INotification) : void {
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case OfflineWatchDef.NOTIFIC_ADD_STATUS:
					if(int(_loc2_) == OfflineWatchDef.STATUS_OPEN) {
						sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
					}
					this._offlineWatchView.onAddStatus(int(_loc2_));
					break;
				case OfflineWatchDef.NOTIFIC_REMOVE_STATUS:
					if(int(_loc2_) == OfflineWatchDef.STATUS_OPEN) {
						sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
					}
					this._offlineWatchView.onRemoveStatus(int(_loc2_));
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._offlineWatchView.onResize(_loc2_.w,_loc2_.h);
					break;
				case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
					this.onCheckUserComplete();
					break;
				case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
					this.onPlayerStatusChanged(int(_loc2_),true,_loc4_);
					break;
				case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
					this._offlineWatchProxy.removeStatus(OfflineWatchDef.STATUS_OPEN);
					break;
			}
		}
		
		private function onOfflineWatchViewOpen(param1:OfflineWatchEvent) : void {
			if(!this._offlineWatchProxy.hasStatus(OfflineWatchDef.STATUS_OPEN)) {
				this._offlineWatchProxy.addStatus(OfflineWatchDef.STATUS_OPEN);
			}
		}
		
		private function onOfflineWatchViewClose(param1:OfflineWatchEvent) : void {
			if(this._offlineWatchProxy.hasStatus(OfflineWatchDef.STATUS_OPEN)) {
				this._offlineWatchProxy.removeStatus(OfflineWatchDef.STATUS_OPEN);
			}
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
				case BodyDef.PLAYER_STATUS_STOPED:
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2) {
						this._offlineWatchProxy.removeStatus(OfflineWatchDef.STATUS_OPEN);
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
			this._offlineWatchView.onUserInfoChanged(_loc2_);
		}
	}
}
