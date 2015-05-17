package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class MdhdBox extends Box
	{
		
		public var timeScale:uint;
		
		public function MdhdBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "mdhd";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			var _loc3:uint = param1.readUnsignedInt();
			if(_loc3 == 0)
			{
				param1.position = param1.position + 8;
				this.timeScale = param1.readUnsignedInt();
			}
			else if(_loc3 == 1)
			{
				param1.position = param1.position + 16;
				this.timeScale = param1.readUnsignedInt();
			}
			
		}
	}
}
