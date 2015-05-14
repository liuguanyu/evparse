package com.qiyi.player.wonder.plugins.dock
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.dock.model.DockProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.dock.view.DockViewMediator;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.plugins.dock.view.DockView;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.iqiyi.components.global.GlobalStage;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class DockPlugins extends AbstractPlugins
	{
		
		private static var _instance:DockPlugins;
		
		public function DockPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : DockPlugins
		{
			if(_instance == null)
			{
				_instance = new DockPlugins(new SingletonClass());
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
						case DockProxy.NAME:
							if(!facade.hasProxy(DockProxy.NAME))
							{
								facade.registerProxy(new DockProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(DockProxy.NAME))
			{
				facade.registerProxy(new DockProxy());
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
						case DockViewMediator.NAME:
							this.createDockViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createDockViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
		}
		
		private function createDockViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:PlayerProxy = null;
			var _loc3:UserProxy = null;
			var _loc4:UserInfoVO = null;
			var _loc5:SwitchManager = null;
			var _loc6:DockProxy = null;
			var _loc7:DockView = null;
			if(!facade.hasMediator(DockViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc4 = new UserInfoVO();
				_loc4.isLogin = _loc3.isLogin;
				_loc4.passportID = _loc3.passportID;
				_loc4.userID = _loc3.userID;
				_loc4.userName = _loc3.userName;
				_loc4.userLevel = _loc3.userLevel;
				_loc4.userType = _loc3.userType;
				_loc5 = SwitchManager.getInstance();
				_loc6 = facade.retrieveProxy(DockProxy.NAME) as DockProxy;
				if(_loc5.getStatus(SwitchDef.ID_SHOW_DOCK_SHARE))
				{
					_loc6.addStatus(DockDef.STATUS_SHARE_SHOW,false);
				}
				if((_loc5.getStatus(SwitchDef.ID_SHOW_DOCK_LIGHT)) && !GlobalStage.isFullScreen())
				{
					_loc6.addStatus(DockDef.STATUS_LIGHT_SHOW,false);
				}
				if((_loc2.curActor.movieInfo) && (_loc2.curActor.movieInfo.allowDownload))
				{
					_loc6.addStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE,false);
				}
				_loc7 = new DockView(param1,_loc6.status.clone(),_loc4);
				PanelManager.getInstance().register(_loc7);
				facade.registerMediator(new DockViewMediator(_loc7));
				_loc6.addStatus(DockDef.STATUS_OPEN);
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
