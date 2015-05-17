package com.pplive.p2p.events
{
	import flash.events.Event;
	
	public class DownloadRequestEvent extends Event
	{
		
		public static const DOWNLOAD_REQUEST:String = "__DOWNLOAD_REQUEST__";
		
		public var offset:uint;
		
		public function DownloadRequestEvent(param1:uint)
		{
			super(DOWNLOAD_REQUEST);
			this.offset = param1;
		}
	}
}
