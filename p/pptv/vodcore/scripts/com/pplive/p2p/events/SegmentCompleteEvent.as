package com.pplive.p2p.events
{
	import flash.events.Event;
	
	public class SegmentCompleteEvent extends Event
	{
		
		public static const SEGMENT_COMPLETE:String = "SEGMENT_COMPLETE";
		
		public var videoTimeStamp:uint;
		
		public var audioTimeStamp:uint;
		
		public function SegmentCompleteEvent(param1:uint, param2:uint)
		{
			super(SEGMENT_COMPLETE);
			this.videoTimeStamp = param1;
			this.audioTimeStamp = param2;
		}
		
		override public function clone() : Event
		{
			return new SegmentCompleteEvent(this.videoTimeStamp,this.audioTimeStamp);
		}
	}
}
