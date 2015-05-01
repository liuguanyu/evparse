package com.qiyi.player.wonder.plugins.feedback {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.feedback.model.FeedbackProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackView;
	import com.qiyi.player.wonder.plugins.feedback.view.FeedbackViewMediator;
	import com.qiyi.player.wonder.plugins.feedback.controller.FeebackOpenCloseCommand;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class FeedbackPlugins extends AbstractPlugins {
		
		public function FeedbackPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:FeedbackPlugins;
		
		public static function getInstance() : FeedbackPlugins {
			if(_instance == null) {
				_instance = new FeedbackPlugins(new SingletonClass());
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
						case FeedbackProxy.NAME:
							if(!facade.hasProxy(FeedbackProxy.NAME)) {
								facade.registerProxy(new FeedbackProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(FeedbackProxy.NAME)) {
				facade.registerProxy(new FeedbackProxy());
			}
			
		}
		
		override public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void {
			var _loc7_:* = 0;
			var _loc8_:* = 0;
			super.initView(param1,param2);
			var _loc3_:UserProxy = null;
			var _loc4_:UserInfoVO = null;
			var _loc5_:FeedbackProxy = null;
			var _loc6_:FeedbackView = null;
			if(param2) {
				_loc7_ = param2.length;
				_loc8_ = 0;
				while(_loc8_ < _loc7_) {
					switch(param2[_loc8_]) {
						case FeedbackViewMediator.NAME:
							this.createFeedbackViewMediator(param1);
							break;
					}
					_loc8_++;
				}
			} else {
				this.createFeedbackViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
			facade.registerCommand(FeedbackDef.NOTIFIC_OPEN_CLOSE,FeebackOpenCloseCommand);
		}
		
		private function createFeedbackViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:UserProxy = null;
			var _loc3_:UserInfoVO = null;
			var _loc4_:FeedbackProxy = null;
			var _loc5_:FeedbackView = null;
			if(!facade.hasMediator(FeedbackViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3_ = new UserInfoVO();
				_loc3_.isLogin = _loc2_.isLogin;
				_loc3_.passportID = _loc2_.passportID;
				_loc3_.userID = _loc2_.userID;
				_loc3_.userName = _loc2_.userName;
				_loc3_.userLevel = _loc2_.userLevel;
				_loc3_.userType = _loc2_.userType;
				_loc4_ = facade.retrieveProxy(FeedbackProxy.NAME) as FeedbackProxy;
				_loc5_ = new FeedbackView(param1,_loc4_.status.clone(),_loc3_);
				PanelManager.getInstance().register(_loc5_);
				facade.registerMediator(new FeedbackViewMediator(_loc5_));
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
