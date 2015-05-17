package org.libspark.thread
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class EnterFrameThreadExecutor extends Object implements IThreadExecutor
	{
		
		private var _clip:MovieClip;
		
		public function EnterFrameThreadExecutor()
		{
			super();
		}
		
		public function stop() : void
		{
			if(_clip == null)
			{
				return;
			}
			_clip.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			_clip = null;
		}
		
		private function enterFrameHandler(param1:Event) : void
		{
			Thread.executeAllThreads();
		}
		
		public function start() : void
		{
			if(_clip != null)
			{
				return;
			}
			_clip = new MovieClip();
			_clip.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
	}
}
