package com.qiyi.player.wonder.plugins.loading {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.loading.model.LoadingProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.loading.view.LoadingViewMediator;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.loading.view.LoadingView;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	
	public class LoadingPlugins extends AbstractPlugins {
		
		public function LoadingPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:LoadingPlugins;
		
		public static function getInstance() : LoadingPlugins {
			if(_instance == null) {
				_instance = new LoadingPlugins(new SingletonClass());
			}
			return _instance;
		}
		
		override public function initModel(param1:Vector.<String> = null) : void {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			super.initModel(param1);
			if(param1) {
				_loc2_ = param1.length;
				_loc3_ = 0;
				while(_loc3_ < _loc2_) {
					switch(param1[_loc3_]) {
						case LoadingProxy.NAME:
							if(!facade.hasProxy(LoadingProxy.NAME)) {
								facade.registerProxy(new LoadingProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(LoadingProxy.NAME)) {
				facade.registerProxy(new LoadingProxy());
			}
			
		}
		
		override public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void {
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			super.initView(param1,param2);
			if(param2) {
				_loc3_ = param2.length;
				_loc4_ = 0;
				while(_loc4_ < _loc3_) {
					switch(param2[_loc4_]) {
						case LoadingViewMediator.NAME:
							this.createLoadingViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createLoadingViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
		}
		
		private function createLoadingViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:UserProxy = null;
			var _loc3_:UserInfoVO = null;
			var _loc4_:LoadingProxy = null;
			var _loc5_:LoadingView = null;
			if(!facade.hasMediator(LoadingViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3_ = new UserInfoVO();
				_loc3_.isLogin = _loc2_.isLogin;
				_loc3_.passportID = _loc2_.passportID;
				_loc3_.userID = _loc2_.userID;
				_loc3_.userName = _loc2_.userName;
				_loc3_.userLevel = _loc2_.userLevel;
				_loc3_.userType = _loc2_.userType;
				_loc4_ = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
				_loc5_ = new LoadingView(param1,_loc4_.status.clone(),_loc3_);
				PanelManager.getInstance().register(_loc5_);
				facade.registerMediator(new LoadingViewMediator(_loc5_));
				if(FlashVarConfig.isMemberMovie) {
					_loc5_.updatePreloaderURL(FlashVarConfig.preloaderVipURL);
				} else if(FlashVarConfig.qiyiProduced == "1" && !(FlashVarConfig.qiyiProducedPreloader == "")) {
					_loc5_.updatePreloaderURL(FlashVarConfig.qiyiProducedPreloader);
				} else if(FlashVarConfig.exclusive == "1" && !(FlashVarConfig.exclusivePreloader == "")) {
					_loc5_.updatePreloaderURL(FlashVarConfig.exclusivePreloader);
				} else {
					_loc5_.updatePreloaderURL(FlashVarConfig.preloaderURL);
				}
				
				
				if(FlashVarConfig.autoPlay) {
					_loc4_.addStatus(LoadingDef.STATUS_OPEN);
				}
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
