package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class Avc1Box extends ContainerBox
	{
		
		public function Avc1Box()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "avc1";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			param1.position = param1.position + 78;
			super.parse(param1,param2);
		}
	}
}
