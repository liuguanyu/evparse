package com.pplive.p2p.mp4.boxes
{
	import flash.utils.ByteArray;
	
	public class HdlrBox extends Box
	{
		
		public var handler:String;
		
		public function HdlrBox()
		{
			super();
		}
		
		override public function get type() : String
		{
			return "hdlr";
		}
		
		public function get isVideo() : Boolean
		{
			return this.handler == "vide";
		}
		
		public function get isAudio() : Boolean
		{
			return this.handler == "soun";
		}
		
		override public function parse(param1:ByteArray, param2:uint) : void
		{
			param1.position = param1.position + 8;
			this.handler = param1.readUTFBytes(4);
		}
	}
}
