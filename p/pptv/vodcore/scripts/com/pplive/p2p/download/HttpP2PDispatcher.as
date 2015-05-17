package com.pplive.p2p.download
{
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import com.pplive.p2p.BootStrapConfig;
	import com.pplive.p2p.struct.Constants;
	import com.pplive.p2p.ResourceCache;
	
	class HttpP2PDispatcher extends Dispatcher
	{
		
		private static const MODE_IDLE:uint = 0;
		
		private static const MODE_HTTP:uint = 1;
		
		private static const MODE_P2P:uint = 2;
		
		private var _cdnDownloader:IDownloader;
		
		private var _p2pDownloader:P2PDownloader;
		
		private var _bwType:uint;
		
		private var _mode:uint = 0;
		
		private var _modeSwitchTime:uint;
		
		private var _restPlayTimeWhenSwitchMode:Number;
		
		private var _timer:Timer;
		
		function HttpP2PDispatcher(param1:ResourceCache, param2:IDownloader, param3:uint)
		{
			this._timer = new Timer(250);
			super(param1);
			this._cdnDownloader = param2;
			this._bwType = param3;
		}
		
		public function set p2pDownloader(param1:P2PDownloader) : void
		{
			this._p2pDownloader = param1;
			this.switchMode();
		}
		
		override public function get currentMethod() : String
		{
			return this._mode == MODE_HTTP?"HTTP":this._mode == MODE_P2P?"P2P":"IDLE";
		}
		
		override public function set restPlayTime(param1:Number) : void
		{
			_restPlayTime = param1;
			if(this._p2pDownloader)
			{
				this._p2pDownloader.restPlayTime = param1;
			}
			this.switchMode();
		}
		
		override public function stop() : void
		{
			this._cdnDownloader.removeEventListener(Event.COMPLETE,this.onHttpComplete);
			this._cdnDownloader.cancel();
			if(this._p2pDownloader)
			{
				this._p2pDownloader.removeEventListener(Event.COMPLETE,this.onP2PComplete);
				this._p2pDownloader.cancel();
			}
			this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
			this._timer.stop();
		}
		
		override public function requestHeader() : void
		{
			this.stop();
			_requestHeader = true;
			_offset = -1;
			this.doRequest();
		}
		
		override public function request(param1:uint) : void
		{
			this.stop();
			_requestHeader = false;
			_offset = param1;
			this.doRequest();
		}
		
		private function doRequest() : void
		{
			var _loc1:* = undefined;
			var _loc2:uint = 0;
			var _loc3:uint = 0;
			this._timer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
			this._timer.start();
			if(this._mode == MODE_IDLE)
			{
				this._mode = this.fixNewMode();
				this._modeSwitchTime = getTimer();
				this._restPlayTimeWhenSwitchMode = _restPlayTime;
			}
			if(this._mode == MODE_HTTP)
			{
				this._cdnDownloader.addEventListener(Event.COMPLETE,this.onHttpComplete,false,0,true);
				if(_requestHeader)
				{
					_loc1 = HttpDispatcher.fixRequestRange(_resource,0,_resource.headLength);
				}
				else
				{
					_loc1 = HttpDispatcher.fixRequestRange(_resource,_offset,0);
				}
				if(_loc1)
				{
					this._cdnDownloader.request(_loc1.begin,_loc1.end);
				}
				else
				{
					this.stop();
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			else if(this._mode == MODE_P2P)
			{
				this._p2pDownloader.addEventListener(Event.COMPLETE,this.onP2PComplete,false,0,true);
				if(_requestHeader)
				{
					_loc2 = 0;
					_loc3 = _resource.headLength;
				}
				else
				{
					_loc2 = _offset;
					_loc3 = _resource.length;
				}
				_loc1 = HttpDispatcher.fixRequestRange(_resource,_loc2,_loc3,0);
				if(!_loc1)
				{
					this.stop();
					dispatchEvent(new Event(Event.COMPLETE));
					return;
				}
				while(_loc1)
				{
					this._p2pDownloader.request(_loc1.begin,_loc1.end);
					if(_loc1.end == 0 || _loc1.end >= _loc3)
					{
						break;
					}
					_loc1 = HttpDispatcher.fixRequestRange(_resource,_loc1.end,_loc3,0);
				}
			}
			
		}
		
		private function get isRequesting() : Boolean
		{
			return (_requestHeader) || _offset >= 0;
		}
		
		private function switchMode() : void
		{
			var _loc1:uint = 0;
			if(this.isRequesting)
			{
				_loc1 = this.fixNewMode();
				if(this._mode != _loc1)
				{
					this.stop();
					this._mode = _loc1;
					this._modeSwitchTime = getTimer();
					this._restPlayTimeWhenSwitchMode = _restPlayTime;
					this.doRequest();
				}
			}
		}
		
		private function fixNewMode() : uint
		{
			if(!this._p2pDownloader || !BootStrapConfig.DOWNLOAD_P2P_ENABLED)
			{
				return MODE_HTTP;
			}
			if(_restPlayTime >= this.startP2PRestPlayTime)
			{
				return MODE_P2P;
			}
			if(_restPlayTime < this.resumeHttpRestPlayTime)
			{
				if(this._mode == MODE_P2P)
				{
					if(this._modeSwitchTime + BootStrapConfig.MIN_P2P_MODE_DURATION * 1000 > getTimer() && this._p2pDownloader.connectionCount >= 5 || _restPlayTime > 5 && _restPlayTime > this._restPlayTimeWhenSwitchMode)
					{
						return MODE_P2P;
					}
					return MODE_HTTP;
				}
				if(this._mode == MODE_HTTP)
				{
					if(this._modeSwitchTime + this.maxHttpModeDuration * 1000 < getTimer() && this._p2pDownloader.connectionCount >= 5)
					{
						return MODE_P2P;
					}
					return MODE_HTTP;
				}
				return MODE_HTTP;
			}
			if(this._mode != MODE_IDLE)
			{
				return this._mode;
			}
			return this.isHttpPreferred?MODE_HTTP:MODE_P2P;
		}
		
		private function get resumeHttpRestPlayTime() : Number
		{
			if(this.isHttpPreferred)
			{
				return BootStrapConfig.DOWNLOAD_RESUME_HTTP_REST_PLAY_TIME + 30;
			}
			return BootStrapConfig.DOWNLOAD_RESUME_HTTP_REST_PLAY_TIME;
		}
		
		private function get startP2PRestPlayTime() : Number
		{
			if(this.isHttpPreferred)
			{
				return BootStrapConfig.DOWNLOAD_START_P2P_REST_PLAY_TIME + 30;
			}
			return BootStrapConfig.DOWNLOAD_START_P2P_REST_PLAY_TIME;
		}
		
		private function get isHttpPreferred() : Boolean
		{
			return this._bwType == Constants.BWTYPE_HTTP_MORE || this._bwType == Constants.BWTYPE_HTTP_PREFERRED;
		}
		
		private function get maxHttpModeDuration() : uint
		{
			return this.isHttpPreferred?BootStrapConfig.MAX_HTTP_MODE_DURATION + 30:BootStrapConfig.MAX_HTTP_MODE_DURATION;
		}
		
		private function onTimer(param1:TimerEvent) : void
		{
		}
		
		private function onHttpComplete(param1:Event) : void
		{
			this.doRequest();
		}
		
		private function onP2PComplete(param1:Event) : void
		{
			this.stop();
			dispatchEvent(param1);
		}
	}
}
