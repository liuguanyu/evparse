package com.qiyi.player.wonder.plugins.scenetile
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileToolViewMediator;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileBarrageViewMediator;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileScoreViewMediator;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileStreamLimitViewMediator;
	import com.qiyi.player.wonder.plugins.scenetile.controller.SceneTileScoreOpenCloseCommand;
	import com.qiyi.player.wonder.plugins.scenetile.controller.SceneTileStreamLimitOpenCloseCommand;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileToolView;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileBarrageView;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileScoreView;
	import com.qiyi.player.wonder.plugins.scenetile.view.SceneTileStreamLimitView;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.body.model.UserProxy;
	
	public class SceneTilePlugins extends AbstractPlugins
	{
		
		private static var _instance:SceneTilePlugins;
		
		public function SceneTilePlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : SceneTilePlugins
		{
			if(_instance == null)
			{
				_instance = new SceneTilePlugins(new SingletonClass());
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
						case SceneTileProxy.NAME:
							if(!facade.hasProxy(SceneTileProxy.NAME))
							{
								facade.registerProxy(new SceneTileProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(SceneTileProxy.NAME))
			{
				facade.registerProxy(new SceneTileProxy());
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
						case SceneTileToolViewMediator.NAME:
							this.createSceneTileToolViewMediator(param1);
							break;
						case SceneTileBarrageViewMediator.NAME:
							this.createSceneTileBarrageViewMediator(param1);
							break;
						case SceneTileScoreViewMediator.NAME:
							this.createSceneTileScoreViewMediator(param1);
							break;
						case SceneTileStreamLimitViewMediator.NAME:
							this.createSceneTileStreamLimitViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createSceneTileToolViewMediator(param1);
				this.createSceneTileBarrageViewMediator(param1);
				this.createSceneTileScoreViewMediator(param1);
				this.createSceneTileStreamLimitViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
			facade.registerCommand(SceneTileDef.NOTIFIC_OPEN_CLOSE_SCORE,SceneTileScoreOpenCloseCommand);
			facade.registerCommand(SceneTileDef.NOTIFIC_OPEN_CLOSE_STREAM_LIMIT,SceneTileStreamLimitOpenCloseCommand);
		}
		
		private function createSceneTileToolViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:SceneTileProxy = null;
			var _loc3:SceneTileToolView = null;
			if(!facade.hasMediator(SceneTileToolViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
				if(!FlashVarConfig.autoPlay)
				{
					_loc2.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW,false);
				}
				_loc3 = new SceneTileToolView(param1,_loc2.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3);
				facade.registerMediator(new SceneTileToolViewMediator(_loc3));
				_loc2.addStatus(SceneTileDef.STATUS_TOOL_OPEN);
			}
		}
		
		private function createSceneTileBarrageViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:SceneTileProxy = null;
			var _loc3:SceneTileBarrageView = null;
			if(!facade.hasMediator(SceneTileBarrageViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
				_loc3 = new SceneTileBarrageView(param1,_loc2.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3);
				facade.registerMediator(new SceneTileBarrageViewMediator(_loc3));
				_loc2.addStatus(SceneTileDef.STATUS_BARRAGE_OPEN);
			}
		}
		
		private function createSceneTileScoreViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:SceneTileProxy = null;
			var _loc3:SceneTileScoreView = null;
			if(!facade.hasMediator(SceneTileScoreViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
				_loc3 = new SceneTileScoreView(param1,_loc2.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3);
				facade.registerMediator(new SceneTileScoreViewMediator(_loc3));
			}
		}
		
		private function createSceneTileStreamLimitViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:SceneTileProxy = null;
			var _loc3:SceneTileStreamLimitView = null;
			if(!facade.hasMediator(SceneTileStreamLimitViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
				_loc3 = new SceneTileStreamLimitView(param1,_loc2.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3);
				facade.registerMediator(new SceneTileStreamLimitViewMediator(_loc3));
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
