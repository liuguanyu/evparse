package com.pplive.p2p.mp4.boxes
{
	public class MinfBox extends ContainerBox
	{
		
		public function MinfBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "minf";
		}
	}
}
