package com.qiyi.player.core.model.def {
	import com.qiyi.player.base.pub.EnumItem;
	
	public class TryWatchEnum extends Object {
		
		public function TryWatchEnum() {
			super();
		}
		
		public static const ITEMS:Array = [];
		
		public static const NONE:EnumItem = new EnumItem(0,"none",ITEMS);
		
		public static const PART:EnumItem = new EnumItem(1,"part",ITEMS);
		
		public static const TOTAL:EnumItem = new EnumItem(2,"total",ITEMS);
	}
}
