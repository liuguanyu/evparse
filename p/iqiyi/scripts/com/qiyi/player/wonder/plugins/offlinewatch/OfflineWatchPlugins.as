package com.qiyi.player.wonder.plugins.offlinewatch
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.offlinewatch.model.OfflineWatchProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.offlinewatch.view.OfflineWatchViewMediator;
	import com.qiyi.player.wonder.plugins.offlinewatch.controller.OfflineWatchOpenCloseCommand;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.offlinewatch.view.OfflineWatchView;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class OfflineWatchPlugins extends AbstractPlugins
	{
		
		private static var _instance:OfflineWatchPlugins;
		
		public function OfflineWatchPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : OfflineWatchPlugins
		{
			if(_instance == null)
			{
				_instance = new OfflineWatchPlugins(new SingletonClass());
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
						case OfflineWatchProxy.NAME:
							if(!facade.hasProxy(OfflineWatchProxy.NAME))
							{
								facade.registerProxy(new OfflineWatchProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(OfflineWatchProxy.NAME))
			{
				facade.registerProxy(new OfflineWatchProxy());
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
						case OfflineWatchViewMediator.NAME:
							this.createOfflineWatchViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createOfflineWatchViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
			facade.registerCommand(OfflineWatchDef.NOTIFIC_OPEN_CLOSE,OfflineWatchOpenCloseCommand);
		}
		
		private function createOfflineWatchViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:OfflineWatchProxy = null;
			var _loc5:OfflineWatchView = null;
			if(!facade.hasMediator(OfflineWatchViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3 = new UserInfoVO();
				_loc3.isLogin = _loc2.isLogin;
				_loc3.passportID = _loc2.passportID;
				_loc3.userID = _loc2.userID;
				_loc3.userName = _loc2.userName;
				_loc3.userLevel = _loc2.userLevel;
				_loc3.userType = _loc2.userType;
				_loc4 = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
				_loc5 = new OfflineWatchView(param1,_loc4.status.clone(),_loc3);
				PanelManager.getInstance().register(_loc5);
				facade.registerMediator(new OfflineWatchViewMediator(_loc5));
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
