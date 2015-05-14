package com.qiyi.player.wonder.plugins.setting
{
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
	
	public class SettingPlugins extends AbstractPlugins
	{
		
		private static var _instance:SettingPlugins;
		
		public function SettingPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : SettingPlugins
		{
			if(_instance == null)
			{
				_instance = new SettingPlugins(new SingletonClass());
			}
			return _instance;
		}
		
		override public function initModel(param1:Vector.<String> = null) : void
		{
			var _loc2:* = 0;
			var _loc3:* = 0;
			super.initModel(param1);
			if(param1)
			{
				_loc2 = param1.length;
				_loc3 = 0;
				while(_loc3 < _loc2)
				{
					switch(param1[_loc3])
					{
						case SettingProxy.NAME:
							if(!facade.hasProxy(SettingProxy.NAME))
							{
								facade.registerProxy(new SettingProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(SettingProxy.NAME))
			{
				facade.registerProxy(new SettingProxy());
			}
			
		}
		
		override public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void
		{
			var _loc3:* = 0;
			var _loc4:* = 0;
			super.initView(param1,param2);
			if(param2)
			{
				_loc3 = param2.length;
				_loc4 = 0;
				while(_loc4 < _loc3)
				{
					switch(param2[_loc4])
					{
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
					_loc4++;
				}
			}
			else
			{
				this.createSettingViewMediator(param1);
				this.createDefinitionViewMediator(param1);
				this.createFilterViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
			facade.registerCommand(SettingDef.NOTIFIC_OPEN_CLOSE,SettingOpenCloseCommand);
			facade.registerCommand(SettingDef.NOTIFIC_DEFINITION_OPEN_CLOSE,DefinitionOpenCloseCommand);
			facade.registerCommand(SettingDef.NOTIFIC_FILTER_OPEN_CLOSE,FilterOpenCloseCommand);
		}
		
		private function createSettingViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:SettingProxy = null;
			var _loc3:SettingView = null;
			if(!facade.hasMediator(SettingViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
				_loc3 = new SettingView(param1,_loc2.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3);
				facade.registerMediator(new SettingViewMediator(_loc3));
			}
		}
		
		private function createDefinitionViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:SettingProxy = null;
			var _loc3:DefinitionView = null;
			if(!facade.hasMediator(DefinitionViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
				_loc3 = new DefinitionView(param1,_loc2.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3);
				facade.registerMediator(new DefinitionViewMediator(_loc3));
			}
		}
		
		private function createFilterViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:SettingProxy = null;
			var _loc3:FilterView = null;
			if(!facade.hasMediator(FilterViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
				_loc3 = new FilterView(param1,_loc2.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3);
				facade.registerMediator(new FilterViewMediator(_loc3));
			}
		}
		
		private function createUserInfoVO() : UserInfoVO
		{
			var _loc1:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2:UserInfoVO = new UserInfoVO();
			_loc2.isLogin = _loc1.isLogin;
			_loc2.passportID = _loc1.passportID;
			_loc2.userID = _loc1.userID;
			_loc2.userName = _loc1.userName;
			_loc2.userLevel = _loc1.userLevel;
			_loc2.userType = _loc1.userType;
			return _loc2;
		}
	}
}

class SingletonClass extends Object
{
	
	function SingletonClass()
	{
		super();
	}
}
