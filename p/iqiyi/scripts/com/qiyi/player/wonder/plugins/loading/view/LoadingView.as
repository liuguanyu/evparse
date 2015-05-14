package com.qiyi.player.wonder.plugins.loading.view
{
	import com.iqiyi.components.panelSystem.impls.BasePanel;
	import com.qiyi.player.wonder.common.status.Status;
	import com.qiyi.player.wonder.common.vo.UserInfoVO;
	import flash.display.Loader;
	import com.qiyi.player.wonder.plugins.loading.LoadingDef;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import com.iqiyi.components.global.GlobalStage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import com.qiyi.player.wonder.common.config.FlashVarConfig;
	import gs.TweenLite;
	
	public class LoadingView extends BasePanel
	{
		
		public static const NAME:String = "com.qiyi.player.wonder.plugins.loading.view.LoadingView";
		
		private var _status:Status;
		
		private var _userInfoVO:UserInfoVO;
		
		private var _loader:Loader;
		
		private var _isComplete:Boolean = false;
		
		private var _preloaderURL:String = "";
		
		public function LoadingView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
		{
			super(NAME,param1);
			this._status = param2;
			this._userInfoVO = param3;
			hasCover = true;
		}
		
		public function onUserInfoChanged(param1:UserInfoVO) : void
		{
			this._userInfoVO = param1;
		}
		
		public function onAddStatus(param1:int) : void
		{
			this._status.addStatus(param1);
			switch(param1)
			{
				case LoadingDef.STATUS_OPEN:
					this.open();
					break;
			}
		}
		
		public function onRemoveStatus(param1:int) : void
		{
			this._status.removeStatus(param1);
			switch(param1)
			{
				case LoadingDef.STATUS_OPEN:
					this.close();
					break;
			}
		}
		
		public function onResize(param1:int, param2:int) : void
		{
			if(isOnStage)
			{
				if((this._loader) && (this._isComplete))
				{
					x = (param1 - this._loader.contentLoaderInfo.width) / 2;
					y = (param2 - this._loader.contentLoaderInfo.height) / 2;
				}
				setCoverArea(new Rectangle(0,0,param1,param2));
			}
		}
		
		public function updatePreloaderURL(param1:String) : void
		{
			if(this._preloaderURL != param1)
			{
				this._preloaderURL = param1;
				if(isOnStage)
				{
					this.startLoad();
				}
			}
		}
		
		override protected function createCover() : Sprite
		{
			var _loc1:Sprite = new Sprite();
			_loc1.graphics.beginFill(0,1);
			_loc1.graphics.drawRect(0,0,1,1);
			_loc1.graphics.endFill();
			return _loc1;
		}
		
		override public function open(param1:DisplayObjectContainer = null) : void
		{
			if(!isOnStage)
			{
				super.open(param1);
				dispatchEvent(new LoadingEvent(LoadingEvent.Evt_Open));
			}
		}
		
		override public function close() : void
		{
			if(isOnStage)
			{
				super.close();
				dispatchEvent(new LoadingEvent(LoadingEvent.Evt_Close));
			}
		}
		
		override protected function onAddToStage() : void
		{
			super.onAddToStage();
			this.startLoad();
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		override protected function onRemoveFromStage() : void
		{
			super.onRemoveFromStage();
			this.destroyLoader();
		}
		
		private function startLoad() : void
		{
			this.destroyLoader();
			this._loader = new Loader();
			addChild(this._loader);
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
			if(this._preloaderURL)
			{
				this._loader.load(new URLRequest(this._preloaderURL));
			}
			else
			{
				this._loader.load(new URLRequest(FlashVarConfig.preloaderURL));
			}
		}
		
		private function destroyLoader() : void
		{
			TweenLite.killTweensOf(this.startLoad);
			this._isComplete = false;
			if(this._loader)
			{
				removeChild(this._loader);
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
				this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
				try
				{
					this._loader.close();
				}
				catch(error:Error)
				{
				}
				this._loader = null;
			}
		}
		
		private function onComplete(param1:Event) : void
		{
			this._isComplete = true;
			this.onResize(GlobalStage.stage.stageWidth,GlobalStage.stage.stageHeight);
		}
		
		private function onIOError(param1:Event) : void
		{
			TweenLite.delayedCall(0.5,this.startLoad);
		}
		
		private function onSecurityError(param1:Event) : void
		{
			TweenLite.delayedCall(0.5,this.startLoad);
		}
	}
}
