package com.qiyi.player.wonder.plugins.feedback
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.feedback.model.FeedbackProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackView;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackViewMediator;
	import com.qiyi.player.wonder.plugins.feedback.controller.FeebackOpenCloseCommand;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class FeedbackPlugins extends AbstractPlugins
	{
		
		private static var _instance:FeedbackPlugins;
		
		public function FeedbackPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : FeedbackPlugins
		{
			if(_instance == null)
			{
				_instance = new FeedbackPlugins(new SingletonClass());
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
						case FeedbackProxy.NAME:
							if(!facade.hasProxy(FeedbackProxy.NAME))
							{
								facade.registerProxy(new FeedbackProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(FeedbackProxy.NAME))
			{
				facade.registerProxy(new FeedbackProxy());
			}
			
		}
		
		override public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void
		{
			var _loc7:* = 0;
			var _loc8:* = 0;
			super.initView(param1,param2);
			var _loc3:UserProxy = null;
			var _loc4:UserInfoVO = null;
			var _loc5:FeedbackProxy = null;
			var _loc6:FeedbackView = null;
			if(param2)
			{
				_loc7 = param2.length;
				_loc8 = 0;
				while(_loc8 < _loc7)
				{
					switch(param2[_loc8])
					{
						case FeedbackViewMediator.NAME:
							this.createFeedbackViewMediator(param1);
							break;
					}
					_loc8++;
				}
			}
			else
			{
				this.createFeedbackViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
			facade.registerCommand(FeedbackDef.NOTIFIC_OPEN_CLOSE,FeebackOpenCloseCommand);
		}
		
		private function createFeedbackViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:FeedbackProxy = null;
			var _loc5:FeedbackView = null;
			if(!facade.hasMediator(FeedbackViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3 = new UserInfoVO();
				_loc3.isLogin = _loc2.isLogin;
				_loc3.passportID = _loc2.passportID;
				_loc3.userID = _loc2.userID;
				_loc3.userName = _loc2.userName;
				_loc3.userLevel = _loc2.userLevel;
				_loc3.userType = _loc2.userType;
				_loc4 = facade.retrieveProxy(FeedbackProxy.NAME) as FeedbackProxy;
				_loc5 = new FeedbackView(param1,_loc4.status.clone(),_loc3);
				PanelManager.getInstance().register(_loc5);
				facade.registerMediator(new FeedbackViewMediator(_loc5));
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
