package org.as3commons.concurrency.thread
{
	public interface IRunnable
	{
		
		function process() : void;
		
		function cleanup() : void;
	}
}
