package com.qiyi.player.core.video.def
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class DecoderStatusEnum extends Object
	{
		
		public static const ITEMS:Array = [];
		
		public static const STOPPED:EnumItem = new EnumItem(0,"stopped",ITEMS);
		
		public static const PLAYING:EnumItem = new EnumItem(1,"playing",ITEMS);
		
		public static const PAUSED:EnumItem = new EnumItem(2,"paused",ITEMS);
		
		public static const SEEKING:EnumItem = new EnumItem(3,"seeking",ITEMS);
		
		public static const WAITING:EnumItem = new EnumItem(4,"waiting",ITEMS);
		
		public static const FAILED:EnumItem = new EnumItem(5,"failed",ITEMS);
		
		public function DecoderStatusEnum()
		{
			super();
		}
	}
}
