package com.qiyi.player.wonder.common.status
{
	public interface IStatus
	{
		
		function get status() : Status;
		
		function addStatus(param1:int, param2:Boolean = true) : void;
		
		function removeStatus(param1:int, param2:Boolean = true) : void;
		
		function hasStatus(param1:int) : Boolean;
	}
}
