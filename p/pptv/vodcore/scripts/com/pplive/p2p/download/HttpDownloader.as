package com.pplive.p2p.download
{
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.pplive.play.PlayInfo;
	import flash.net.URLStream;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.pplive.p2p.Util;
	import com.pplive.p2p.struct.Constants;
	import flash.utils.getTimer;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import com.pplive.p2p.struct.SubPiece;
	import flash.utils.ByteArray;
	import com.pplive.p2p.events.ReceiveSubpieceEvent;
	
	class HttpDownloader extends EventDispatcher implements IDownloader
	{
		
		protected static var logger:ILogger = getLogger(HttpDownloader);
		
		public static const MAX_FAIL_TIMES_PER_HOST:uint = 5;
		
		protected var _playInfo:PlayInfo;
		
		protected var _hosts:Vector.<String>;
		
		protected var _segmentIndex:uint;
		
		protected var _maxFailTimesPerHost:uint = 5;
		
		protected var _restPlayTime:Number = 0;
		
		protected var _url:String;
		
		protected var _stream:URLStream;
		
		protected var _begin:uint;
		
		protected var _end:uint;
		
		protected var _requestTime:uint;
		
		protected var _httpStatus:int;
		
		protected var _lastReceiveTime:uint = 0;
		
		protected var _failTimes:uint;
		
		protected var _timer:Timer;
		
		function HttpDownloader(param1:PlayInfo, param2:uint)
		{
			this._hosts = new Vector.<String>();
			this._timer = new Timer(250);
			super();
			this._playInfo = param1;
			this._segmentIndex = param2;
		}
		
		public function set maxFailTimesPerHost(param1:uint) : void
		{
			this._maxFailTimesPerHost = param1;
		}
		
		public function get failTimes() : uint
		{
			return this._failTimes;
		}
		
		public function start() : void
		{
		}
		
		public function destroy() : void
		{
			this.cancel();
		}
		
		public function set restPlayTime(param1:Number) : void
		{
			this._restPlayTime = param1;
		}
		
		public function cancel() : void
		{
			this.closeStream();
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.stop();
		}
		
		public function requestHeader() : void
		{
			this.request(0,this._playInfo.segments[this._segmentIndex].headLength);
		}
		
		public function request(param1:uint, param2:uint) : void
		{
			var begin:uint = param1;
			var end:uint = param2;
			this.closeStream();
			this._begin = Util.align(begin,Constants.SUBPIECE_SIZE);
			this._end = Util.upAlign(end,Constants.SUBPIECE_SIZE);
			this.initHostsToTry();
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
			this._timer.start();
			while(this._hosts.length > 0)
			{
				try
				{
					this.createRequest();
					return;
				}
				catch(e:*)
				{
					logger.error("request: " + e);
					closeStream();
					continue;
				}
			}
			this.cancel();
			dispatchEvent(new HttpFailEvent(this._url,HttpFailEvent.HTTP_URL_ERROR,0,0,false));
		}
		
		protected function initHostsToTry() : void
		{
		}
		
		protected function constructUrl(param1:String) : String
		{
			return "";
		}
		
		protected function createRequest() : void
		{
			this._url = this.constructUrl(this._hosts.shift());
			logger.info("URL: " + this._url);
			this.closeStream();
			this.createStream();
			this._requestTime = getTimer();
			this._httpStatus = 0;
			this._stream.load(new URLRequest(this._url));
		}
		
		protected function createStream() : void
		{
			this._stream = new URLStream();
			this._stream.addEventListener(IOErrorEvent.IO_ERROR,this.onError,false,0,true);
			this._stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError,false,0,true);
			this._stream.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus,false,0,true);
			this._stream.addEventListener(ProgressEvent.PROGRESS,this.onProgress,false,0,true);
			this._stream.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
		}
		
		protected function closeStream() : void
		{
			if(this._stream != null)
			{
				this._stream.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
				this._stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
				this._stream.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
				this._stream.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
				this._stream.removeEventListener(Event.COMPLETE,this.onComplete);
				try
				{
					this._stream.close();
				}
				catch(e:*)
				{
				}
				this._stream = null;
			}
		}
		
		protected function onTimer(param1:TimerEvent) : void
		{
			var e:TimerEvent = param1;
			if(this._restPlayTime < 2 && (this.checkTimeout()))
			{
				logger.error("timeout, url: " + this._url);
				this.closeStream();
				while(this._hosts.length > 0)
				{
					try
					{
						this.createRequest();
						return;
					}
					catch(e:*)
					{
						logger.error("request: " + e);
						closeStream();
						continue;
					}
				}
				this.cancel();
				dispatchEvent(new HttpFailEvent(this._url,HttpFailEvent.HTTP_TIMEOUT_ERROR,getTimer() - this._requestTime,this._httpStatus,!(this._lastReceiveTime == 0)));
			}
		}
		
		protected function checkTimeout() : Boolean
		{
			var _loc1:uint = this._lastReceiveTime > this._requestTime?this._lastReceiveTime + 1.5 * Constants.HTTP_RECV_TIMEOUT:this._requestTime + Constants.HTTP_RECV_TIMEOUT;
			return _loc1 < getTimer();
		}
		
		protected function onHttpStatus(param1:HTTPStatusEvent) : void
		{
			this._httpStatus = param1.status;
		}
		
		protected function onError(param1:Event) : void
		{
			var event:Event = param1;
			logger.error("onError: " + event);
			this._failTimes++;
			this.closeStream();
			while(this._hosts.length > 0)
			{
				try
				{
					this.createRequest();
					return;
				}
				catch(e:*)
				{
					logger.error("request: " + e);
					closeStream();
					continue;
				}
			}
			this.cancel();
			dispatchEvent(new HttpFailEvent(this._url,event is SecurityErrorEvent?HttpFailEvent.HTTP_SECURITY_ERROR:HttpFailEvent.HTTP_IO_ERROR,getTimer() - this._requestTime,this._httpStatus,!(this._lastReceiveTime == 0)));
		}
		
		protected function onProgress(param1:ProgressEvent) : void
		{
			this.dispatchSubpieces();
		}
		
		protected function onComplete(param1:Event) : void
		{
			var _loc3:SubPiece = null;
			var _loc4:ByteArray = null;
			var _loc2:URLStream = this._stream;
			this.dispatchSubpieces();
			if(_loc2 == this._stream && this._stream.bytesAvailable > 0 && (this._begin < this._end || this._end == 0))
			{
				this._lastReceiveTime = getTimer();
				_loc3 = SubPiece.createSubPieceFromOffset(this._begin);
				_loc4 = new ByteArray();
				this._stream.readBytes(_loc4);
				dispatchEvent(new ReceiveSubpieceEvent(_loc3,_loc4));
			}
			if(_loc2 == this._stream)
			{
				this.cancel();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		protected function dispatchSubpieces() : void
		{
			var _loc2:SubPiece = null;
			var _loc3:ByteArray = null;
			var _loc1:URLStream = this._stream;
			while(this._stream == _loc1 && this._stream.bytesAvailable >= Constants.SUBPIECE_SIZE)
			{
				this._lastReceiveTime = getTimer();
				_loc2 = SubPiece.createSubPieceFromOffset(this._begin);
				this._begin = this._begin + Constants.SUBPIECE_SIZE;
				_loc3 = new ByteArray();
				this._stream.readBytes(_loc3,0,Constants.SUBPIECE_SIZE);
				dispatchEvent(new ReceiveSubpieceEvent(_loc2,_loc3));
			}
		}
	}
}
