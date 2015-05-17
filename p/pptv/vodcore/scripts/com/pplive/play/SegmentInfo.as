package com.pplive.play
{
	public class SegmentInfo extends Object
	{
		
		private var _rid:String;
		
		private var _duration:Number;
		
		private var _fileLength:uint;
		
		private var _headLength:uint;
		
		public function SegmentInfo(param1:String, param2:Number, param3:uint, param4:uint)
		{
			super();
			this._rid = param1;
			this._duration = param2;
			this._fileLength = param3;
			this._headLength = param4;
		}
		
		public function get rid() : String
		{
			return this._rid;
		}
		
		public function set rid(param1:String) : void
		{
			this._rid = param1;
		}
		
		public function get duration() : Number
		{
			return this._duration;
		}
		
		public function get fileLength() : uint
		{
			return this._fileLength;
		}
		
		public function get headLength() : uint
		{
			return this._headLength;
		}
	}
}
