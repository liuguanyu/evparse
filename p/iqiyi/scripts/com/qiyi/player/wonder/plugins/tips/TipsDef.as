package com.qiyi.player.wonder.plugins.tips {
	public class TipsDef extends Object {
		
		public function TipsDef() {
			super();
		}
		
		private static var statusBegin:int = 0;
		
		public static const STATUS_BEGIN:int = statusBegin;
		
		public static const STATUS_VIEW_INIT:int = statusBegin;
		
		public static const STATUS_OPEN:int = ++statusBegin;
		
		public static const STATUS_END:int = ++statusBegin;
		
		public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
		
		public static const NOTIFIC_ADD_STATUS:String = "tipsAddStatus";
		
		public static const NOTIFIC_REMOVE_STATUS:String = "tipsRemoveStatus";
		
		public static const NOTIFIC_REQUEST_SHOW_TIP:String = "tipsRequestShowTip";
		
		public static const NOTIFIC_REQUEST_HIDE_TIP:String = "tipsRequestHideTip";
		
		public static const NOTIFIC_UPDATE_TIP_ATTR:String = "tipsUpdateTipAttr";
		
		public static const TIP_ID_NEXT_VIDEO:String = "NextVideo";
		
		public static const TIP_ID_SWAPPING_DEF:String = "SwappingDef";
		
		public static const TIP_ID_SWAPPED_DEF:String = "SwappedDef";
		
		public static const TIP_ID_DEFINITION_LIMIT_TIPS:String = "LimitDefinition";
		
		public static const TIP_ID_SWAPPING_LIMIT_DEF:String = "SwappingLimitDefinitionDef";
		
		public static const TIP_ID_SWAPPING_DEFINITION_DEF:String = "SwappingDefinitionDef";
		
		public static const TIP_ID_SWAPPED_DEFINITION_DEF:String = "SwappedDefinitionDef";
		
		public static const TIP_ID_SWAPPED_AUTO_QD:String = "SwappedAutoQD";
		
		public static const TIP_ID_SWAP_TIP_QD:String = "SwapTipQD";
		
		public static const TIP_ID_LOOP_ON:String = "LoopOn";
		
		public static const TIP_ID_LOOP_OFF:String = "LoopOff";
		
		public static const TIP_ID_SWAPPING_TRACK:String = "SwappingTrack";
		
		public static const TIP_ID_SWAPPED_TRACK:String = "SwappedTrack";
		
		public static const TIP_ID_HOT_KEY_FF:String = "HotKeyFF";
		
		public static const TIP_ID_SKIPPED_HEAD:String = "SkippedHead";
		
		public static const TIP_ID_SKIPPING_TAIL:String = "SkippingTail";
		
		public static const TIP_ID_CHANG_SIZE_75:String = "ChangSize75";
		
		public static const TIP_ID_HISTORY_TIME:String = "HistoryTime";
		
		public static const TIP_ID_PRO_SKIP_AD:String = "ProSkipAd";
		
		public static const TIP_ID_COPYRIGHT_WILL_EXPIRE:String = "NoticeThisCopyrightWillExpire";
		
		public static const TIP_ID_TRY_WATCH:String = "TryWatch";
		
		public static const TIP_ID_TRY_WATCH_NOT_HAVE_TICKET:String = "TryWatchNotHaveTicket";
		
		public static const TIP_ID_TRY_WATCH_HAVE_TICKET:String = "TryWatchHaveTicket";
		
		public static const TIP_ID_TRY_WATCH_TOTAL:String = "TryWatchTotal";
		
		public static const TIP_ID_COPYRIGHT_FORCE_AD_TIP:String = "CopyrightForceADTip";
		
		public static const TIP_ID_FILTER_OPEN_TIP:String = "FilterOpenTip";
		
		public static const TIP_ID_FILTER_CLOSE_TIP:String = "FilterCloseTip";
		
		public static const TIP_ID_FILTER_NEST_ENJOYABLE_TIP:String = "FilterNestEnjoyableTip";
		
		public static const TIP_ID_AD_NOTICE_BUY_VIP_TIPS:String = "ADNoticeBuyVIPTips";
		
		public static const TIP_ATTR_NAME_DESCRIPTION:String = "description";
		
		public static const TIP_ATTR_NAME_DEFINITION:String = "definition";
		
		public static const TIP_ATTR_NAME_AUDIO_TRACK:String = "audiotrack";
		
		public static const TIP_ATTR_NAME_HISTORY_TIME:String = "historyTime";
		
		public static const TIP_ATTR_NAME_VIDEO_NAME:String = "videoName";
		
		public static const TIP_ATTR_NAME_EXPIRED_TIME:String = "expiredTime";
		
		public static const TIP_ATTR_NAME_LOGIN:String = "loginTip";
		
		public static const TIP_ATTR_NAME_USER_COUNT:String = "userCount";
		
		public static const TIP_ATTR_NAME_FILTER_TYPE:String = "filterType";
		
		public static const AS_EVENT_NAME_SKIP_SET:String = "skipset";
		
		public static const AS_EVENT_NAME_WATCH_START:String = "watchstart";
		
		public static const AS_EVENT_NAME_SWAPTOQD:String = "swaptoqd";
		
		public static const AS_EVENT_NAME_SCREEN_DEFAULT:String = "screendefault";
		
		public static const AS_EVENT_NAME_SWITCHOVER_NEXT:String = "switchoverNext";
		
		public static const AS_EVENT_NAME_TRY_WATCH_BUY:String = "tryWatchBuy";
		
		public static const AS_EVENT_NAME_TRY_WATCH_USE_TICKET:String = "useTicket";
		
		public static const AS_EVENT_NAME_LOGIN:String = "loginInAccount";
		
		public static const STAGE_GAP_1:int = 51;
		
		public static const STAGE_GAP_2:int = 38;
		
		public static const STAGE_GAP_3:int = 5;
		
		public static const STAGE_GAP_4:int = 33;
		
		public static const MAX_DEFINITION_STUCK:int = 3;
		
		public static const LAG_TIME_SWAP_TIP_QD:int = 60000;
		
		public static const HISTORY_MIN_TIME:int = 5000;
		
		public static const DEF_VIDEO_CURRENTTIME_MIN:uint = 30000;
		
		public static const CONSTANT_FILTER_MALE:String = "男生版";
		
		public static const CONSTANT_FILTER_FEMALE:String = "女生版";
		
		public static const CONSTANT_FILTER_COMMON:String = "大众版";
		
		public static const AUTH_TIP_TYPE_NORMAL:uint = 1;
		
		public static const AUTH_TIP_TYPE_NOT_TICKET:uint = 2;
		
		public static const AUTH_TIP_TYPE_TICKET:uint = 3;
	}
}
