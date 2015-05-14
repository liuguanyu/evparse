package topbar
{
	import flash.display.MovieClip;
	
	public dynamic class TopBarScaleSizeFull extends MovieClip
	{
		
		public function TopBarScaleSizeFull()
		{
			super();
			addFrameScript(0,this.frame1);
		}
		
		function frame1() : *
		{
			stop();
		}
	}
}
