package com.qiyi.player.wonder.plugins.tips
{
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
	
	public class TipsPlugins extends AbstractPlugins
	{
		
		private static var _instance:TipsPlugins;
		
		public function TipsPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : TipsPlugins
		{
			if(_instance == null)
			{
				_instance = new TipsPlugins(new SingletonClass());
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
						case TipsProxy.NAME:
							if(!facade.hasProxy(TipsProxy.NAME))
							{
								facade.registerProxy(new TipsProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(TipsProxy.NAME))
			{
				facade.registerProxy(new TipsProxy());
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
						case TipsViewMediator.NAME:
							this.createTipsViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createTipsViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
		}
		
		private function createTipsViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:ControllBarProxy = null;
			var _loc5:TipsProxy = null;
			var _loc6:TipsView = null;
			if(!facade.hasMediator(TipsViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				TipManager.setADState(false);
				TipManager.setIsMember(!(_loc2.userLevel == UserDef.USER_LEVEL_NORMAL));
				TipManager.setIsLogin(_loc2.isLogin);
				TipManager.setPassportId(_loc2.passportID);
				_loc3 = new UserInfoVO();
				_loc3.isLogin = _loc2.isLogin;
				_loc3.passportID = _loc2.passportID;
				_loc3.userID = _loc2.userID;
				_loc3.userName = _loc2.userName;
				_loc3.userLevel = _loc2.userLevel;
				_loc3.userType = _loc2.userType;
				_loc4 = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
				_loc5 = facade.retrieveProxy(TipsProxy.NAME) as TipsProxy;
				_loc6 = new TipsView(param1,_loc5.status.clone(),_loc3);
				if(_loc4.hasStatus(ControllBarDef.STATUS_SHOW))
				{
					if(_loc4.hasStatus(ControllBarDef.STATUS_SEEK_BAR_THICK))
					{
						_loc6.setGap(TipsDef.STAGE_GAP_1);
					}
					else
					{
						_loc6.setGap(TipsDef.STAGE_GAP_2);
					}
				}
				else
				{
					_loc6.setGap(TipsDef.STAGE_GAP_3);
				}
				PanelManager.getInstance().register(_loc6);
				facade.registerMediator(new TipsViewMediator(_loc6));
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
