package com.qiyi.player.wonder.plugins.dock {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.dock.model.DockProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.dock.view.DockViewMediator;
	import com.qiyi.player.wonder.body.model.PlayerProxy;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.common.sw.SwitchManager;
	import com.qiyi.player.wonder.plugins.dock.view.DockView;
	import com.qiyi.player.wonder.common.sw.SwitchDef;
	import com.iqiyi.components.global.GlobalStage;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class DockPlugins extends AbstractPlugins {
		
		public function DockPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:DockPlugins;
		
		public static function getInstance() : DockPlugins {
			if(_instance == null) {
				_instance = new DockPlugins(new SingletonClass());
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
						case DockProxy.NAME:
							if(!facade.hasProxy(DockProxy.NAME)) {
								facade.registerProxy(new DockProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(DockProxy.NAME)) {
				facade.registerProxy(new DockProxy());
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
						case DockViewMediator.NAME:
							this.createDockViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createDockViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
		}
		
		private function createDockViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:PlayerProxy = null;
			var _loc3_:UserProxy = null;
			var _loc4_:UserInfoVO = null;
			var _loc5_:SwitchManager = null;
			var _loc6_:DockProxy = null;
			var _loc7_:DockView = null;
			if(!facade.hasMediator(DockViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
				_loc3_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc4_ = new UserInfoVO();
				_loc4_.isLogin = _loc3_.isLogin;
				_loc4_.passportID = _loc3_.passportID;
				_loc4_.userID = _loc3_.userID;
				_loc4_.userName = _loc3_.userName;
				_loc4_.userLevel = _loc3_.userLevel;
				_loc4_.userType = _loc3_.userType;
				_loc5_ = SwitchManager.getInstance();
				_loc6_ = facade.retrieveProxy(DockProxy.NAME) as DockProxy;
				if(_loc5_.getStatus(SwitchDef.ID_SHOW_DOCK_SHARE)) {
					_loc6_.addStatus(DockDef.STATUS_SHARE_SHOW,false);
				}
				if((_loc5_.getStatus(SwitchDef.ID_SHOW_DOCK_LIGHT)) && !GlobalStage.isFullScreen()) {
					_loc6_.addStatus(DockDef.STATUS_LIGHT_SHOW,false);
				}
				if((_loc2_.curActor.movieInfo) && (_loc2_.curActor.movieInfo.allowDownload)) {
					_loc6_.addStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE,false);
				}
				_loc7_ = new DockView(param1,_loc6_.status.clone(),_loc4_);
				PanelManager.getInstance().register(_loc7_);
				facade.registerMediator(new DockViewMediator(_loc7_));
				_loc6_.addStatus(DockDef.STATUS_OPEN);
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
