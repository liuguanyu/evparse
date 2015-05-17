package com.pplive.p2p.download
{
	import flash.events.Event;
	import com.pplive.p2p.struct.SubPiece;
	import com.pplive.p2p.ResourceCache;
	
	class KernelHttpDispatcher extends HttpDispatcher
	{
		
		function KernelHttpDispatcher(param1:ResourceCache, param2:IDownloader)
		{
			super(param1,param2);
		}
		
		override public function requestHeader() : void
		{
			stop();
			_requestHeader = true;
			_offset = -1;
			_downloader.addEventListener(Event.COMPLETE,onHttpComplete,false,0,true);
			var _loc1:SubPiece = _resource.getFirstSubPieceMissed(0);
			if(_loc1.offset >= _resource.headLength)
			{
				stop();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				_downloader.requestHeader();
			}
		}
	}
}
