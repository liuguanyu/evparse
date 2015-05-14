package com.qiyi.player.core.video.def
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class VideoAccEnum extends Object
	{
		
		public static const ITEMS:Array = [];
		
		public static const UNKNOWN:EnumItem = new EnumItem(0,"unknown",ITEMS);
		
		public static const GPU_ACCELERATED:EnumItem = new EnumItem(1,"GPUAccelerated",ITEMS);
		
		public static const GPU_RENDERING:EnumItem = new EnumItem(2,"GPURendering",ITEMS);
		
		public static const CPU_ACCELERATED:EnumItem = new EnumItem(3,"CPUAccelerated",ITEMS);
		
		public static const CPU_SOFTWARE:EnumItem = new EnumItem(4,"CPUSoftware",ITEMS);
		
		public function VideoAccEnum()
		{
			super();
		}
	}
}
