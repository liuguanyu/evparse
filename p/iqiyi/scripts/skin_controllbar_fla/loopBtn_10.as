package skin_controllbar_fla
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	public dynamic class loopBtn_10 extends MovieClip
	{
		
		public var openLoopBtn:SimpleButton;
		
		public var closeLoopBtn:SimpleButton;
		
		public function loopBtn_10()
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
