package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class StscBox extends Box
	{
		
		public var chunkInfoTable:Array;
		
		public function StscBox()
		{
			this.chunkInfoTable = new Array();
			super();
		}
		
		override public function get type() : String
		{
			return "stsc";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			var _loc4:Object = null;
			param1.position = param1.position + 4;
			var _loc3:uint = param1.readUnsignedInt();
			while(_loc3--)
			{
				_loc4 = new Object();
				_loc4.firstChunk = param1.readUnsignedInt() - 1;
				_loc4.samplesPerChunk = param1.readUnsignedInt();
				_loc4.sampleDescriptionIndex = param1.readUnsignedInt();
				this.chunkInfoTable.push(_loc4);
			}
		}
	}
}
