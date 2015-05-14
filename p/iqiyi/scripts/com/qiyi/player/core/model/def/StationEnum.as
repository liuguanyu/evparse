package com.qiyi.player.core.model.def
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class StationEnum extends Object
	{
		
		public static const ITEMS:Array = [];
		
		public static const QIYI:EnumItem = new EnumItem(0,"qiyi",ITEMS);
		
		public static const TIAN_JIN:EnumItem = new EnumItem(1,"tj",ITEMS);
		
		public static const CHONG_QING:EnumItem = new EnumItem(2,"cq",ITEMS);
		
		public function StationEnum()
		{
			super();
		}
	}
}
