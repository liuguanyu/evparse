package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class StssBox extends Box
	{
		
		public var syncSample:Array;
		
		public function StssBox()
		{
			this.syncSample = new Array();
			super();
		}
		
		override public function get type() : String
		{
			return "stss";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			param1.position = param1.position + 4;
			var _loc3:uint = param1.readUnsignedInt();
			while(_loc3--)
			{
				this.syncSample.push(param1.readUnsignedInt());
			}
		}
	}
}
