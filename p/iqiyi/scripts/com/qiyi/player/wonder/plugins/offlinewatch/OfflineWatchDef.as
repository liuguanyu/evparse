package com.qiyi.player.wonder.plugins.offlinewatch
{
	public class OfflineWatchDef extends Object
	{
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "offlineWatchAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "offlineWatchRemoveStatus";
		
		public static const NOTIFIC_OPEN_CLOSE:String = "offlineWatchOpenClose";
		
		public static const OFFLINEWATCH_PANEL_SHOW_TIME:uint = 5;
		
		public function OfflineWatchDef()
		{
			super();
		}
	}
}
