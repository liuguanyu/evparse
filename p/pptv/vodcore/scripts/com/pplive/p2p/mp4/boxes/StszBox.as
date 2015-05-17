package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class StszBox extends Box
	{
		
		public var sampleSizeTable:Vector.<uint>;
		
		public function StszBox()
		{
			this.sampleSizeTable = new Vector.<uint>();
			super();
		}
		
		override public function get type() : String
		{
			return "stsz";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			param1.position = param1.position + 4;
			var _loc3:uint = param1.readUnsignedInt();
			var _loc4:uint = param1.readUnsignedInt();
			if(_loc3 == 0)
			{
				while(_loc4--)
				{
					this.sampleSizeTable.push(param1.readUnsignedInt());
				}
			}
			else
			{
				while(_loc4--)
				{
					this.sampleSizeTable.push(_loc3);
				}
			}
		}
	}
}
