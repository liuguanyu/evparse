package com.qiyi.player.core.player.def {
	import com.qiyi.player.base.pub.EnumItem;
	
	public class PlayerUseTypeEnum extends Object {
		
		public function PlayerUseTypeEnum() {
			super();
		}
		
		public static const ITEMS:Array = [];
		
		public static const MAIN:EnumItem = new EnumItem(0,"main",ITEMS);
		
		public static const SHARE_SECTION:EnumItem = new EnumItem(1,"shareSection",ITEMS);
		
		public static const PREVIEW:EnumItem = new EnumItem(2,"preview",ITEMS);
	}
}
