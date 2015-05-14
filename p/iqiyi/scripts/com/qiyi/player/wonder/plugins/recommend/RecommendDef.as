package com.qiyi.player.wonder.plugins.recommend
{
	public class RecommendDef extends Object
	{
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_FINISH_RECOMMEND_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_FINISH_RECOMMEND_OPEN:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "recommendAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "recommendRemoveStatus";
		
		public static const NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE:String = "finishRecommendOpenClose";
		
		public static const SOUND_URL:String = "http://static.iqiyi.com/ext/common/recommend.mp3";
		
		public static const PLAY_FINISH_SMALL_ITEM_WIDTH:uint = 160;
		
		public static const PLAY_FINISH_SMALL_ITEM_HEIGHT:uint = 90;
		
		public static const PLAY_FINISH_BIG_ITEM_WIDTH:uint = 323;
		
		public static const PLAY_FINISH_BIG_ITEM_HEIGHT:uint = 183;
		
		public static const PLAY_FINISH_ITEM_GAP:uint = 3;
		
		public function RecommendDef()
		{
			super();
		}
	}
}
