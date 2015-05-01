package com.qiyi.player.wonder.plugins.ad {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.ad.view.ADViewMediator;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.ad.view.ADView;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class ADPlugins extends AbstractPlugins {
		
		public function ADPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:ADPlugins;
		
		public static function getInstance() : ADPlugins {
			if(_instance == null) {
				_instance = new ADPlugins(new SingletonClass());
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
						case ADProxy.NAME:
							if(!facade.hasProxy(ADProxy.NAME)) {
								facade.registerProxy(new ADProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(ADProxy.NAME)) {
				facade.registerProxy(new ADProxy());
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
						case ADViewMediator.NAME:
							this.createADViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createADViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
		}
		
		private function createADViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:UserProxy = null;
			var _loc3_:UserInfoVO = null;
			var _loc4_:ADProxy = null;
			var _loc5_:ADView = null;
			if(!facade.hasMediator(ADViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3_ = new UserInfoVO();
				_loc3_.isLogin = _loc2_.isLogin;
				_loc3_.passportID = _loc2_.passportID;
				_loc3_.userID = _loc2_.userID;
				_loc3_.userName = _loc2_.userName;
				_loc3_.userLevel = _loc2_.userLevel;
				_loc3_.userType = _loc2_.userType;
				_loc4_ = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
				_loc5_ = new ADView(param1,_loc4_.status.clone(),_loc3_);
				PanelManager.getInstance().register(_loc5_);
				facade.registerMediator(new ADViewMediator(_loc5_));
				_loc4_.addStatus(ADDef.STATUS_OPEN);
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
