package com.qiyi.player.core.model.def
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class ScreenEnum extends Object
	{
		
		public static const ITEMS:Array = [];
		
		public static const TWO_D:EnumItem = new EnumItem(2,"2D",ITEMS);
		
		public static const THREE_D:EnumItem = new EnumItem(3,"3D",ITEMS);
		
		public function ScreenEnum()
		{
			super();
		}
	}
}
