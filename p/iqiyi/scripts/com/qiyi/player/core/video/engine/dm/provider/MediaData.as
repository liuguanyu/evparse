package com.qiyi.player.core.video.engine.dm.provider
{
	import flash.utils.ByteArray;
	
	public class MediaData extends Object
	{
		
		public var headers:ByteArray = null;
		
		public var bytes:ByteArray = null;
		
		public var duration:int;
		
		public var time:int;
		
		public var jumpFragment:Boolean = false;
		
		public function MediaData()
		{
			super();
		}
	}
}
