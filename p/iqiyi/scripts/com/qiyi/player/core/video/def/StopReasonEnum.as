package com.qiyi.player.core.video.def {
	import com.qiyi.player.base.pub.EnumItem;
	
	public class StopReasonEnum extends Object {
		
		public function StopReasonEnum() {
			super();
		}
		
		public static const ITEMS:Array = [];
		
		public static const USER:EnumItem = new EnumItem(1,"user",ITEMS);
		
		public static const SKIP_TRAILER:EnumItem = new EnumItem(2,"trailer",ITEMS);
		
		public static const REACH_ASSIGN:EnumItem = new EnumItem(3,"assign",ITEMS);
		
		public static const STOP:EnumItem = new EnumItem(4,"stop",ITEMS);
		
		public static const REFRESH:EnumItem = new EnumItem(5,"refresh",ITEMS);
	}
}
