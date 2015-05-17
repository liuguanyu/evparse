package com.pplive.p2p.download
{
	import com.pplive.play.PlayInfo;
	
	class CDNHttpDownloader extends HttpDownloader
	{
		
		function CDNHttpDownloader(param1:PlayInfo, param2:uint)
		{
			super(param1,param2);
		}
		
		override protected function initHostsToTry() : void
		{
			var _loc2:String = null;
			_hosts.length = 0;
			var _loc1:uint = 0;
			while(_loc1 < _maxFailTimesPerHost)
			{
				_hosts.push(_playInfo.host);
				if(_playInfo.backupHosts != null)
				{
					for each(_loc2 in _playInfo.backupHosts)
					{
						_hosts.push(_loc2);
					}
				}
				_loc1++;
			}
		}
		
		override protected function constructUrl(param1:String) : String
		{
			return _playInfo.constructCdnURL(_segmentIndex,param1,_begin,_end);
		}
	}
}
