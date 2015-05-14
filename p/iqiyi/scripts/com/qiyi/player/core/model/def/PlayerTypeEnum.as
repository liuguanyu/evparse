package com.qiyi.player.core.model.def
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class PlayerTypeEnum extends Object
	{
		
		public static const ITEMS:Array = [];
		
		public static const MAIN_STATION:EnumItem = new EnumItem(0,"main",ITEMS);
		
		public static const SHARE:EnumItem = new EnumItem(1,"share",ITEMS);
		
		public static const CASARTE:EnumItem = new EnumItem(6,"casarte",ITEMS);
		
		public static const MUSIC:EnumItem = new EnumItem(7,"music",ITEMS);
		
		public static const GUIDE:EnumItem = new EnumItem(9,"guide",ITEMS);
		
		public function PlayerTypeEnum()
		{
			super();
		}
	}
}
