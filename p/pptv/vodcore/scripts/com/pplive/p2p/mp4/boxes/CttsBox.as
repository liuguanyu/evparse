package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class CttsBox extends Box
	{
		
		public var sampleCompositionTimeTable:Vector.<uint>;
		
		public function CttsBox()
		{
			this.sampleCompositionTimeTable = new Vector.<uint>();
			super();
		}
		
		override public function get type() : String
		{
			return "ctts";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			var _loc4:uint = 0;
			var _loc5:uint = 0;
			param1.position = param1.position + 4;
			var _loc3:uint = param1.readUnsignedInt();
			while(_loc3--)
			{
				_loc4 = param1.readUnsignedInt();
				_loc5 = param1.readUnsignedInt();
				while(_loc4--)
				{
					this.sampleCompositionTimeTable.push(_loc5);
				}
			}
		}
	}
}
