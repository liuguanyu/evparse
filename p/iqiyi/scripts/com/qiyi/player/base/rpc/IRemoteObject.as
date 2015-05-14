package com.qiyi.player.base.rpc
{
	import flash.events.IEventDispatcher;
	import com.qiyi.player.base.pub.EnumItem;
	
	public interface IRemoteObject extends IEventDispatcher
	{
		
		function get id() : Number;
		
		function get name() : String;
		
		function get retryMaxCount() : int;
		
		function get retryCount() : int;
		
		function initialize() : void;
		
		function update() : void;
		
		function destroy() : void;
		
		function getData() : Object;
		
		function get url() : String;
		
		function get status() : EnumItem;
	}
}
