package com.qiyi.player.wonder.plugins.continueplay
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.continueplay.view.ContinuePlayViewMediator;
	import com.qiyi.player.wonder.plugins.continueplay.controller.ContinuePlayOpenCloseCommand;
	import com.qiyi.player.wonder.body.BodyDef;
	import com.qiyi.player.wonder.plugins.continueplay.controller.AddVideoListCommand;
	import com.qiyi.player.wonder.plugins.continueplay.controller.RemoveVideoListCommand;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.continueplay.view.ContinuePlayView;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class ContinuePlayPlugins extends AbstractPlugins
	{
		
		private static var _instance:ContinuePlayPlugins;
		
		public function ContinuePlayPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : ContinuePlayPlugins
		{
			if(_instance == null)
			{
				_instance = new ContinuePlayPlugins(new SingletonClass());
			}
			return _instance;
		}
		
		override public function initModel(param1:Vector.<String> = null) : void
		{
			var _loc4:* = 0;
			var _loc5:* = 0;
			super.initModel(param1);
			var _loc2:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3:ContinuePlayProxy = null;
			if(param1)
			{
				_loc4 = param1.length;
				_loc5 = 0;
				while(_loc5 < _loc4)
				{
					switch(param1[_loc5])
					{
						case ContinuePlayProxy.NAME:
							if(!facade.hasProxy(ContinuePlayProxy.NAME))
							{
								_loc3 = new ContinuePlayProxy();
								_loc3.injectPlayerProxy(_loc2);
								facade.registerProxy(_loc3);
							}
							break;
					}
					_loc5++;
				}
			}
			else if(!facade.hasProxy(ContinuePlayProxy.NAME))
			{
				_loc3 = new ContinuePlayProxy();
				_loc3.injectPlayerProxy(_loc2);
				facade.registerProxy(_loc3);
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
						case ContinuePlayViewMediator.NAME:
							this.createContinuePlayViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createContinuePlayViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
			facade.registerCommand(ContinuePlayDef.NOTIFIC_OPEN_CLOSE,ContinuePlayOpenCloseCommand);
			facade.registerCommand(BodyDef.NOTIFIC_JS_CALL_ADD_VIDEO_LIST,AddVideoListCommand);
			facade.registerCommand(BodyDef.NOTIFIC_JS_CALL_REMOVE_FROM_LIST,RemoveVideoListCommand);
		}
		
		private function createContinuePlayViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:ContinuePlayProxy = null;
			var _loc5:ContinuePlayView = null;
			if(!facade.hasMediator(ContinuePlayViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3 = new UserInfoVO();
				_loc3.isLogin = _loc2.isLogin;
				_loc3.passportID = _loc2.passportID;
				_loc3.userID = _loc2.userID;
				_loc3.userName = _loc2.userName;
				_loc3.userLevel = _loc2.userLevel;
				_loc3.userType = _loc2.userType;
				_loc4 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
				_loc5 = new ContinuePlayView(param1,_loc4.status.clone(),_loc3);
				PanelManager.getInstance().register(_loc5);
				facade.registerMediator(new ContinuePlayViewMediator(_loc5));
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
