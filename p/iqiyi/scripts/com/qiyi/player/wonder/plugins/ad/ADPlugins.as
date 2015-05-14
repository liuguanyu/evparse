package com.qiyi.player.wonder.plugins.ad
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.ad.model.ADProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.ad.view.ADViewMediator;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.ad.view.ADView;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class ADPlugins extends AbstractPlugins
	{
		
		private static var _instance:ADPlugins;
		
		public function ADPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : ADPlugins
		{
			if(_instance == null)
			{
				_instance = new ADPlugins(new SingletonClass());
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
						case ADProxy.NAME:
							if(!facade.hasProxy(ADProxy.NAME))
							{
								facade.registerProxy(new ADProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(ADProxy.NAME))
			{
				facade.registerProxy(new ADProxy());
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
						case ADViewMediator.NAME:
							this.createADViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createADViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
		}
		
		private function createADViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:ADProxy = null;
			var _loc5:ADView = null;
			if(!facade.hasMediator(ADViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3 = new UserInfoVO();
				_loc3.isLogin = _loc2.isLogin;
				_loc3.passportID = _loc2.passportID;
				_loc3.userID = _loc2.userID;
				_loc3.userName = _loc2.userName;
				_loc3.userLevel = _loc2.userLevel;
				_loc3.userType = _loc2.userType;
				_loc4 = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
				_loc5 = new ADView(param1,_loc4.status.clone(),_loc3);
				PanelManager.getInstance().register(_loc5);
				facade.registerMediator(new ADViewMediator(_loc5));
				_loc4.addStatus(ADDef.STATUS_OPEN);
			}
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
