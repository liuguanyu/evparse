package com.qiyi.player.core.video.decoder
{
	import flash.events.IEventDispatcher;
	import com.qiyi.player.core.IDestroy;
	import flash.net.NetStream;
	import com.qiyi.player.base.pub.EnumItem;
	
	public interface IDecoder extends IEventDispatcher, IDestroy
	{
		
		function get netstream() : NetStream;
		
		function get metadata() : Object;
		
		function get bufferLength() : Number;
		
		function get time() : Number;
		
		function get bufferTime() : Number;
		
		function set bufferTime(param1:Number) : void;
		
		function get status() : EnumItem;
		
		function play(... rest) : void;
		
		function stop() : void;
		
		function seek(param1:Number) : void;
		
		function pause() : void;
		
		function resume() : void;
	}
}
