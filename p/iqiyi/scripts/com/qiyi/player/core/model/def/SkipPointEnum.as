package com.qiyi.player.core.model.def {
	import com.qiyi.player.base.pub.EnumItem;
	
	public class SkipPointEnum extends Object {
		
		public function SkipPointEnum() {
			super();
		}
		
		public static const ITEMS:Array = [];
		
		public static const AD:EnumItem = new EnumItem(1,"ad",ITEMS);
		
		public static const OTHER:EnumItem = new EnumItem(2,"other",ITEMS);
		
		public static const TITLE:EnumItem = new EnumItem(3,"title",ITEMS);
		
		public static const TRAILER:EnumItem = new EnumItem(4,"trailer",ITEMS);
		
		public static const SEEKABLE:EnumItem = new EnumItem(5,"seekable",ITEMS);
		
		public static const ENJOYABLE:EnumItem = new EnumItem(6,"enjoyable",ITEMS);
		
		public static const ENJOYABLE_ITEMS:Array = [];
		
		public static const ENJOYABLE_SUB_COMMON:EnumItem = new EnumItem(1,"enjoyableSubCommon",ENJOYABLE_ITEMS);
		
		public static const ENJOYABLE_SUB_MALE:EnumItem = new EnumItem(2,"enjoyableSubMale",ENJOYABLE_ITEMS);
		
		public static const ENJOYABLE_SUB_FEMALE:EnumItem = new EnumItem(3,"enjoyableSubFemale",ENJOYABLE_ITEMS);
	}
}
