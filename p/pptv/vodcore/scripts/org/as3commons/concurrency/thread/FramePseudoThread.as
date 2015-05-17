package org.as3commons.concurrency.thread
{
	import org.libspark.thread.Thread;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.libspark.thread.EnterFrameThreadExecutor;
	
	public class FramePseudoThread extends Thread implements IThread
	{
		
		private static var logger:ILogger = getLogger(FramePseudoThread);
		
		{
			Thread.initialize(new EnterFrameThreadExecutor());
		}
		
		private var _runnable:IRunnable;
		
		private var _isRunning:Boolean = false;
		
		public function FramePseudoThread(param1:IRunnable)
		{
			super();
			this._runnable = param1;
		}
		
		public function destroy() : void
		{
			this._isRunning = false;
			if(this._runnable)
			{
				this._runnable.cleanup();
				this._runnable = null;
			}
		}
		
		override public function start() : void
		{
			super.start();
			this._isRunning = true;
		}
		
		override protected function run() : void
		{
			if((this._isRunning) && (this._runnable))
			{
				try
				{
					this._runnable.process();
				}
				catch(e:Object)
				{
					logger.error("FramePseudoThread error:" + e);
				}
			}
			next(this.run);
		}
		
		public function pause() : void
		{
			this._isRunning = false;
		}
		
		public function resume() : void
		{
			this._isRunning = true;
		}
		
		public function isRunning() : Boolean
		{
			return this._isRunning;
		}
		
		public function stop() : void
		{
			this.destroy();
		}
	}
}
