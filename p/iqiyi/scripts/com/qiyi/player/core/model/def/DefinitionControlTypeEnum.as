package com.qiyi.player.core.model.def
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class DefinitionControlTypeEnum extends Object
	{
		
		public static const ITEMS:Array = [];
		
		public static const NONE:EnumItem = new EnumItem(0,"none",ITEMS);
		
		public static const BYTIME:EnumItem = new EnumItem(1,"bytime",ITEMS);
		
		public static const BYAREA:EnumItem = new EnumItem(2,"byarea",ITEMS);
		
		public static const BYIDC:EnumItem = new EnumItem(3,"byidc",ITEMS);
		
		public static const BYPLATFORM:EnumItem = new EnumItem(4,"byplatform",ITEMS);
		
		public function DefinitionControlTypeEnum()
		{
			super();
		}
	}
}
