package com.pplive.p2p.download
{
	import flash.events.EventDispatcher;
	import com.pplive.p2p.ResourceCache;
	
	class Dispatcher extends EventDispatcher
	{
		
		protected var _resource:ResourceCache;
		
		protected var _restPlayTime:Number = 0;
		
		protected var _requestHeader:Boolean;
		
		protected var _offset:int = -1;
		
		function Dispatcher(param1:ResourceCache)
		{
			super();
			this._resource = param1;
		}
		
		public function set restPlayTime(param1:Number) : void
		{
			this._restPlayTime = param1;
		}
		
		public function get currentMethod() : String
		{
			return "";
		}
		
		public function requestHeader() : void
		{
		}
		
		public function request(param1:uint) : void
		{
		}
		
		public function stop() : void
		{
		}
	}
}
