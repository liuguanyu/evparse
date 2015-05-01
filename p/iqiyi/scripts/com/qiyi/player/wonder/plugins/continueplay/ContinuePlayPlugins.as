package com.qiyi.player.wonder.plugins.continueplay {
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
	
	public class ContinuePlayPlugins extends AbstractPlugins {
		
		public function ContinuePlayPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:ContinuePlayPlugins;
		
		public static function getInstance() : ContinuePlayPlugins {
			if(_instance == null) {
				_instance = new ContinuePlayPlugins(new SingletonClass());
			}
			return _instance;
		}
		
		override public function initModel(param1:Vector.<String> = null) : void {
			var _loc4_:* = 0;
			var _loc5_:* = 0;
			super.initModel(param1);
			var _loc2_:PlayerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
			var _loc3_:ContinuePlayProxy = null;
			if(param1) {
				_loc4_ = param1.length;
				_loc5_ = 0;
				while(_loc5_ < _loc4_) {
					switch(param1[_loc5_]) {
						case ContinuePlayProxy.NAME:
							if(!facade.hasProxy(ContinuePlayProxy.NAME)) {
								_loc3_ = new ContinuePlayProxy();
								_loc3_.injectPlayerProxy(_loc2_);
								facade.registerProxy(_loc3_);
							}
							break;
					}
					_loc5_++;
				}
			} else if(!facade.hasProxy(ContinuePlayProxy.NAME)) {
				_loc3_ = new ContinuePlayProxy();
				_loc3_.injectPlayerProxy(_loc2_);
				facade.registerProxy(_loc3_);
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
						case ContinuePlayViewMediator.NAME:
							this.createContinuePlayViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createContinuePlayViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
			facade.registerCommand(ContinuePlayDef.NOTIFIC_OPEN_CLOSE,ContinuePlayOpenCloseCommand);
			facade.registerCommand(BodyDef.NOTIFIC_JS_CALL_ADD_VIDEO_LIST,AddVideoListCommand);
			facade.registerCommand(BodyDef.NOTIFIC_JS_CALL_REMOVE_FROM_LIST,RemoveVideoListCommand);
		}
		
		private function createContinuePlayViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:UserProxy = null;
			var _loc3_:UserInfoVO = null;
			var _loc4_:ContinuePlayProxy = null;
			var _loc5_:ContinuePlayView = null;
			if(!facade.hasMediator(ContinuePlayViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3_ = new UserInfoVO();
				_loc3_.isLogin = _loc2_.isLogin;
				_loc3_.passportID = _loc2_.passportID;
				_loc3_.userID = _loc2_.userID;
				_loc3_.userName = _loc2_.userName;
				_loc3_.userLevel = _loc2_.userLevel;
				_loc3_.userType = _loc2_.userType;
				_loc4_ = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
				_loc5_ = new ContinuePlayView(param1,_loc4_.status.clone(),_loc3_);
				PanelManager.getInstance().register(_loc5_);
				facade.registerMediator(new ContinuePlayViewMediator(_loc5_));
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
