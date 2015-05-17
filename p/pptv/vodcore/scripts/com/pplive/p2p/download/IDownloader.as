package com.pplive.p2p.download
{
	import flash.events.IEventDispatcher;
	
	interface IDownloader extends IEventDispatcher
	{
		
		function start() : void;
		
		function destroy() : void;
		
		function set restPlayTime(param1:Number) : void;
		
		function requestHeader() : void;
		
		function request(param1:uint, param2:uint) : void;
		
		function cancel() : void;
	}
}
