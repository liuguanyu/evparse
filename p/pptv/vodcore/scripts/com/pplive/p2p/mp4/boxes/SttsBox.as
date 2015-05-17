package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class SttsBox extends Box
	{
		
		public var sampleCount:uint = 0;
		
		public var sampleDeltaArray:Array;
		
		public var deltaSum:uint = 0;
		
		public function SttsBox()
		{
			this.sampleDeltaArray = new Array();
			super();
		}
		
		override public function get type() : String
		{
			return "stts";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			var _loc4:uint = 0;
			var _loc5:uint = 0;
			var _loc6:uint = 0;
			param1.position = param1.position + 4;
			var _loc3:uint = param1.readUnsignedInt();
			while(_loc3--)
			{
				_loc4 = param1.readUnsignedInt();
				_loc5 = param1.readUnsignedInt();
				this.sampleCount = this.sampleCount + _loc4;
				_loc6 = 0;
				while(_loc6 < _loc4)
				{
					this.sampleDeltaArray.push(this.deltaSum);
					this.deltaSum = this.deltaSum + _loc5;
					_loc6++;
				}
			}
		}
	}
}
