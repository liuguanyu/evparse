package com.qiyi.player.wonder.plugins.loading.view {
	import org.puremvc.as3.patterns.mediator.Mediator;
	import com.qiyi.player.wonder.plugins.loading.model.LoadingProxy;
	import com.qiyi.player.wonder.plugins.loading.LoadingDef;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.ad.ADDef;
	import org.puremvc.as3.interfaces.INotification;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinueInfo;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	
	public class LoadingViewMediator extends Mediator {
		
		public function LoadingViewMediator(param1:LoadingView) {
			super(NAME,param1);
			this._loadingView = param1;
		}
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.loading.view.LoadingViewMediator";
		
		private var _loadingProxy:LoadingProxy;
		
		private var _loadingView:LoadingView;
		
		override public function onRegister() : void {
			super.onRegister();
			this._loadingProxy = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
			this._loadingView.addEventListener(LoadingEvent.Evt_Open,this.onLoadingViewOpen);
			this._loadingView.addEventListener(LoadingEvent.Evt_Close,this.onLoadingViewClose);
		}
		
		override public function listNotificationInterests() : Array {
			return [LoadingDef.NOTIFIC_ADD_STATUS,LoadingDef.NOTIFIC_REMOVE_STATUS,BodyDef.NOTIFIC_RESIZE,BodyDef.NOTIFIC_CHECK_USER_COMPLETE,BodyDef.NOTIFIC_PLAYER_ADD_STATUS,BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS,BodyDef.NOTIFIC_PLAYER_START_REFRESH,ADDef.NOTIFIC_ADD_STATUS,ADDef.NOTIFIC_REMOVE_STATUS];
		}
		
		override public function handleNotification(param1:INotification) : void {
			super.handleNotification(param1);
			var _loc2_:Object = param1.getBody();
			var _loc3_:String = param1.getName();
			var _loc4_:String = param1.getType();
			switch(_loc3_) {
				case LoadingDef.NOTIFIC_ADD_STATUS:
					this._loadingView.onAddStatus(int(_loc2_));
					break;
				case LoadingDef.NOTIFIC_REMOVE_STATUS:
					this._loadingView.onRemoveStatus(int(_loc2_));
					if(int(_loc2_) == LoadingDef.STATUS_OPEN) {
						this._loadingProxy.isFirstLoading = false;
					}
					break;
				case BodyDef.NOTIFIC_RESIZE:
					this._loadingView.onResize(_loc2_.w,_loc2_.h);
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
				case BodyDef.NOTIFIC_PLAYER_START_REFRESH:
					if(_loc4_ == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
						this.updatePreloaderURL();
						this._loadingProxy.addStatus(LoadingDef.STATUS_OPEN);
					}
					break;
				case ADDef.NOTIFIC_ADD_STATUS:
					this.onADStatusChanged(int(_loc2_),true);
					break;
				case ADDef.NOTIFIC_REMOVE_STATUS:
					this.onADStatusChanged(int(_loc2_),false);
					break;
			}
		}
		
		private function onLoadingViewOpen(param1:LoadingEvent) : void {
			if(!this._loadingProxy.hasStatus(LoadingDef.STATUS_OPEN)) {
				this._loadingProxy.addStatus(LoadingDef.STATUS_OPEN);
			}
		}
		
		private function onLoadingViewClose(param1:LoadingEvent) : void {
			if(this._loadingProxy.hasStatus(LoadingDef.STATUS_OPEN)) {
				this._loadingProxy.removeStatus(LoadingDef.STATUS_OPEN);
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
			this._loadingView.onUserInfoChanged(_loc2_);
		}
		
		private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void {
			if(param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR) {
				return;
			}
			switch(param1) {
				case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
					if(param2) {
						this.updatePreloaderURL();
						this._loadingProxy.addStatus(LoadingDef.STATUS_OPEN);
					}
					break;
				case BodyDef.PLAYER_STATUS_PLAYING:
				case BodyDef.PLAYER_STATUS_FAILED:
					if(param2) {
						this._loadingProxy.removeStatus(LoadingDef.STATUS_OPEN);
					}
					break;
			}
		}
		
		private function onADStatusChanged(param1:int, param2:Boolean) : void {
			switch(param1) {
				case ADDef.STATUS_LOADING:
					if(param2) {
						this.updatePreloaderURL();
						this._loadingProxy.addStatus(LoadingDef.STATUS_OPEN);
					}
					break;
				case ADDef.STATUS_PLAYING:
					if(param2) {
						this._loadingProxy.removeStatus(LoadingDef.STATUS_OPEN);
					}
					break;
			}
		}
		
		private function updatePreloaderURL() : void {
			var _loc3_:ContinueInfo = null;
			var _loc1_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc2_:ContinuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
			if((_loc1_.curActor) && (_loc1_.curActor.loadMovieParams)) {
				if(_loc1_.curActor.loadMovieParams.movieIsMember) {
					this._loadingView.updatePreloaderURL(FlashVarConfig.preloaderVipURL);
				} else if(this._loadingProxy.isFirstLoading) {
					if(FlashVarConfig.qiyiProduced == "1" && !(FlashVarConfig.qiyiProducedPreloader == "")) {
						this._loadingView.updatePreloaderURL(FlashVarConfig.qiyiProducedPreloader);
					} else if(FlashVarConfig.exclusive == "1" && !(FlashVarConfig.exclusivePreloader == "")) {
						this._loadingView.updatePreloaderURL(FlashVarConfig.exclusivePreloader);
					} else {
						this._loadingView.updatePreloaderURL(FlashVarConfig.preloaderURL);
					}
					
				} else {
					_loc3_ = _loc2_.findContinueInfo(_loc1_.curActor.loadMovieParams.tvid,_loc1_.curActor.loadMovieParams.vid);
					if(!(_loc3_ == null) && _loc3_.qiyiProduced == "1" && !(FlashVarConfig.qiyiProducedPreloader == "")) {
						this._loadingView.updatePreloaderURL(FlashVarConfig.qiyiProducedPreloader);
					} else if(!(_loc3_ == null) && _loc3_.exclusive == "1" && !(FlashVarConfig.exclusivePreloader == "")) {
						this._loadingView.updatePreloaderURL(FlashVarConfig.exclusivePreloader);
					} else {
						this._loadingView.updatePreloaderURL(FlashVarConfig.preloaderURL);
					}
					
				}
				
			} else {
				this._loadingView.updatePreloaderURL(FlashVarConfig.preloaderURL);
			}
		}
	}
}
