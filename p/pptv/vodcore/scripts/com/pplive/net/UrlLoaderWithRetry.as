package com.pplive.net
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.errors.IOError;
	import flash.net.URLRequest;
	import flash.errors.IllegalOperationError;
	
	public class UrlLoaderWithRetry extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(UrlLoaderWithRetry);
		
		private var loader:URLLoader;
		
		private var url:String;
		
		private var maxRetryCount:uint;
		
		private var requestCount:uint = 0;
		
		public function UrlLoaderWithRetry(param1:uint)
		{
			super();
			this.maxRetryCount = param1;
			this.loader = new URLLoader();
			this.loader.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
			this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError,false,0,true);
			this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
			this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus,false,0,true);
		}
		
		public function destory() : void
		{
			this.closeLoader();
			this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
			this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
			this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
			this.loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
			this.loader = null;
		}
		
		public function load(param1:String) : void
		{
			this.url = param1;
			this.doLoad();
		}
		
		public function set urlLoaderDataFormat(param1:String) : void
		{
			this.loader.dataFormat = param1;
		}
		
		public function get urlLoader() : URLLoader
		{
			return this.loader;
		}
		
		public function get data() : *
		{
			return this.loader.data;
		}
		
		private function doLoad() : void
		{
			logger.info("load " + this.url + ", times:" + this.requestCount);
			if(this.requestCount != 0)
			{
				this.closeLoader();
			}
			this.requestCount++;
			try
			{
				this.loader.load(new URLRequest(this.url));
			}
			catch(e:IOError)
			{
				closeLoader();
				dispatchEvent(new LoadFailedEvent());
			}
			catch(e:SecurityError)
			{
				closeLoader();
				dispatchEvent(new LoadFailedEvent());
			}
		}
		
		private function closeLoader() : void
		{
			try
			{
				this.loader.close();
			}
			catch(error:IllegalOperationError)
			{
				logger.error("IllegalOperationError on close");
			}
		}
		
		private function onComplete(param1:Event) : void
		{
			logger.info("onComplete");
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onIOError(param1:IOErrorEvent) : void
		{
			this.onError(param1);
		}
		
		private function onSecurityError(param1:SecurityErrorEvent) : void
		{
			logger.info("onSecurityError:" + param1);
			dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
		}
		
		private function onHttpStatus(param1:HTTPStatusEvent) : void
		{
			logger.info("onHttpStatus " + param1.status);
			if(uint(param1.status / 100) == 4 || uint(param1.status / 100) == 5)
			{
				this.onError(param1);
			}
		}
		
		private function onError(param1:Event) : void
		{
			logger.info("onError " + param1);
			if(this.requestCount < this.maxRetryCount)
			{
				this.doLoad();
			}
			else
			{
				dispatchEvent(new LoadFailedEvent());
			}
		}
	}
}
