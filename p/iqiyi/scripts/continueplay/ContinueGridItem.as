package continueplay {
	import flash.display.MovieClip;
	
	public dynamic class ContinueGridItem extends MovieClip {
		
		public function ContinueGridItem() {
			super();
			addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4);
		}
		
		public var mask4:MovieClip;
		
		public var normalCover:MovieClip;
		
		public var blackBar:MovieClip;
		
		public var playingCover:MovieClip;
		
		public var mask0:MovieClip;
		
		public var mask2:MovieClip;
		
		function frame1() : * {
			stop();
		}
		
		function frame2() : * {
			stop();
		}
		
		function frame3() : * {
			stop();
		}
		
		function frame4() : * {
			stop();
		}
	}
}
