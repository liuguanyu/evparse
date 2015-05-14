package com.qiyi.player.wonder.body
{
	public class BodyDef extends Object
	{
		
		private static var playerStatusBegin:int = 0;
		
		public static const PLAYER_STATUS_BEGIN:int = playerStatusBegin;
		
		public static const PLAYER_STATUS_ALREADY_LOAD_MOVIE:int = playerStatusBegin;
		
		public static const PLAYER_STATUS_ALREADY_READY:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_ALREADY_INFO_READY:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_ALREADY_START_LOAD:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_ALREADY_PLAY:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_LOAD_COMPLETE:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_PLAYING:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_PAUSED:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_SEEKING:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_WAITING:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_STOPPING:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_STOPED:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_FAILED:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_END:int = ++playerStatusBegin;
		
		public static const PLAYER_STATUS_COUNT:int = PLAYER_STATUS_END - PLAYER_STATUS_BEGIN;
		
		public static const NOTIFIC_STARTUP:String = "bodyStartUp";
		
		public static const NOTIFIC_CHECK_USER:String = "bodyCheckUser";
		
		public static const NOTIFIC_PLAYER_ADD_STATUS:String = "bodyPlayerAddStatus";
		
		public static const NOTIFIC_PLAYER_REMOVE_STATUS:String = "bodyPlayerRemoveStatus";
		
		public static const NOTIFIC_PLAYER_UPDATE_OVER_BONUS:String = "bodyPlayerUpdateOverBonus";
		
		public static const NOTIFIC_PLAYER_ERROR:String = "bodyPlayerError";
		
		public static const NOTIFIC_PLAYER_DEFINITION_SWITCHED:String = "bodyPlayerDefinitionSwitched";
		
		public static const NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED:String = "bodyPlayerAudioTrackSwitched";
		
		public static const NOTIFIC_PLAYER_GPU_CHANGED:String = "bodyPlayerGPUChanged";
		
		public static const NOTIFIC_PLAYER_PREPARE_PLAY_END:String = "bodyPlayerPreparePlayEnd";
		
		public static const NOTIFIC_PLAYER_SKIP_TRAILER:String = "bodyPlayerSkipTrailer";
		
		public static const NOTIFIC_PLAYER_START_FROM_HISTORY:String = "bodyPlayerStartFromHistory";
		
		public static const NOTIFIC_PLAYER_SKIP_TITLE:String = "bodyPlayerSkipTitle";
		
		public static const NOTIFIC_PLAYER_STUCK:String = "bodyPlayerStuck";
		
		public static const NOTIFIC_PLAYER_PREPARE_SKIP_POINT:String = "bodyPlayerPrepareSkipPoint";
		
		public static const NOTIFIC_PLAYER_ENTER_SKIP_POINT:String = "bodyPlayerEnterSkipPoint";
		
		public static const NOTIFIC_PLAYER_PRE_OUT_SKIP_POINT:String = "bodyPlayerPreOutSkipPoint";
		
		public static const NOTIFIC_PLAYER_OUT_SKIP_POINT:String = "bodyPlayerOutSkipPoint";
		
		public static const NOTIFIC_PLAYER_FRESHED_SKIP_POINT:String = "bodyPlayerFreshedSkipPoint";
		
		public static const NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT:String = "bodyPlayerEnterLeaveSkipPoint";
		
		public static const NOTIFIC_PLAYER_OUT_LEAVE_SKIP_POINT:String = "bodyPlayerOutLeaveSkipPoint";
		
		public static const NOTIFIC_PLAYER_ENJOY_TYPE_INITED:String = "bodyPlayerEnjoyTypeInited";
		
		public static const NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:String = "bodyPlayerSwitchPreActor";
		
		public static const NOTIFIC_PLAYER_LOAD_MOVIE:String = "bodyPlayerLoadMovie";
		
		public static const NOTIFIC_PLAYER_PRE_LOAD_MOVIE:String = "bodyPlayerPreLoadMovie";
		
		public static const NOTIFIC_PLAYER_PAUSE:String = "bodyPlayerPause";
		
		public static const NOTIFIC_PLAYER_PLAY:String = "bodyPlayerPlay";
		
		public static const NOTIFIC_PLAYER_REFRESH:String = "bodyPlayerRefresh";
		
		public static const NOTIFIC_PLAYER_PRE_REFRESH:String = "bodyPlayerPreRefresh";
		
		public static const NOTIFIC_PLAYER_REPLAY:String = "bodyPlayerReplay";
		
		public static const NOTIFIC_PLAYER_RESUME:String = "bodyPlayerResume";
		
		public static const NOTIFIC_PLAYER_SEEK:String = "bodyPlayerSeek";
		
		public static const NOTIFIC_PLAYER_START_LOAD:String = "bodyPlayerStartLoad";
		
		public static const NOTIFIC_PLAYER_PRE_START_LOAD:String = "bodyPlayerPreStartLoad";
		
		public static const NOTIFIC_PLAYER_STOP_LOAD:String = "bodyPlayerStopLoad";
		
		public static const NOTIFIC_PLAYER_PRE_STOP_LOAD:String = "bodyPlayerPreStopLoad";
		
		public static const NOTIFIC_PLAYER_STOP:String = "bodyPlayerStop";
		
		public static const NOTIFIC_PLAYER_PRE_STOP:String = "bodyPlayerPreStop";
		
		public static const NOTIFIC_PLAYER_RUNNING:String = "bodyPlayerRunning";
		
		public static const NOTIFIC_PLAYER_TO_FOCUS_TIP:String = "bodyPlayerToFocusTip";
		
		public static const NOTIFIC_PLAYER_ARRIVE_TRYWATCH_TIME:String = "bodyPlayerArriveTryWatchTime";
		
		public static const NOTIFIC_PLAYER_START_REFRESH:String = "bodyPlayerRefreshed";
		
		public static const NOTIFIC_PLAYER_REPLAYED:String = "bodyPlayerReplayed";
		
		public static const NOTIFIC_RESIZE:String = "bodyResize";
		
		public static const NOTIFIC_MOUSE_LAYER_CLICK:String = "bodyMouseLayerClick";
		
		public static const NOTIFIC_FULL_SCREEN:String = "bodyFullScreen";
		
		public static const NOTIFIC_LEAVE_STAGE:String = "bodyLeaveStage";
		
		public static const NOTIFIC_CHECK_USER_COMPLETE:String = "bodyCheckUserComplete";
		
		public static const NOTIFIC_CHECK_TRY_WATCH_REFRESH:String = "bodyCheckTryWatchRefresh";
		
		public static const NOTIFIC_REQUEST_INIT_PLAYER:String = "bodyRequestInitPlayer";
		
		public static const NOTIFIC_INIT_PLAYER:String = "bodyInitPlayer";
		
		public static const NOTIFIC_INIT_PLAY:String = "bodyInitPlay";
		
		public static const NOTIFIC_VIDEO_REQUEST_IMAGE:String = "bodyRequestImage";
		
		public static const NOTIFIC_CALL_JS_PLAYER_STATUS:String = "bodyCallJSPlayerStatus";
		
		public static const NOTIFIC_JS_CALL_SUBSCRIBE:String = "bodyJsCallSubscribe";
		
		public static const NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:String = "bodyJsCallContinuePlayState";
		
		public static const NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:String = "bodyJsCallNextQiyiVideoInfo";
		
		public static const NOTIFIC_JS_LIGHT_CHANGED:String = "bodyJsLightChanged";
		
		public static const NOTIFIC_JS_EXPAND_CHANGED:String = "bodyJsExpandChanged";
		
		public static const NOTIFIC_JS_CALL_SWITCH_VIDEO:String = "bodyJsCallSwitchVideo";
		
		public static const NOTIFIC_JS_CALL_SWITCH_NEXT_VIDEO:String = "bodyJsCallSwitchNextVideo";
		
		public static const NOTIFIC_JS_CALL_SWITCH_PRE_VIDEO:String = "bodyJsCallSwitchPreVideo";
		
		public static const NOTIFIC_JS_CALL_REMOVE_FROM_LIST:String = "bodyJsCallRemoveFromList";
		
		public static const NOTIFIC_JS_CALL_ADD_VIDEO_LIST:String = "bodyJsCallAddVideoList";
		
		public static const NOTIFIC_JS_CALL_SET_CYCLE_PLAY:String = "bodyJsCallSetCyclePlay";
		
		public static const NOTIFIC_JS_CALL_RESUME:String = "bodyJsCallResume";
		
		public static const NOTIFIC_JS_CALL_PAUSE:String = "bodyJsCallPause";
		
		public static const NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO:String = "bodyJsCallLoadQiyiVideo";
		
		public static const NOTIFIC_JS_CALL_SEEK:String = "bodyJsCallSeek";
		
		public static const NOTIFIC_JS_CALL_REPLAY:String = "bodyJsCallReplay";
		
		public static const NOTIFIC_JS_CALL_SET_BARRAGE_STATUS:String = "bodyJsCallSetBarrageStatus";
		
		public static const NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO:String = "bodyJsCallSetSelfSendBarrageInfo";
		
		public static const NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:String = "bodyJsCallSetSmallWindowMode";
		
		public static const NOTIFIC_JS_CALL_SET_BARRAGE_SETTING:String = "bodyJsCallSetBarrageSetting";
		
		public static const NOTIFIC_JS_CALL_SET_LOGIN_SOURCE:String = "bodyJsCallSetLoginSource";
		
		public static const NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO:String = "bodyJsCallSetActivityNoticeInfo";
		
		public static const PLAYER_ACTOR_NOTIFIC_TYPE_CUR:String = "cur";
		
		public static const PLAYER_ACTOR_NOTIFIC_TYPE_PRE:String = "pre";
		
		public static const LOAD_MOVIE_TYPE_ORIGINAL:String = "original";
		
		public static const LOAD_MOVIE_TYPE_SWITCH_TO_2D:String = "switchTo2D";
		
		public static const LOAD_MOVIE_TYPE_SWITCH_TO_3D:String = "switchTo3D";
		
		private static var viewTypeBegin:int = 1;
		
		public static const VIEW_TYPE_BEGIN:int = viewTypeBegin;
		
		public static const VIEW_TYPE_POPUP:int = viewTypeBegin;
		
		public static const VIEW_TYPE_END_POPUP:int = ++viewTypeBegin;
		
		public static const VIEW_TYPE_END:int = ++viewTypeBegin;
		
		public static const VIEW_TYPE_COUNT:int = VIEW_TYPE_END - VIEW_TYPE_BEGIN;
		
		public static const JS_STATUS_DATA_READY:String = "DataReady";
		
		public static const JS_STATUS_AD_PLAYING:String = "ADPlaying";
		
		public static const JS_STATUS_AD_PAUSED:String = "ADPaused";
		
		public static const JS_STATUS_AD_RESUMED:String = "ADResumed";
		
		public static const JS_STATUS_READY:String = "Ready";
		
		public static const JS_STATUS_START_PLAY:String = "StartPlay";
		
		public static const JS_STATUS_SEEKING:String = "Seeking";
		
		public static const JS_STATUS_WAITING:String = "Waiting";
		
		public static const JS_STATUS_PAUSED:String = "Paused";
		
		public static const JS_STATUS_PLAYING:String = "Playing";
		
		public static const JS_STATUS_STOPED:String = "Stoped";
		
		public static const JS_STATUS_ERROR:String = "Error";
		
		public static const JS_STATUS_END_PLAY:String = "EndPlay";
		
		public static const JS_DOSAMETHING_SHOW_COLLECTION_GOODS:String = "CollectionGoods";
		
		public static const JS_LOGIN_STATUS_SOURCE_SCORE:String = "JsLoginStatusSourceScore";
		
		public static const REQUEST_JS_PB_TYPE_DEMANDS:int = 1;
		
		public static const VIDEO_BOTTOM_RESERVE:int = 36;
		
		public static const PLAYER_PREPARE_TO_PLAY_END_TIME:int = 15000;
		
		public static const PLAYER_TIMER_TIME:int = 200;
		
		public static const POPUP_TWEEN_TIME:int = 500;
		
		public static const FILTER_OUT_ENJOYABLE_TIME:int = 10000;
		
		public static const BONUS_DEFAULT_COUNT_ONCE:int = 1;
		
		public function BodyDef()
		{
			super();
		}
	}
}
