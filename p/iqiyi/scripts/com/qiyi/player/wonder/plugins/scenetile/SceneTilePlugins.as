package com.qiyi.player.wonder.plugins.scenetile {
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
	
	public class SceneTilePlugins extends AbstractPlugins {
		
		public function SceneTilePlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:SceneTilePlugins;
		
		public static function getInstance() : SceneTilePlugins {
			if(_instance == null) {
				_instance = new SceneTilePlugins(new SingletonClass());
			}
			return _instance;
		}
		
		override public function initModel(param1:Vector.<String> = null) : void {
			var _loc2_:* = 0;
			var _loc3_:* = 0;
			super.initModel(param1);
			if(param1) {
				_loc2_ = param1.length;
				_loc3_ = 0;
				while(_loc3_ < _loc2_) {
					switch(param1[_loc3_]) {
						case SceneTileProxy.NAME:
							if(!facade.hasProxy(SceneTileProxy.NAME)) {
								facade.registerProxy(new SceneTileProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(SceneTileProxy.NAME)) {
				facade.registerProxy(new SceneTileProxy());
			}
			
		}
		
		override public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void {
			var _loc3_:* = 0;
			var _loc4_:* = 0;
			super.initView(param1,param2);
			if(param2) {
				_loc3_ = param2.length;
				_loc4_ = 0;
				while(_loc4_ < _loc3_) {
					switch(param2[_loc4_]) {
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
					_loc4_++;
				}
			} else {
				this.createSceneTileToolViewMediator(param1);
				this.createSceneTileBarrageViewMediator(param1);
				this.createSceneTileScoreViewMediator(param1);
				this.createSceneTileStreamLimitViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
			facade.registerCommand(SceneTileDef.NOTIFIC_OPEN_CLOSE_SCORE,SceneTileScoreOpenCloseCommand);
			facade.registerCommand(SceneTileDef.NOTIFIC_OPEN_CLOSE_STREAM_LIMIT,SceneTileStreamLimitOpenCloseCommand);
		}
		
		private function createSceneTileToolViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:SceneTileProxy = null;
			var _loc3_:SceneTileToolView = null;
			if(!facade.hasMediator(SceneTileToolViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
				if(!FlashVarConfig.autoPlay) {
					_loc2_.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW,false);
				}
				_loc3_ = new SceneTileToolView(param1,_loc2_.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3_);
				facade.registerMediator(new SceneTileToolViewMediator(_loc3_));
				_loc2_.addStatus(SceneTileDef.STATUS_TOOL_OPEN);
			}
		}
		
		private function createSceneTileBarrageViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:SceneTileProxy = null;
			var _loc3_:SceneTileBarrageView = null;
			if(!facade.hasMediator(SceneTileBarrageViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
				_loc3_ = new SceneTileBarrageView(param1,_loc2_.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3_);
				facade.registerMediator(new SceneTileBarrageViewMediator(_loc3_));
				_loc2_.addStatus(SceneTileDef.STATUS_BARRAGE_OPEN);
			}
		}
		
		private function createSceneTileScoreViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:SceneTileProxy = null;
			var _loc3_:SceneTileScoreView = null;
			if(!facade.hasMediator(SceneTileScoreViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
				_loc3_ = new SceneTileScoreView(param1,_loc2_.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3_);
				facade.registerMediator(new SceneTileScoreViewMediator(_loc3_));
			}
		}
		
		private function createSceneTileStreamLimitViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:SceneTileProxy = null;
			var _loc3_:SceneTileStreamLimitView = null;
			if(!facade.hasMediator(SceneTileStreamLimitViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
				_loc3_ = new SceneTileStreamLimitView(param1,_loc2_.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3_);
				facade.registerMediator(new SceneTileStreamLimitViewMediator(_loc3_));
			}
		}
		
		private function createUserInfoVO() : UserInfoVO {
			var _loc1_:UserProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
			var _loc2_:UserInfoVO = new UserInfoVO();
			_loc2_.isLogin = _loc1_.isLogin;
			_loc2_.passportID = _loc1_.passportID;
			_loc2_.userID = _loc1_.userID;
			_loc2_.userName = _loc1_.userName;
			_loc2_.userLevel = _loc1_.userLevel;
			_loc2_.userType = _loc1_.userType;
			return _loc2_;
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
