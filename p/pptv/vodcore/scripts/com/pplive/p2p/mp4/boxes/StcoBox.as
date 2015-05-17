package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class StcoBox extends Box
	{
		
		public var chunkOffsetTable:Vector.<uint>;
		
		public function StcoBox()
		{
			this.chunkOffsetTable = new Vector.<uint>();
			super();
		}
		
		override public function get type() : String
		{
			return "stco";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			param1.position = param1.position + 4;
			var _loc3:uint = param1.readUnsignedInt();
			while(_loc3--)
			{
				this.chunkOffsetTable.push(param1.readUnsignedInt());
			}
		}
	}
}
