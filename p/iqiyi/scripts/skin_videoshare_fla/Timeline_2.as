package skin_videoshare_fla {
	import flash.display.MovieClip;
	
	public dynamic class Timeline_2 extends MovieClip {
		
		public function Timeline_2() {
			super();
			addFrameScript(0,this.frame1,14,this.frame15);
		}
		
		function frame1() : * {
			stop();
		}
		
		function frame15() : * {
			this.visible = false;
		}
	}
}
