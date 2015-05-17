package com.pplive.p2p.download
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import flash.net.URLStream;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import com.pplive.p2p.events.CDNCheckEvent;
	import flash.utils.clearTimeout;
	import flash.events.ErrorEvent;
	import com.pplive.play.PlayInfo;
	
	public class CDNChecker extends EventDispatcher
	{
		
		private static var logger:ILogger = getLogger(CDNChecker);
		
		private var _urls:Vector.<String>;
		
		private var _streams:Vector.<URLStream>;
		
		private var _isFinished:Boolean = false;
		
		private var _error:uint = 0;
		
		private var _timeout:uint;
		
		public function CDNChecker(param1:PlayInfo)
		{
			var _loc4:String = null;
			this._urls = new Vector.<String>();
			this._streams = new Vector.<URLStream>();
			super();
			var _loc2:String = param1.constructCdnURL(0,param1.host,0,1024);
			var _loc3:Vector.<String> = param1.backupHosts;
			this._urls.push(_loc2);
			this._urls.push(_loc2);
			if((_loc3) && (_loc3.length))
			{
				for each(_loc4 in _loc3)
				{
					_loc2 = param1.constructCdnURL(0,_loc4,0,1024);
					this._urls.push(_loc2);
					this._urls.push(_loc2);
				}
			}
		}
		
		public function start(param1:uint) : void
		{
			var _loc2:* = 0;
			var _loc3:uint = 0;
			var _loc4:URLStream = null;
			if(this._streams.length == 0)
			{
				_loc3 = this._urls.length;
				_loc2 = 0;
				while(_loc2 < _loc3)
				{
					_loc4 = new URLStream();
					_loc4.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus,false,0,true);
					_loc4.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
					_loc4.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
					this._streams.push(_loc4);
					_loc2++;
				}
				_loc2 = 0;
				while(_loc2 < _loc3)
				{
					logger.info("check: " + this._urls[_loc2]);
					this._streams[_loc2].load(new URLRequest(this._urls[_loc2]));
					_loc2++;
				}
				this._timeout = setTimeout(this.onTimeout,param1 * 1000);
			}
		}
		
		public function get error() : uint
		{
			return this._error;
		}
		
		public function get isFinished() : Boolean
		{
			return this._isFinished;
		}
		
		private function onTimeout() : void
		{
			logger.error("onTimeout");
			this.clear();
			if(this._error == 0)
			{
				this._error = 408;
			}
			dispatchEvent(new CDNCheckEvent(CDNCheckEvent.FAIL,this._error));
		}
		
		private function closeStream(param1:URLStream, param2:Boolean) : void
		{
			var i:int = 0;
			var s:URLStream = param1;
			var drop:Boolean = param2;
			s.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
			s.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
			s.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
			try
			{
				s.close();
			}
			catch(e:*)
			{
			}
			if(drop)
			{
				i = this._streams.indexOf(s);
				if(i >= 0)
				{
					this._streams.splice(i,1);
				}
			}
		}
		
		private function closeAllStream() : void
		{
			var _loc1:URLStream = null;
			for each(_loc1 in this._streams)
			{
				this.closeStream(_loc1,false);
			}
			this._streams.length = 0;
		}
		
		private function clear() : void
		{
			this.closeAllStream();
			clearTimeout(this._timeout);
			this._timeout = 0;
			this._isFinished = true;
		}
		
		private function onHttpStatus(param1:HTTPStatusEvent) : void
		{
			logger.info(param1.status);
			if(param1.status >= 200 && param1.status < 400)
			{
				logger.info("OK: " + param1);
				this.clear();
				dispatchEvent(new CDNCheckEvent(CDNCheckEvent.OK,param1.status));
			}
			if(param1.status >= 400)
			{
				this._error = param1.status;
			}
		}
		
		private function onError(param1:ErrorEvent) : void
		{
			logger.warn("error: " + param1);
			this.closeStream(param1.target as URLStream,true);
			logger.info("left: " + this._streams.length);
			if(this._streams.length == 0)
			{
				this.clear();
				if(this._error == 0)
				{
					this._error = 408;
				}
				dispatchEvent(new CDNCheckEvent(CDNCheckEvent.FAIL,this._error));
			}
		}
	}
}
