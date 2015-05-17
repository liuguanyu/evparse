package com.pplive.p2p.download
{
	import com.pplive.p2p.struct.RID;
	import flash.utils.getTimer;
	import com.pplive.util.URI;
	import com.pplive.play.PlayInfo;
	
	class KernelDownloader extends HttpDownloader
	{
		
		private static const KERNEL_REQUEST_TIMEOUT:uint = 25000;
		
		private var _kernelHost:String;
		
		private var _kernelPort:uint;
		
		private var _headonly:Boolean;
		
		private var _sessionId:String;
		
		private var _rid:RID;
		
		function KernelDownloader(param1:String, param2:uint, param3:PlayInfo, param4:uint, param5:String)
		{
			super(param3,param4);
			this._kernelHost = param1;
			this._kernelPort = param2;
			this._sessionId = param5;
		}
		
		public function set kernelPort(param1:uint) : void
		{
			this._kernelPort = param1;
		}
		
		public function set kernelHost(param1:String) : void
		{
			this._kernelHost = param1;
		}
		
		public function set rid(param1:RID) : void
		{
			this._rid = param1;
		}
		
		override protected function checkTimeout() : Boolean
		{
			var _loc1:uint = _lastReceiveTime > _requestTime?_lastReceiveTime + 1.5 * KERNEL_REQUEST_TIMEOUT:_requestTime + KERNEL_REQUEST_TIMEOUT;
			return _loc1 < getTimer();
		}
		
		override public function requestHeader() : void
		{
			this._headonly = true;
			super.request(0,_playInfo.segments[_segmentIndex].headLength);
		}
		
		override public function request(param1:uint, param2:uint) : void
		{
			this._headonly = false;
			super.request(param1,param2);
		}
		
		override protected function initHostsToTry() : void
		{
			_hosts.length = 0;
			var _loc1:uint = 0;
			while(_loc1 < _maxFailTimesPerHost)
			{
				_hosts.push(_playInfo.host);
				_loc1++;
			}
		}
		
		override protected function constructUrl(param1:String) : String
		{
			var _loc2:URI = new URI("");
			_loc2.protocol = "http";
			_loc2.port = this._kernelPort;
			_loc2.host = this._kernelHost;
			_loc2.path = "/ppvaplaybyopen";
			_loc2.variables.url = _playInfo.constructCdnURL(_segmentIndex,param1);
			_loc2.variables.id = this._sessionId;
			_loc2.variables.headlength = _playInfo.segments[_segmentIndex].headLength;
			_loc2.variables.BWType = _playInfo.bwType;
			_loc2.variables.type = "fpp.ppap";
			_loc2.variables.resttime = uint(_restPlayTime);
			if(this._rid)
			{
				_loc2.variables.rid = this._rid.toString();
			}
			if((_playInfo.backupHosts) && _playInfo.backupHosts.length > 0)
			{
				_loc2.variables.bakhost = _playInfo.backupHosts.join("@");
			}
			if(this._headonly)
			{
				_loc2.variables.rangeStart = 0;
				_loc2.variables.rangeEnd = _end;
				_loc2.variables.headonly = 1;
				_loc2.variables.drag = 1;
			}
			else if(!(_begin == 0) || !(_end == 0))
			{
				_loc2.variables.rangeStart = _begin;
				_loc2.variables.rangeEnd = _end;
				_loc2.variables.drag = 1;
			}
			
			if(_playInfo.isVip)
			{
				_loc2.variables.vip = 1;
			}
			_loc2.variables.source = 1;
			return _loc2.toString(true);
		}
	}
}
