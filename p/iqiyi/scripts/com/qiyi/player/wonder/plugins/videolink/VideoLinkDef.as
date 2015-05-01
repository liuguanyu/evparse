package com.qiyi.player.wonder.plugins.videolink {
	public class VideoLinkDef extends Object {
		
		public function VideoLinkDef() {
			super();
		}
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "videoLinkAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "videoLinkRemoveStatus";
		
		public static const WAITING_TIME:int = 10000;
		
		public static const LAG_TIME_SWAP_PRO_ACCELERATE:int = 120000;
		
		public static const MAX_DOWN_CLIENT_STUCK:int = 2;
		
		public static const PANEL_TYPE_VIDEOLINK:uint = 1;
		
		public static const PANEL_TYPE_DOWNLOADCLIENT:uint = 2;
		
		public static const PANEL_TYPE_ACTIVITYNOTICE:uint = 3;
		
		public static const PANEL_SHOW_TIME:uint = 15;
		
		public static const BTN_TYPE_PLAY:String = "PLAY";
		
		public static const BTN_TYPE_DOWNLOAD:String = "DOWNLOAD";
		
		public static const BTN_TYPE_INSERT:String = "INTO";
	}
}
