package com.pplive.p2p.mp4.boxes
{
	public class UnusedBox extends Box
	{
		
		public function UnusedBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "--unused--";
		}
	}
}
