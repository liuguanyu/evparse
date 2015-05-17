package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class StsdBox extends ContainerBox
	{
		
		public function StsdBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "stsd";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			param1.position = param1.position + 8;
			super.parse(param1,param2);
		}
	}
}
