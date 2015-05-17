package com.pplive.p2p.mp4.boxes
{
	public class TrakBox extends ContainerBox
	{
		
		public function TrakBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "trak";
		}
	}
}
