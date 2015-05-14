package com.qiyi.player.core.player.def
{
	public class SeekTypeEnum extends Object
	{
		
		private static var begin:int = 0;
		
		public static var USER:int = 1 << ++begin;
		
		public static var SKIP_ENJOYABLE_POINT:int = 1 << ++begin;
		
		public function SeekTypeEnum()
		{
			super();
		}
	}
}
