package com.pplive.p2p.download
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.p2p.DRMDecoder;
	import com.pplive.play.PlayInfo;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	class DRMInfoLoader extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(DRMInfoLoader);
		
		private var _drmDecoder:DRMDecoder;
		
		private var _playInfo:PlayInfo;
		
		private var _segmentIndex:uint;
		
		private var _urlLoader:URLLoader;
		
		function DRMInfoLoader(param1:PlayInfo, param2:uint)
		{
			super();
			this._playInfo = param1;
			this._segmentIndex = param2;
		}
		
		public function get drmDecoder() : DRMDecoder
		{
			return this._drmDecoder;
		}
		
		public function start() : void
		{
			if(this._drmDecoder)
			{
				return;
			}
			var _loc1:String = this._playInfo.constructDrmURL(this._segmentIndex);
			logger.info("url: " + _loc1);
			this._urlLoader = new URLLoader();
			this._urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			this._urlLoader.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
			this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
			this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
			this._urlLoader.load(new URLRequest(_loc1));
		}
		
		public function close() : void
		{
			if(this._urlLoader)
			{
				this._urlLoader.removeEventListener(Event.COMPLETE,this.onComplete);
				this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
				this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				try
				{
					this._urlLoader.close();
				}
				catch(e:*)
				{
				}
				this._urlLoader = null;
			}
		}
		
		private function closeNotify() : void
		{
			this.close();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onComplete(param1:Event) : void
		{
			this._drmDecoder = new DRMDecoder(this._urlLoader.data);
			this.closeNotify();
		}
		
		private function onError(param1:Event) : void
		{
			logger.error(param1);
			this._drmDecoder = new DRMDecoder(null);
			this.closeNotify();
		}
	}
}
