package com.qiyi.player.core.model.def
{
	import com.qiyi.player.base.pub.EnumItem;
	
	public class ChannelEnum extends Object
	{
		
		public static const ITEMS:Array = [];
		
		public static const NONE:EnumItem = new EnumItem(0,"none",ITEMS);
		
		public static const FILM:EnumItem = new EnumItem(1,"Film",ITEMS);
		
		public static const PROGRAM:EnumItem = new EnumItem(2,"Program",ITEMS);
		
		public static const DOCUMENTARY:EnumItem = new EnumItem(3,"Documentary",ITEMS);
		
		public static const CARTOON:EnumItem = new EnumItem(4,"Cartoon",ITEMS);
		
		public static const MUSIC:EnumItem = new EnumItem(5,"Music",ITEMS);
		
		public static const VARIETY:EnumItem = new EnumItem(6,"Variety",ITEMS);
		
		public static const ENTERTAINMENT:EnumItem = new EnumItem(7,"Entertainment",ITEMS);
		
		public static const GAME:EnumItem = new EnumItem(8,"Game",ITEMS);
		
		public static const TRAVEL:EnumItem = new EnumItem(9,"Travel",ITEMS);
		
		public static const AD:EnumItem = new EnumItem(10,"AD",ITEMS);
		
		public static const OPEN_CLASS:EnumItem = new EnumItem(11,"OpenClass",ITEMS);
		
		public static const EDUCATION:EnumItem = new EnumItem(12,"Education",ITEMS);
		
		public static const FASHION:EnumItem = new EnumItem(13,"fashion",ITEMS);
		
		public static const FASHION_VARIETY:EnumItem = new EnumItem(14,"fashion_variety",ITEMS);
		
		public static const CHILDREN:EnumItem = new EnumItem(15,"children",ITEMS);
		
		public static const MICRO_FILM:EnumItem = new EnumItem(16,"microfilm",ITEMS);
		
		public static const SPORTS:EnumItem = new EnumItem(17,"sports",ITEMS);
		
		public static const OLYMPIC:EnumItem = new EnumItem(18,"olympic",ITEMS);
		
		public static const AD_MICRO_VIDEO:EnumItem = new EnumItem(20,"admicrovideo",ITEMS);
		
		public static const LIFE_MICRO_VIDEO:EnumItem = new EnumItem(21,"lifeMicroVideo",ITEMS);
		
		public static const HUMOR:EnumItem = new EnumItem(22,"humor",ITEMS);
		
		public static const QI_PA:EnumItem = new EnumItem(23,"qiPa",ITEMS);
		
		public static const FINANCE:EnumItem = new EnumItem(24,"finance",ITEMS);
		
		public static const NEWS:EnumItem = new EnumItem(25,"news",ITEMS);
		
		public static const AUTO:EnumItem = new EnumItem(26,"auto",ITEMS);
		
		public static const DV:EnumItem = new EnumItem(27,"dv",ITEMS);
		
		public static const MIL:EnumItem = new EnumItem(28,"mil",ITEMS);
		
		public static const BABY:EnumItem = new EnumItem(29,"baby",ITEMS);
		
		public static const TECH:EnumItem = new EnumItem(30,"tech",ITEMS);
		
		public static const TALK_SHOW:EnumItem = new EnumItem(31,"talkshow",ITEMS);
		
		public static const HEALTH:EnumItem = new EnumItem(32,"health",ITEMS);
		
		public static const TAO_MI:EnumItem = new EnumItem(91,"taomi",ITEMS);
		
		public static const LIVE:EnumItem = new EnumItem(95,"Live",ITEMS);
		
		public static const OTHER:EnumItem = new EnumItem(97,"Other",ITEMS);
		
		public static const TEST:EnumItem = new EnumItem(99,"Test",ITEMS);
		
		public function ChannelEnum()
		{
			super();
		}
		
		public static function inShortChannel(param1:EnumItem) : Boolean
		{
			if(param1 == ChannelEnum.AD || param1 == ChannelEnum.ENTERTAINMENT || param1 == ChannelEnum.MUSIC || param1 == ChannelEnum.FASHION || param1 == ChannelEnum.MICRO_FILM || param1 == ChannelEnum.AD_MICRO_VIDEO || param1 == ChannelEnum.LIFE_MICRO_VIDEO || param1 == ChannelEnum.HUMOR || param1 == ChannelEnum.FINANCE)
			{
				return true;
			}
			return false;
		}
	}
}
