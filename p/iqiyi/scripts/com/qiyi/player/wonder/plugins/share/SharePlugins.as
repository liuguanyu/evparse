package com.qiyi.player.wonder.plugins.share {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.share.model.ShareProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.share.view.ShareViewMediator;
	import com.qiyi.player.wonder.plugins.share.controller.ShareOpenCloseCommand;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.share.view.ShareView;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class SharePlugins extends AbstractPlugins {
		
		public function SharePlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:SharePlugins;
		
		public static function getInstance() : SharePlugins {
			if(_instance == null) {
				_instance = new SharePlugins(new SingletonClass());
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
						case ShareProxy.NAME:
							if(!facade.hasProxy(ShareProxy.NAME)) {
								facade.registerProxy(new ShareProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(ShareProxy.NAME)) {
				facade.registerProxy(new ShareProxy());
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
						case ShareViewMediator.NAME:
							this.createShareViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createShareViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
			facade.registerCommand(ShareDef.NOTIFIC_OPEN_CLOSE,ShareOpenCloseCommand);
		}
		
		private function createShareViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:UserProxy = null;
			var _loc3_:UserInfoVO = null;
			var _loc4_:ShareProxy = null;
			var _loc5_:ShareView = null;
			if(!facade.hasMediator(ShareViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3_ = new UserInfoVO();
				_loc3_.isLogin = _loc2_.isLogin;
				_loc3_.passportID = _loc2_.passportID;
				_loc3_.userID = _loc2_.userID;
				_loc3_.userName = _loc2_.userName;
				_loc3_.userLevel = _loc2_.userLevel;
				_loc3_.userType = _loc2_.userType;
				_loc4_ = facade.retrieveProxy(ShareProxy.NAME) as ShareProxy;
				_loc5_ = new ShareView(param1,_loc4_.status.clone(),_loc3_);
				PanelManager.getInstance().register(_loc5_);
				facade.registerMediator(new ShareViewMediator(_loc5_));
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
