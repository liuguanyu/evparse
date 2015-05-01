package com.qiyi.player.core.model.def {
	import com.qiyi.player.base.pub.EnumItem;
	
	public class LanguageEnum extends Object {
		
		public function LanguageEnum() {
			super();
		}
		
		public static const ITEMS:Array = [];
		
		public static const NONE:EnumItem = new EnumItem(0,"none",ITEMS);
		
		public static const CHINESE:EnumItem = new EnumItem(1,"zh-cn",ITEMS);
		
		public static const TRADITIONAL:EnumItem = new EnumItem(2,"zh-hk",ITEMS);
		
		public static const ENGLISH:EnumItem = new EnumItem(3,"en-us",ITEMS);
		
		public static const KOREAN:EnumItem = new EnumItem(4,"ko-kr",ITEMS);
		
		public static const JAPANESE:EnumItem = new EnumItem(5,"ja-jp",ITEMS);
		
		public static const FRENCH:EnumItem = new EnumItem(6,"fr-fr",ITEMS);
		
		public static const RUSSIAN:EnumItem = new EnumItem(7,"ru-ru",ITEMS);
		
		public static const CHINESE_AND_ENGLISH:EnumItem = new EnumItem(8,"cn-en",ITEMS);
		
		public static const CHINESE_AND_KOREAN:EnumItem = new EnumItem(9,"cn-kr",ITEMS);
		
		public static const CHINESE_AND_JAPANESE:EnumItem = new EnumItem(10,"cn-jp",ITEMS);
		
		public static const CHINESE_AND_FRENCH:EnumItem = new EnumItem(11,"cn-fr",ITEMS);
		
		public static const CHINESE_AND_RUSSIAN:EnumItem = new EnumItem(12,"cn-ru",ITEMS);
		
		public static const NOTHING:EnumItem = new EnumItem(13,"nothing",ITEMS);
	}
}
