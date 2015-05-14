package com.qiyi.player.wonder.plugins.recommend
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.recommend.view.RecommendViewMediator;
	import com.qiyi.player.wonder.plugins.recommend.controller.RecommendOpenCloseCommand;
	import com.qiyi.player.wonder.plugins.recommend.view.RecommendView;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.body.model.UserProxy;
	
	public class RecommendPlugins extends AbstractPlugins
	{
		
		private static var _instance:RecommendPlugins;
		
		public function RecommendPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : RecommendPlugins
		{
			if(_instance == null)
			{
				_instance = new RecommendPlugins(new SingletonClass());
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
						case RecommendProxy.NAME:
							if(!facade.hasProxy(RecommendProxy.NAME))
							{
								facade.registerProxy(new RecommendProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(RecommendProxy.NAME))
			{
				facade.registerProxy(new RecommendProxy());
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
						case RecommendViewMediator.NAME:
							this.createRecommendViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createRecommendViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
			facade.registerCommand(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE,RecommendOpenCloseCommand);
		}
		
		private function createRecommendViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:RecommendProxy = null;
			var _loc3:RecommendView = null;
			if(!facade.hasMediator(RecommendViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(RecommendProxy.NAME) as RecommendProxy;
				_loc3 = new RecommendView(param1,_loc2.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3);
				facade.registerMediator(new RecommendViewMediator(_loc3));
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
