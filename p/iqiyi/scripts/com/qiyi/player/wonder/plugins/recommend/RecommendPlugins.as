package com.qiyi.player.wonder.plugins.recommend {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.recommend.view.RecommendViewMediator;
	import com.qiyi.player.wonder.plugins.recommend.controller.RecommendOpenCloseCommand;
	import com.qiyi.player.wonder.plugins.recommend.view.RecommendView;
	import com.iqiyi.components.panelSystem.PanelManager;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.body.model.UserProxy;
	
	public class RecommendPlugins extends AbstractPlugins {
		
		public function RecommendPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:RecommendPlugins;
		
		public static function getInstance() : RecommendPlugins {
			if(_instance == null) {
				_instance = new RecommendPlugins(new SingletonClass());
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
						case RecommendProxy.NAME:
							if(!facade.hasProxy(RecommendProxy.NAME)) {
								facade.registerProxy(new RecommendProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(RecommendProxy.NAME)) {
				facade.registerProxy(new RecommendProxy());
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
						case RecommendViewMediator.NAME:
							this.createRecommendViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createRecommendViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
			facade.registerCommand(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE,RecommendOpenCloseCommand);
		}
		
		private function createRecommendViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:RecommendProxy = null;
			var _loc3_:RecommendView = null;
			if(!facade.hasMediator(RecommendViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(RecommendProxy.NAME) as RecommendProxy;
				_loc3_ = new RecommendView(param1,_loc2_.status.clone(),this.createUserInfoVO());
				PanelManager.getInstance().register(_loc3_);
				facade.registerMediator(new RecommendViewMediator(_loc3_));
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
