package com.pplive.p2p.mp4.boxes
{
	public class MoovBox extends ContainerBox
	{
		
		public function MoovBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "moov";
		}
	}
}
