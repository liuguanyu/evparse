package com.qiyi.player.wonder.plugins.share
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.share.model.ShareProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.share.view.ShareViewMediator;
	import com.qiyi.player.wonder.plugins.share.controller.ShareOpenCloseCommand;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.share.view.ShareView;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class SharePlugins extends AbstractPlugins
	{
		
		private static var _instance:SharePlugins;
		
		public function SharePlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : SharePlugins
		{
			if(_instance == null)
			{
				_instance = new SharePlugins(new SingletonClass());
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
						case ShareProxy.NAME:
							if(!facade.hasProxy(ShareProxy.NAME))
							{
								facade.registerProxy(new ShareProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(ShareProxy.NAME))
			{
				facade.registerProxy(new ShareProxy());
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
						case ShareViewMediator.NAME:
							this.createShareViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createShareViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
			facade.registerCommand(ShareDef.NOTIFIC_OPEN_CLOSE,ShareOpenCloseCommand);
		}
		
		private function createShareViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:ShareProxy = null;
			var _loc5:ShareView = null;
			if(!facade.hasMediator(ShareViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3 = new UserInfoVO();
				_loc3.isLogin = _loc2.isLogin;
				_loc3.passportID = _loc2.passportID;
				_loc3.userID = _loc2.userID;
				_loc3.userName = _loc2.userName;
				_loc3.userLevel = _loc2.userLevel;
				_loc3.userType = _loc2.userType;
				_loc4 = facade.retrieveProxy(ShareProxy.NAME) as ShareProxy;
				_loc5 = new ShareView(param1,_loc4.status.clone(),_loc3);
				PanelManager.getInstance().register(_loc5);
				facade.registerMediator(new ShareViewMediator(_loc5));
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
