package com.qiyi.player.wonder.plugins.videolink {
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.videolink.model.VideoLinkProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.videolink.view.VideoLinkViewMediator;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.videolink.view.VideoLinkView;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class VideoLinkPlugins extends AbstractPlugins {
		
		public function VideoLinkPlugins(param1:SingletonClass) {
			super();
		}
		
		private static var _instance:VideoLinkPlugins;
		
		public static function getInstance() : VideoLinkPlugins {
			if(_instance == null) {
				_instance = new VideoLinkPlugins(new SingletonClass());
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
						case VideoLinkProxy.NAME:
							if(!facade.hasProxy(VideoLinkProxy.NAME)) {
								facade.registerProxy(new VideoLinkProxy());
							}
							break;
					}
					_loc3_++;
				}
			} else if(!facade.hasProxy(VideoLinkProxy.NAME)) {
				facade.registerProxy(new VideoLinkProxy());
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
						case VideoLinkViewMediator.NAME:
							this.createVideoLinkViewMediator(param1);
							break;
					}
					_loc4_++;
				}
			} else {
				this.createVideoLinkViewMediator(param1);
			}
		}
		
		override public function initController() : void {
			super.initController();
		}
		
		private function createVideoLinkViewMediator(param1:DisplayObjectContainer) : void {
			var _loc2_:UserProxy = null;
			var _loc3_:UserInfoVO = null;
			var _loc4_:VideoLinkProxy = null;
			var _loc5_:VideoLinkView = null;
			if(!facade.hasMediator(VideoLinkViewMediator.NAME)) {
				_loc2_ = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3_ = new UserInfoVO();
				_loc3_.isLogin = _loc2_.isLogin;
				_loc3_.passportID = _loc2_.passportID;
				_loc3_.userID = _loc2_.userID;
				_loc3_.userName = _loc2_.userName;
				_loc3_.userLevel = _loc2_.userLevel;
				_loc3_.userType = _loc2_.userType;
				_loc4_ = facade.retrieveProxy(VideoLinkProxy.NAME) as VideoLinkProxy;
				_loc5_ = new VideoLinkView(param1,_loc4_.status.clone(),_loc3_);
				PanelManager.getInstance().register(_loc5_);
				facade.registerMediator(new VideoLinkViewMediator(_loc5_));
			}
		}
	}
}
class SingletonClass extends Object {
	
	function SingletonClass() {
		super();
	}
}
