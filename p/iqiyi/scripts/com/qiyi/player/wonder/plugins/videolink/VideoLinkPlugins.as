package com.qiyi.player.wonder.plugins.videolink
{
	import com.qiyi.player.wonder.plugins.AbstractPlugins;
	import com.qiyi.player.wonder.plugins.videolink.model.VideoLinkProxy;
	import flash.display.DisplayObjectContainer;
	import com.qiyi.player.wonder.plugins.videolink.view.VideoLinkViewMediator;
	import com.qiyi.player.wonder.body.model.UserProxy;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import com.qiyi.player.wonder.plugins.videolink.view.VideoLinkView;
	import com.iqiyi.components.panelSystem.PanelManager;
	
	public class VideoLinkPlugins extends AbstractPlugins
	{
		
		private static var _instance:VideoLinkPlugins;
		
		public function VideoLinkPlugins(param1:SingletonClass)
		{
			super();
		}
		
		public static function getInstance() : VideoLinkPlugins
		{
			if(_instance == null)
			{
				_instance = new VideoLinkPlugins(new SingletonClass());
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
						case VideoLinkProxy.NAME:
							if(!facade.hasProxy(VideoLinkProxy.NAME))
							{
								facade.registerProxy(new VideoLinkProxy());
							}
							break;
					}
					_loc3++;
				}
			}
			else if(!facade.hasProxy(VideoLinkProxy.NAME))
			{
				facade.registerProxy(new VideoLinkProxy());
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
						case VideoLinkViewMediator.NAME:
							this.createVideoLinkViewMediator(param1);
							break;
					}
					_loc4++;
				}
			}
			else
			{
				this.createVideoLinkViewMediator(param1);
			}
		}
		
		override public function initController() : void
		{
			super.initController();
		}
		
		private function createVideoLinkViewMediator(param1:DisplayObjectContainer) : void
		{
			var _loc2:UserProxy = null;
			var _loc3:UserInfoVO = null;
			var _loc4:VideoLinkProxy = null;
			var _loc5:VideoLinkView = null;
			if(!facade.hasMediator(VideoLinkViewMediator.NAME))
			{
				_loc2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
				_loc3 = new UserInfoVO();
				_loc3.isLogin = _loc2.isLogin;
				_loc3.passportID = _loc2.passportID;
				_loc3.userID = _loc2.userID;
				_loc3.userName = _loc2.userName;
				_loc3.userLevel = _loc2.userLevel;
				_loc3.userType = _loc2.userType;
				_loc4 = facade.retrieveProxy(VideoLinkProxy.NAME) as VideoLinkProxy;
				_loc5 = new VideoLinkView(param1,_loc4.status.clone(),_loc3);
				PanelManager.getInstance().register(_loc5);
				facade.registerMediator(new VideoLinkViewMediator(_loc5));
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
