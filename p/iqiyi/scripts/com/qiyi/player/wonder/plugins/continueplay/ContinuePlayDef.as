package com.qiyi.player.wonder.plugins.continueplay {
	public class ContinuePlayDef extends Object {
		
		public function ContinuePlayDef() {
			super();
		}
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_PRE_ASK_VIDEO_LIST_SUCCESS:int = ++statusBegin;
		
		public static const STATUS_PRE_ASK_VIDEO_LIST_LOADING:int = ++statusBegin;
		
		public static const STATUS_PRE_ASK_VIDEO_LIST_FAILED:int = ++statusBegin;
		
		public static const STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS:int = ++statusBegin;
		
		public static const STATUS_NEXT_ASK_VIDEO_LIST_LOADING:int = ++statusBegin;
		
		public static const STATUS_NEXT_ASK_VIDEO_LIST_FAILED:int = ++statusBegin;
		
		public static const STATUS_ASK_PRE_PAGE_SHOW:int = ++statusBegin;
		
		public static const STATUS_ASK_NEXT_PAGE_SHOW:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "continuePlayAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "continuePlayRemoveStatus";
		
		public static const NOTIFIC_OPEN_CLOSE:String = "continuePlayOpenClose";
		
		public static const NOTIFIC_INFO_LIST_CHANGED:String = "continuePlayInfoListChanged";
		
		public static const NOTIFIC_CYCLE_PLAY_CHANGED:String = "continuePlayCyclePlayChanged";
		
		public static const NOTIFIC_REQUEST_NEXT_VIDEO:String = "continuePlayRequestNextVideo";
		
		public static const NOTIFIC_REQUEST_PRE_VIDEO:String = "continuePlayRequestPreVideo";
		
		public static const NOTIFIC_REQUEST_SWITCH_VIDEO:String = "continuePlayRequestSwitchVideo";
		
		public static const NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE:String = "continuePlayRequestChangeSwitchVideoType";
		
		public static const NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED:String = "continuePlaySwitchVideoTypeChanged";
		
		public static const SWITCH_VIDEO_TYPE_NONE:int = 0;
		
		public static const SWITCH_VIDEO_TYPE_AUTO:int = 1;
		
		public static const SWITCH_VIDEO_TYPE_FLASH_LIST:int = 2;
		
		public static const SWITCH_VIDEO_TYPE_PRE_NEXT_BTN:int = 3;
		
		public static const SWITCH_VIDEO_TYPE_2D_3D_BTN:int = 4;
		
		public static const SWITCH_VIDEO_TYPE_RECOMMEND:int = 5;
		
		public static const SWITCH_VIDEO_TYPE_JS_LIST:int = 6;
		
		public static const SWITCH_VIDEO_TYPE_PROGRAM_FREE_SWITCHING:int = 7;
		
		public static const PRE_LOAD_TIME:int = int.MAX_VALUE;
		
		public static const AUTO_HIND_DELAY:int = 5000;
		
		public static const REMAIN_NUM_TO_REQUEST:int = 20;
		
		public static const SOURCE_DEFAULT_VALUE:uint = 0;
		
		public static const SOURCE_AD_VALUE:uint = 1;
		
		public static const SOURCE_QIYU_VALUE:uint = 2;
		
		public static const SOURCE_OTHER_VALUE:uint = 3;
	}
}
