package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class AvcCBox extends Box
	{
		
		public var AVCDecoderConfigurationRecord:ByteArray;
		
		public function AvcCBox()
		{
			this.AVCDecoderConfigurationRecord = new ByteArray();
			super();
		}
		
		override public function get type() : String
		{
			return "avcC";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			param1.readBytes(this.AVCDecoderConfigurationRecord,0,param2 - param1.position);
		}
	}
}
