package com.qiyi.player.wonder.plugins.ad {
	public class ADDef extends Object {
		
		public function ADDef() {
			super();
		}
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_APPEARS:int = ++statusBegin;
		
		public static const STATUS_LOADING:int = ++statusBegin;
		
		public static const STATUS_PLAYING:int = ++statusBegin;
		
		public static const STATUS_PAUSED:int = ++statusBegin;
		
		public static const STATUS_PLAY_END:int = ++statusBegin;
		
		public static const STATUS_PRE_LOADING:int = ++statusBegin;
		
		public static const STATUS_PRE_SUCCESS:int = ++statusBegin;
		
		public static const STATUS_PRE_FAILED:int = ++statusBegin;
		
		public static const STATUS_PRE_STARTED:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "ADAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "ADRemoveStatus";
		
		public static const NOTIFIC_AD_VOLUMN_CHANGED:String = "ADVolumnChanged";
		
		public static const NOTIFIC_PAUSE:String = "ADPause";
		
		public static const NOTIFIC_RESUME:String = "ADResume";
		
		public static const NOTIFIC_POPUP_OPEN:String = "ADPopupOpen";
		
		public static const NOTIFIC_POPUP_CLOSE:String = "ADPopupClose";
		
		public static const NOTIFIC_REQUEST_REPLAY_VIDEO:String = "ADRequestReplayVideo";
		
		public static const NOTIFIC_REQUEST_CHANGED_CUP_ID:String = "ADRequestChangedCupID";
		
		public static const NOTIFIC_REQUEST_UNLOAD_AD_PLAYER:String = "ADRequestUnloadADPlayer";
		
		public static const NOTIFIC_AD_UNLOADED:String = "ADNotificUnloaded";
		
		public static const ITEM_PERIOD:int = 200;
		
		public static const TOTAL_PERIOD:int = 2000;
		
		public static const DISPLAY_TIMEOUT:int = 3000;
		
		public static const AD_CONTEXT_COUNT_LIMIT:int = 2;
		
		public static const AD_CONTEXT_DURATION_LIMIT:int = 3 * 60 * 1000;
		
		public static const AD_CONTEXT_DURATION_15_LIMIT:int = 15 * 60 * 1000;
		
		public static const PRE_LOAD_TIME:int = 20000;
		
		public static const DOCK_HIND_DELAY:int = 3000;
	}
}
