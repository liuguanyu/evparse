package com.pplive.p2p.mp4.boxes
{
	public class FtypBox extends Box
	{
		
		public function FtypBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "ftyp";
		}
	}
}
