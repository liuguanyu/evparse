package com.qiyi.player.wonder.plugins.controllbar
{
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
	
	public class ControllBarPlugins extends AbstractPlugins
	{
		
		private static var _instance:ControllBarPlugins;
		
		public function ControllBarPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : ControllBarPlugins
		{
			if(_instance == null)
			{
				_instance = new ControllBarPlugins(new SingletonClass());
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
						case ControllBarProxy.NAME:
							if(!facade.hasProxy(ControllBarProxy.NAME))
							{
								facade.registerProxy(new ControllBarProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(ControllBarProxy.NAME))
			{
				facade.registerProxy(new ControllBarProxy());
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
						case ControllBarViewMediator.NAME:
							this.createControllBarViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createControllBarViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
		}
		
		private function createControllBarViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:ADProxy = null;
			var _loc5:SwitchManager = null;
			var _loc6:ControllBarProxy = null;
			var _loc7:ControllBarView = null;
			if(!facade.hasMediator(ControllBarViewMediator.NAME))
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
				_loc5 = SwitchManager.getInstance();
				_loc6 = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
				_loc6.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW,false);
				if(_loc5.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR))
				{
					_loc6.addStatus(ControllBarDef.STATUS_SHOW);
				}
				_loc6.addStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
				if(_loc5.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_FF))
				{
					_loc6.addStatus(ControllBarDef.STATUS_FF_SHOW,false);
				}
				if(_loc5.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_VOLUME))
				{
					_loc6.addStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW,false);
				}
				if(FlashVarConfig.expandState)
				{
					_loc6.addStatus(ControllBarDef.STATUS_EXPAND_UNFOLD,false);
				}
				_loc7 = new ControllBarView(param1,_loc6.status.clone(),_loc3);
				_loc7.volumeControlView.setVolume(Settings.instance.volumn,Settings.instance.mute);
				PanelManager.getInstance().register(_loc7);
				facade.registerMediator(new ControllBarViewMediator(_loc7));
				_loc6.addStatus(ControllBarDef.STATUS_OPEN);
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
