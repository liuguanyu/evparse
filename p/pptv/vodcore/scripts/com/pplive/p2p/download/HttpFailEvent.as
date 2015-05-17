package com.pplive.p2p.download
{
	import flash.events.Event;
	
	public class HttpFailEvent extends Event
	{
		
		public static const HTTP_FAIL_EVENT:String = "__HTTP_FAIL_EVENT__";
		
		public static const HTTP_IO_ERROR:uint = 1;
		
		public static const HTTP_SECURITY_ERROR:uint = 2;
		
		public static const HTTP_URL_ERROR:uint = 3;
		
		public static const HTTP_TIMEOUT_ERROR:uint = 4;
		
		public var url:String;
		
		public var error:uint;
		
		public var interval:uint;
		
		public var httpStatus:int;
		
		public var hasReceivedData:Boolean;
		
		public function HttpFailEvent(param1:String, param2:uint, param3:uint, param4:int, param5:Boolean)
		{
			super(HTTP_FAIL_EVENT);
			this.url = param1;
			this.error = param2;
			this.interval = param3;
			this.httpStatus = param4;
			this.hasReceivedData = param5;
		}
		
		override public function clone() : Event
		{
			return new HttpFailEvent(this.url,this.error,this.interval,this.httpStatus,this.hasReceivedData);
		}
	}
}
