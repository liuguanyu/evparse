package com.pplive.p2p.events
{
	import flash.events.Event;
	
	public class DownloadHeaderRequestEvent extends Event
	{
		
		public static const DOWNLOAD_HEADER_REQUEST:String = "__DOWNLOAD_HEADER_REQUEST__";
		
		public function DownloadHeaderRequestEvent()
		{
			super(DOWNLOAD_HEADER_REQUEST);
		}
	}
}
