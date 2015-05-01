package com.qiyi.player.core.model.def {
	import com.qiyi.player.base.pub.EnumItem;
	
	public class StreamEnum extends Object {
		
		public function StreamEnum() {
			super();
		}
		
		public static const ITEMS:Array = [];
		
		public static const HTTP:EnumItem = new EnumItem(1,"http",ITEMS);
		
		public static const RTMP:EnumItem = new EnumItem(2,"rtmp",ITEMS);
	}
}
