package com.qiyi.player.core.model.def
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class DefinitionEnum extends Object
	{
		
		public static const ITEMS:Array = [];
		
		public static const NONE:EnumItem = new EnumItem(0,"none",ITEMS);
		
		public static const STANDARD:EnumItem = new EnumItem(1,"standard",ITEMS);
		
		public static const HIGH:EnumItem = new EnumItem(2,"high",ITEMS);
		
		public static const SUPER:EnumItem = new EnumItem(3,"super",ITEMS);
		
		public static const SUPER_HIGH:EnumItem = new EnumItem(4,"super-high",ITEMS);
		
		public static const FULL_HD:EnumItem = new EnumItem(5,"fullhd",ITEMS);
		
		public static const FOUR_K:EnumItem = new EnumItem(10,"4k",ITEMS);
		
		public static const LIMIT:EnumItem = new EnumItem(96,"topspeed",ITEMS);
		
		public function DefinitionEnum()
		{
			super();
		}
	}
}
