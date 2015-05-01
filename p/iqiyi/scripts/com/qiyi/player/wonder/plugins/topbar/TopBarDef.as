package com.qiyi.player.wonder.plugins.topbar {
	public class TopBarDef extends Object {
		
		public function TopBarDef() {
			super();
		}
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_SHOW:int = ++statusBegin;
		
		public static const STATUS_ALLOW_TELL_TIME:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "topBarAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "topBarRemoveStatus";
		
		public static const NOTIFIC_SCREEN_SCALE_CHANGE:String = "topBarFullScreenScaleChange";
		
		public static const NOTIFIC_REQUEST_SCALE:String = "topBarRequestScale";
		
		public static const SCALE_VALUE_50:int = 50;
		
		public static const SCALE_VALUE_75:int = 75;
		
		public static const SCALE_VALUE_100:int = 100;
		
		public static const SCALE_VALUE_FULL:int = 0;
		
		public static const TOP_BAR_HIND_DELAY:int = 3000;
	}
}
