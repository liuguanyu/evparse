package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class EsdsBox extends Box
	{
		
		public var AudioSpecificConfig:ByteArray;
		
		public function EsdsBox()
		{
			this.AudioSpecificConfig = new ByteArray();
			super();
		}
		
		override public function get type() : String
		{
			return "esds";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			var _loc3:uint = 0;
			var _loc4:uint = 0;
			var _loc5:* = 0;
			var _loc6:* = 0;
			var _loc7:* = 0;
			var _loc8:* = 0;
			var _loc9:* = 0;
			param1.readUnsignedInt();
			while(param1.position < param2)
			{
				_loc3 = param1.readUnsignedByte();
				switch(_loc3)
				{
					case 3:
						_loc4 = readVariableBitsUInt(param1);
						param1.position = param1.position + 2;
						_loc5 = param1.readUnsignedByte();
						_loc6 = _loc5 >> 7;
						_loc7 = (_loc5 & 64) >> 6;
						_loc8 = (_loc5 & 32) >> 5;
						if(_loc6)
						{
							param1.position = param1.position + 2;
						}
						if(_loc7)
						{
							_loc9 = param1.readUnsignedByte();
							param1.position = param1.position + _loc9;
						}
						if(_loc8)
						{
							param1.position = param1.position + 2;
						}
						continue;
					case 4:
						_loc4 = readVariableBitsUInt(param1);
						param1.position = param1.position + 13;
						continue;
					case 5:
						_loc4 = readVariableBitsUInt(param1);
						param1.readBytes(this.AudioSpecificConfig,0,_loc4);
						param1.position = param2;
						continue;
					default:
						continue;
				}
			}
		}
	}
}
