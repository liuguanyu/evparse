package com.pplive.p2p.mp4.boxes
{
	public class MdiaBox extends ContainerBox
	{
		
		public function MdiaBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "mdia";
		}
	}
}
