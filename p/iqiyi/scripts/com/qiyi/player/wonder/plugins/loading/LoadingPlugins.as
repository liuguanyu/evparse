package com.qiyi.player.wonder.plugins.loading
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.loading.model.LoadingProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.loading.view.LoadingViewMediator;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.loading.view.LoadingView;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	
	public class LoadingPlugins extends AbstractPlugins
	{
		
		private static var _instance:LoadingPlugins;
		
		public function LoadingPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : LoadingPlugins
		{
			if(_instance == null)
			{
				_instance = new LoadingPlugins(new SingletonClass());
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
						case LoadingProxy.NAME:
							if(!facade.hasProxy(LoadingProxy.NAME))
							{
								facade.registerProxy(new LoadingProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(LoadingProxy.NAME))
			{
				facade.registerProxy(new LoadingProxy());
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
						case LoadingViewMediator.NAME:
							this.createLoadingViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createLoadingViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
		}
		
		private function createLoadingViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:LoadingProxy = null;
			var _loc5:LoadingView = null;
			if(!facade.hasMediator(LoadingViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3 = new UserInfoVO();
				_loc3.isLogin = _loc2.isLogin;
				_loc3.passportID = _loc2.passportID;
				_loc3.userID = _loc2.userID;
				_loc3.userName = _loc2.userName;
				_loc3.userLevel = _loc2.userLevel;
				_loc3.userType = _loc2.userType;
				_loc4 = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
				_loc5 = new LoadingView(param1,_loc4.status.clone(),_loc3);
				PanelManager.getInstance().register(_loc5);
				facade.registerMediator(new LoadingViewMediator(_loc5));
				if(FlashVarConfig.isMemberMovie)
				{
					_loc5.updatePreloaderURL(FlashVarConfig.preloaderVipURL);
				}
				else if(FlashVarConfig.qiyiProduced == "1" && !(FlashVarConfig.qiyiProducedPreloader == ""))
				{
					_loc5.updatePreloaderURL(FlashVarConfig.qiyiProducedPreloader);
				}
				else if(FlashVarConfig.exclusive == "1" && !(FlashVarConfig.exclusivePreloader == ""))
				{
					_loc5.updatePreloaderURL(FlashVarConfig.exclusivePreloader);
				}
				else
				{
					_loc5.updatePreloaderURL(FlashVarConfig.preloaderURL);
				}
				
				
				if(FlashVarConfig.autoPlay)
				{
					_loc4.addStatus(LoadingDef.STATUS_OPEN);
				}
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
