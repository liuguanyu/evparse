package com.qiyi.player.wonder.plugins.tips {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.tips.model.TipsProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.tips.view.TipsViewMediator;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy;
	import com.qiyi.player.wonder.plugins.tips.view.TipsView;
	import com.qiyi.player.wonder.plugins.tips.view.parts.TipManager;
	import com.qiyi.player.user.UserDef;
	import com.qiyi.player.wonder.plugins.controllbar.ControllBarDef;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class TipsPlugins extends AbstractPlugins {
		
		public function TipsPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:TipsPlugins;
		
		public static function getInstance() : TipsPlugins {
			if(_instance == null) {
				_instance = new TipsPlugins(new SingletonClass());
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
						case TipsProxy.NAME:
							if(!facade.hasProxy(TipsProxy.NAME)) {
								facade.registerProxy(new TipsProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(TipsProxy.NAME)) {
				facade.registerProxy(new TipsProxy());
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
						case TipsViewMediator.NAME:
							this.createTipsViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createTipsViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
		}
		
		private function createTipsViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:UserProxy = null;
			var _loc3_:UserInfoVO = null;
			var _loc4_:ControllBarProxy = null;
			var _loc5_:TipsProxy = null;
			var _loc6_:TipsView = null;
			if(!facade.hasMediator(TipsViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				TipManager.setADState(false);
				TipManager.setIsMember(!(_loc2_.userLevel == UserDef.USER_LEVEL_NORMAL));
				TipManager.setIsLogin(_loc2_.isLogin);
				TipManager.setPassportId(_loc2_.passportID);
				_loc3_ = new UserInfoVO();
				_loc3_.isLogin = _loc2_.isLogin;
				_loc3_.passportID = _loc2_.passportID;
				_loc3_.userID = _loc2_.userID;
				_loc3_.userName = _loc2_.userName;
				_loc3_.userLevel = _loc2_.userLevel;
				_loc3_.userType = _loc2_.userType;
				_loc4_ = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
				_loc5_ = facade.retrieveProxy(TipsProxy.NAME) as TipsProxy;
				_loc6_ = new TipsView(param1,_loc5_.status.clone(),_loc3_);
				if(_loc4_.hasStatus(ControllBarDef.STATUS_SHOW)) {
					if(_loc4_.hasStatus(ControllBarDef.STATUS_SEEK_BAR_THICK)) {
						_loc6_.setGap(TipsDef.STAGE_GAP_1);
					} else {
						_loc6_.setGap(TipsDef.STAGE_GAP_2);
					}
				} else {
					_loc6_.setGap(TipsDef.STAGE_GAP_3);
				}
				PanelManager.getInstance().register(_loc6_);
				facade.registerMediator(new TipsViewMediator(_loc6_));
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
