package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class Mp4aBox extends ContainerBox
	{
		
		public function Mp4aBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "mp4a";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			param1.position = param1.position + 28;
			super.parse(param1,param2);
		}
	}
}
