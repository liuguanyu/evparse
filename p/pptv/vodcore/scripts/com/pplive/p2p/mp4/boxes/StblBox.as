package com.pplive.p2p.mp4.boxes
{
	public class StblBox extends ContainerBox
	{
		
		public function StblBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "stbl";
		}
	}
}
