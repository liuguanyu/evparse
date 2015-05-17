package org.as3commons.concurrency.thread
{
	public interface IThread
	{
		
		function destroy() : void;
		
		function start() : void;
		
		function pause() : void;
		
		function resume() : void;
		
		function isRunning() : Boolean;
		
		function stop() : void;
	}
}
