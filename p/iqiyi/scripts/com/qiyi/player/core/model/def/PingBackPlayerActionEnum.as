package com.qiyi.player.core.model.def {
	import com.qiyi.player.base.pub.EnumItem;
	
	public class PingBackPlayerActionEnum extends Object {
		
		public function PingBackPlayerActionEnum() {
			super();
		}
		
		public static const ITEMS:Array = [];
		
		public static const BUFFER_EMPTY:EnumItem = new EnumItem(0,"bufemp",ITEMS);
		
		public static const START_PLAY:EnumItem = new EnumItem(1,"start",ITEMS);
		
		public static const STOP_PLAY:EnumItem = new EnumItem(2,"stop",ITEMS);
		
		public static const TIMMING:EnumItem = new EnumItem(3,"timing",ITEMS);
		
		public static const START_LOAD:EnumItem = new EnumItem(4,"load",ITEMS);
		
		public static const DOWN_DEFINITION:EnumItem = new EnumItem(5,"dwndef",ITEMS);
		
		public static const VRS_REQUEST_TIME:EnumItem = new EnumItem(6,"vrld",ITEMS);
		
		public static const VRS_START_LOAD:EnumItem = new EnumItem(7,"svrs",ITEMS);
		
		public static const ACTIVE_PLAY:EnumItem = new EnumItem(8,"activeplay",ITEMS);
		
		public static const READY:EnumItem = new EnumItem(9,"ready",ITEMS);
	}
}
