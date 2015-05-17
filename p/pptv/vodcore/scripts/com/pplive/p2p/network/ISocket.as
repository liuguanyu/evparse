package com.pplive.p2p.network
{
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.events.IEventDispatcher;
	
	public interface ISocket extends IDataInput, IDataOutput, IEventDispatcher
	{
		
		function close() : void;
		
		function flush() : void;
		
		function get connected() : Boolean;
	}
}
