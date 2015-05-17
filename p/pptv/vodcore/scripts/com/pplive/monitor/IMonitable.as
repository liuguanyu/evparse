package com.pplive.monitor
{
	import flash.utils.Dictionary;
	
	public interface IMonitable
	{
		
		function get monitor() : Monitor;
		
		function updateMonitedAttributes(param1:Dictionary) : void;
	}
}
