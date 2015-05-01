package com.qiyi.player.wonder.plugins.setting {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.setting.model.SettingProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.setting.view.SettingViewMediator;
	import com.qiyi.player.wonder.plugins.setting.view.DefinitionViewMediator;
	import com.qiyi.player.wonder.plugins.setting.view.FilterViewMediator;
	import com.qiyi.player.wonder.plugins.setting.controller.SettingOpenCloseCommand;
	import com.qiyi.player.wonder.plugins.setting.controller.DefinitionOpenCloseCommand;
	import com.qiyi.player.wonder.plugins.setting.controller.FilterOpenCloseCommand;
	import com.qiyi.player.wonder.plugins.setting.view.SettingView;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.plugins.setting.view.DefinitionView;
	import com.qiyi.player.wonder.plugins.setting.view.FilterView;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.body.model.UserProxy;
	
	public class SettingPlugins extends AbstractPlugins {
		
		public function SettingPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:SettingPlugins;
		
		public static function getInstance() : SettingPlugins {
			if(_instance == null) {
				_instance = new SettingPlugins(new SingletonClass());
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
						case SettingProxy.NAME:
							if(!facade.hasProxy(SettingProxy.NAME)) {
								facade.registerProxy(new SettingProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(SettingProxy.NAME)) {
				facade.registerProxy(new SettingProxy());
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
						case SettingViewMediator.NAME:
							this.createSettingViewMediator(param1);
							break;
						case DefinitionViewMediator.NAME:
							this.createDefinitionViewMediator(param1);
							break;
						case FilterViewMediator.NAME:
							this.createFilterViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createSettingViewMediator(param1);
				this.createDefinitionViewMediator(param1);
				this.createFilterViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
			facade.registerCommand(SettingDef.NOTIFIC_OPEN_CLOSE,SettingOpenCloseCommand);
			facade.registerCommand(SettingDef.NOTIFIC_DEFINITION_OPEN_CLOSE,DefinitionOpenCloseCommand);
			facade.registerCommand(SettingDef.NOTIFIC_FILTER_OPEN_CLOSE,FilterOpenCloseCommand);
		}
		
		private function createSettingViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:SettingProxy = null;
			var _loc3_:SettingView = null;
			if(!facade.hasMediator(SettingViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
				_loc3_ = new SettingView(param1,_loc2_.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3_);
				facade.registerMediator(new SettingViewMediator(_loc3_));
			}
		}
		
		private function createDefinitionViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:SettingProxy = null;
			var _loc3_:DefinitionView = null;
			if(!facade.hasMediator(DefinitionViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
				_loc3_ = new DefinitionView(param1,_loc2_.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3_);
				facade.registerMediator(new DefinitionViewMediator(_loc3_));
			}
		}
		
		private function createFilterViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:SettingProxy = null;
			var _loc3_:FilterView = null;
			if(!facade.hasMediator(FilterViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
				_loc3_ = new FilterView(param1,_loc2_.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3_);
				facade.registerMediator(new FilterViewMediator(_loc3_));
			}
		}
		
		private function createUserInfoVO() : UserInfoVO {
			var _loc1_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2_:UserInfoVO = new UserInfoVO();
			_loc2_.isLogin = _loc1_.isLogin;
			_loc2_.passportID = _loc1_.passportID;
			_loc2_.userID = _loc1_.userID;
			_loc2_.userName = _loc1_.userName;
			_loc2_.userLevel = _loc1_.userLevel;
			_loc2_.userType = _loc1_.userType;
			return _loc2_;
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
