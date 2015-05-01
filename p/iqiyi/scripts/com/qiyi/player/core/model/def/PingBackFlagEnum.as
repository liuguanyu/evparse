package com.qiyi.player.core.model.def {
	import com.qiyi.player.base.pub.EnumItem;
	
	public class PingBackFlagEnum extends Object {
		
		public function PingBackFlagEnum() {
			super();
		}
		
		public static const ITEMS:Array = [];
		
		public static const ERROR:EnumItem = new EnumItem(0,"error",ITEMS);
		
		public static const PLAYER_ACT:EnumItem = new EnumItem(1,"plyract",ITEMS);
		
		public static const USER_ACT:EnumItem = new EnumItem(2,"usract",ITEMS);
		
		public static const STU_ENV:EnumItem = new EnumItem(3,"stuenv",ITEMS);
	}
}
