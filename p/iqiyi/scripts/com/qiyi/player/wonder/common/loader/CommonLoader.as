package com.qiyi.player.wonder.common.loader
{
	import flash.events.EventDispatcher;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import com.qiyi.player.base.logging.ILogger;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import com.qiyi.player.wonder.common.event.CommonEvent;
	import com.qiyi.player.base.logging.Log;
	
	public class CommonLoader extends EventDispatcher
	{
		
		public static const EVENT_COMPLETE:String = "EVENT_COMPLETE";
		
		public static const EVENT_ERROR:String = "EVENT_ERROR";
		
		private var _loader:Loader;
		
		private var _urlLoader:URLLoader;
		
		private var _loaderVO:LoaderVO;
		
		private var _log:ILogger;
		
		public function CommonLoader()
		{
			this._log = Log.getLogger("com.qiyi.player.wonder.common.loader.CommonLoader");
			super();
		}
		
		public function startLoad(param1:LoaderVO) : void
		{
			if(this._loaderVO)
			{
				this._loaderVO.destroy();
				this._loaderVO = null;
			}
			this._loaderVO = param1;
			switch(this._loaderVO.type)
			{
				case LoaderManager.TYPE_LOADER:
					this.loader();
					break;
				case LoaderManager.TYPE_URLlOADER:
					this.urlLoader();
					break;
				default:
					this.urlLoader();
			}
		}
		
		private function loader() : void
		{
			this.destroyLoader();
			this._loader = new Loader();
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComplete);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
			this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHandler);
			this._loader.load(new URLRequest(this._loaderVO.url),new LoaderContext(true));
		}
		
		private function urlLoader() : void
		{
			this.destroyUrlLoader();
			this._urlLoader = new URLLoader();
			this._urlLoader.addEventListener(Event.COMPLETE,this.onUrlLoaderComplete);
			this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
			this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHandler);
			this._urlLoader.load(new URLRequest(this._loaderVO.url));
		}
		
		private function onLoaderComplete(param1:Event) : void
		{
			if(this._loaderVO.sucFun != null)
			{
				this._loaderVO.sucFun.call(null,this._loader.content);
			}
			dispatchEvent(new CommonEvent(EVENT_COMPLETE));
		}
		
		private function onUrlLoaderComplete(param1:Event) : void
		{
			if(this._loaderVO.sucFun != null)
			{
				this._loaderVO.sucFun.call(null,this._urlLoader.data);
			}
			dispatchEvent(new CommonEvent(EVENT_COMPLETE));
		}
		
		private function onErrorHandler(param1:Event) : void
		{
			this.destroyLoader();
			this.destroyUrlLoader();
			this._loaderVO.alreadyTry = this._loaderVO.alreadyTry + 1;
			if(this._loaderVO.alreadyTry >= this._loaderVO.retry)
			{
				if(this._loaderVO.errorFun != null)
				{
					this._loaderVO.errorFun.call(null);
				}
				this._log.info("CommonLoader loader error : " + param1.type + ",    url : " + this._loaderVO.url);
				dispatchEvent(new CommonEvent(EVENT_ERROR));
			}
			else
			{
				switch(this._loaderVO.type)
				{
					case LoaderManager.TYPE_LOADER:
						this.loader();
						break;
					case LoaderManager.TYPE_URLlOADER:
						this.urlLoader();
						break;
					default:
						this.urlLoader();
				}
			}
		}
		
		private function destroyLoader() : void
		{
			try
			{
				if(this._loader)
				{
					this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderComplete);
					this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
					this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHandler);
					this._loader.close();
					this._loader = null;
				}
			}
			catch(error:Error)
			{
			}
		}
		
		private function destroyUrlLoader() : void
		{
			try
			{
				if(this._urlLoader)
				{
					this._urlLoader.removeEventListener(Event.COMPLETE,this.onUrlLoaderComplete);
					this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler);
					this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorHandler);
					this._urlLoader.close();
					this._urlLoader = null;
				}
			}
			catch(error:Error)
			{
			}
		}
	}
}
