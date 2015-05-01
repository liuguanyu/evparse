package com.qiyi.player.wonder.plugins.controllbar {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.controllbar.view.ControllBarViewMediator;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.plugins.controllbar.view.ControllBarView;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.qiyi.player.core.model.impls.pub.Settings;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class ControllBarPlugins extends AbstractPlugins {
		
		public function ControllBarPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:ControllBarPlugins;
		
		public static function getInstance() : ControllBarPlugins {
			if(_instance == null) {
				_instance = new ControllBarPlugins(new SingletonClass());
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
						case ControllBarProxy.NAME:
							if(!facade.hasProxy(ControllBarProxy.NAME)) {
								facade.registerProxy(new ControllBarProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(ControllBarProxy.NAME)) {
				facade.registerProxy(new ControllBarProxy());
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
						case ControllBarViewMediator.NAME:
							this.createControllBarViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createControllBarViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
		}
		
		private function createControllBarViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:UserProxy = null;
			var _loc3_:UserInfoVO = null;
			var _loc4_:ADProxy = null;
			var _loc5_:SwitchManager = null;
			var _loc6_:ControllBarProxy = null;
			var _loc7_:ControllBarView = null;
			if(!facade.hasMediator(ControllBarViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3_ = new UserInfoVO();
				_loc3_.isLogin = _loc2_.isLogin;
				_loc3_.passportID = _loc2_.passportID;
				_loc3_.userID = _loc2_.userID;
				_loc3_.userName = _loc2_.userName;
				_loc3_.userLevel = _loc2_.userLevel;
				_loc3_.userType = _loc2_.userType;
				_loc4_ = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
				_loc5_ = SwitchManager.getInstance();
				_loc6_ = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
				_loc6_.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW,false);
				if(_loc5_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR)) {
					_loc6_.addStatus(ControllBarDef.STATUS_SHOW);
				}
				_loc6_.addStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
				if(_loc5_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_FF)) {
					_loc6_.addStatus(ControllBarDef.STATUS_FF_SHOW,false);
				}
				if(_loc5_.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_VOLUME)) {
					_loc6_.addStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW,false);
				}
				if(FlashVarConfig.expandState) {
					_loc6_.addStatus(ControllBarDef.STATUS_EXPAND_UNFOLD,false);
				}
				_loc7_ = new ControllBarView(param1,_loc6_.status.clone(),_loc3_);
				_loc7_.volumeControlView.setVolume(Settings.instance.volumn,Settings.instance.mute);
				PanelManager.getInstance().register(_loc7_);
				facade.registerMediator(new ControllBarViewMediator(_loc7_));
				_loc6_.addStatus(ControllBarDef.STATUS_OPEN);
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
