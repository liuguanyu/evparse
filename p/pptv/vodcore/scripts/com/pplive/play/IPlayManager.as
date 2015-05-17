package com.pplive.play
{
	import flash.events.IEventDispatcher;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	public interface IPlayManager extends IEventDispatcher
	{
		
		function get playInfo() : PlayInfo;
		
		function destroy() : void;
		
		function attachVideo(param1:*) : void;
		
		function play(param1:Number = 0) : void;
		
		function set availableDelayTime(param1:uint) : void;
		
		function set isVip(param1:Boolean) : void;
		
		function seek(param1:Number) : void;
		
		function pause() : void;
		
		function resume() : void;
		
		function get volume() : Number;
		
		function set volume(param1:Number) : void;
		
		function get bufferTime() : Number;
		
		function get bufferLength() : Number;
		
		function get droppedFrame() : Number;
		
		function get time() : Number;
		
		function get stream() : NetStream;
		
		function get currentSegment() : int;
		
		function switchFT(param1:String) : void;
		
		function appendBytes(param1:ByteArray) : void;
	}
}
