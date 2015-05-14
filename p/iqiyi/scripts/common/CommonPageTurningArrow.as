package common
{
	import flash.display.MovieClip;
	
	public dynamic class CommonPageTurningArrow extends MovieClip
	{
		
		public function CommonPageTurningArrow()
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
